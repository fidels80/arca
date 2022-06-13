*/* Tokens.prg

#include dfox.h

external array gaVars
external array gaFoxVar


*/========================================================
define class CToken as CObject
*/========================================================
*/ A record which gathers Token's properties.
*/ Here, "token" stands for "token found in VFP compiled expressions".
*/--------------------------------------------------------
   typ  = P_NULL
   deg  = 0
   dot  = ''
   prio = 100
   associatif = .F.
   txt  = ""
   fct  = 0
enddefine


function NextToken( b as Byte ) as CToken

   local i as integer
   local w as word
   local d as byte
   local f as number
   local s as string
   local dec
   local dble
   local token as CToken
   local loStmt as CMemory
   local lnWidth
   local lookAhead
   
   * --- I don't like but it is due to the new way VFP9 handles the 
   *     "field in ( expr1, expr2, ... )" in where clause of 
   *     a select. Is not very kind. A comma separator is seen
   *     in an compiled expression. And a special tag 0xFF00
   *     followed by the length of a commated list of compiled
   *     expression.
   *     Ex: FC 43 F70200 FF00 0700 F70300 07 F70400 D5 FD
   *       <E> ArgList b  ???? len->  c    ,    d    in </E>
   *     which stands for  b in ( c, d )
   *     we transform that into token list "Arglist b c d in"
   *     the correct syntaxe will be buid in BuidExpression
   *   
   if m.b = 0x07 then
      b = goStmt.NextByte()
   endif
   if m.b = T_SkipByte then && 0xFF
      * it begins to bore me ! I don't like at all, but that's life !
      * if it's 0xFF 0x00 then we are in the "SQL in ()" case
      * if it's 0xFF followed by something <> 0 It's used in ICase
      * function where the number of arguments is even. 
      lookAhead = goStmt.NextByte()
      if lookAhead = 0 then
         goStmt.Positionne( goStmt.Position() + 2 )
         b = goStmt.NextByte()
      else
         goStmt.Back(1)
      endif   
   endif
   * ---------------------------------------------------------------
   
   token = createobject( "CToken" )
   with m.token 
      do case
         case IsTagDistinct( m.b )
            .typ = P_CONST
            .deg = 1
            .txt = gaSymbol( TAG_DISTINCT + 0x100 )
         case IsOperator( m.b )
            .typ  = P_OPERATOR
            .deg  = 2
            .prio = 50
            if m.b = 0 then
               .typ = P_NULL
               .deg = 0
               .txt = 'Adr'
            else
               if m.b = OPER_PAR then
                  .typ = P_PARENTHESES
                  .deg = 1
                  .txt = 'Par'
               else
                  .txt = gaSymbol( m.b )
                  if InList( m.b, OPER_NOT, OPER_MINUS_U ) then
                     .deg = 1
                     .prio = 10
                  endif
                  .associatif = InList( m.b, OPER_MULT, OPER_PLUS, OPER_AND, OPER_OR )
                  do case
                     case m.b = OPER_POWER
                        .prio = 30
                     case InList( m.b, OPER_MULT, OPER_SLASH )
                        .prio = 25
                     case InList( m.b, OPER_PLUS, OPER_MINUS_B )
                        .prio = 20
                     case InList( m.b, OPER_EQ, OPER_EQEQ, OPER_LT, OPER_LE, OPER_GT, OPER_GE, OPER_NE, OPER_IN )
                        .prio = 15
                     case m.b = OPER_NOT
                        .prio = 13
                     case m.b = OPER_AND
                        .prio = 11
                     case m.b = OPER_OR      
                        .prio = 9
                     otherwise
                        .prio = 5
                  endcase
               endif
            endif
         case IsFunction( m.b )
            .typ = P_FONCTION
            .deg =  1
            .prio = 50
            do case
               case m.b = T_F_EXTEND
                  b = goStmt.NextByte() + 0x100
                  do case
                     case m.b = 0x119
                        .typ = P_NULL
                     case m.b = OPER_IN_SELECT + 0x100
                        .typ = P_OPERATOR
                        .deg = 2
                     case m.b = TAG_DISTINCT + 0x100
                        .typ = P_SQL_TAG
                        .txt = gaSymbol( m.b )
                        .deg = 1
                  endcase
               case m.b = T_EB
                  .typ = P_NULL
               case m.b = T_F_EXTEND2
                  b = goStmt.NextByte() + 0x200
               otherwise
            endcase
            if Between( m.b, 1, MAXSYMBOL ) then
               .txt = gaSymbol( m.b )
            else
               .txt = "0x" + cSmall( m.b )
            endif
            .fct = m.b 
         otherwise
            do case
               case m.b = ZERO
                  b = goStmt.NextByte()
                  if m.b = T_LETTER_DOT then
                     b = goStmt.NextByte()
                     .txt = Chr(Asc('a') + m.b - 1 ) + '.'
                     b = goStmt.NextByte()
                  endif
                  w = goStmt.NextWord()
                  .txt = .txt + gaVars( m.w + 1 )
                  .typ = P_TERME
               case m.b = T_CLASSREF
                  b = goStmt.NextByte()
                  w = goStmt.NextWord()
                  .txt = .txt + gaVars( m.w + 1 )
                  .typ = P_TERME
                  .dot = icase( InList( m.b, T_FOXVAR_DOT, T_VAR_DOT, T_FCT_ARR_DOT ), '.',;
                                m.b = T_VAR_COLON, '::',;
                                '' )
               case m.b = AROBAS
                  * Next var passée par adresse (Pb avec ObjNum())
                  .typ = P_REFERENCE 
                  .txt = gaSymbol( m.b )
                  b = goStmt.NextByte()
                  if m.b = T_LETTER_DOT then
                     b = goStmt.NextByte()
                    .txt = .txt + Chr(Asc('a')+m.b-1) + '.'
                     b = goStmt.NextByte()
                  endif
                  .dot = ICase( InList( m.b, T_FOXVAR_DOT, T_VAR_DOT, T_FCT_ARR_DOT ), '.',;
                                m.b = T_VAR_COLON, '::',;
                                '' )
                  w = goStmt.NextWord()
                  .txt = .txt + gaVars( m.w + 1 )
               case InList( m.b, C_FALSE, C_TRUE, C_NULL )
                  .typ = P_CONST
                  .txt = gaSymbol( m.b )
               case InList( m.b, C_STRING, P_STRING )
                  .typ = P_CONST
                  .txt = Quote( goStmt.NextPString() )
               case InList( m.b, T_DATE_ )
                  .typ = P_CONST
                  .txt = ConstDateToC( goStmt.NextDouble() )
               case InList( m.b, T_DATETIME_ )
                  .typ = P_CONST
                  .txt = ConstDatetimeToC( goStmt.NextDouble() )
		         case m.b = T_ARG_LIST
		            .typ = P_ARG_LIST
		         case m.b = T_NUMBER
                  * --- a strange way to store numbers
                  .typ = P_CONST
                  w = goStmt.NextWord()
                  i = Int( goStmt.NextWord() )
                  f = w / 65536
                  s = Str( m.f, 5, 3 )
                  .txt = Ltrim( Str( m.i ) )+ Substr( s, 2,4) 
               case m.b = T_FOXCST
                  .typ = P_CONST
                  b = goStmt.NextByte()
                  if b = M_Escape then
                     .txt = gaFoxCstExt( 1 + goStmt.NextByte() )
                  else
                     .txt = gaFoxCst( 1 + m.b )
                  endif
               case m.b = T_FOXVAR
                  .typ = P_TERME
                  b = goStmt.NextByte()
                  .txt = gaFoxVar( m.b + 1 )
               case m.b = T_FOXVAR_DOT
                  .dot = '.'
                  .typ = P_VAR
                  b = goStmt.NextByte()
                  .txt = gaFoxVar( m.b + 1 )
               case InList( m.b, T_SKIPB1, T_SKIPB2, T_SKIPI1, T_SKIPI2 )
                  * --- skip ptr in boolean expression or in if statement
                  goStmt.NextWord()
                  .typ = P_NULL
               case m.b = T_SkipByte
                  * --- skip ptr in boolean expression or in if statement
                  goStmt.NextByte()
                  .typ = P_NULL
               case InList( m.b, T_DOT )
                  .dot = '.'
                  .typ = P_VAR
                  .txt = ''
               case InList( m.b, T_DOT, T_VAR_DOT, T_LETTER_DOT, T_FCT_ARR, T_FCT_ARR_DOT, T_VAR,;
                                 T_VAR_COLON, T_PROP )
                  do case
                     case m.b = T_FCT_ARR
                        .typ = P_FONCTION
                     case m.b = T_FCT_ARR_DOT
                        .dot = '.'
                        .typ = P_MEMBER
                     case m.b = T_VAR_DOT
                        .dot = '.'
                        .typ = P_VAR
                     otherwise
                        .typ = P_TERME
                  endcase             
                  if m.b = T_LETTER_DOT then
                     b = goStmt.NextByte()
                     .txt = Chr(Asc('a')+m.b-1) + '.'
                     b = goStmt.NextByte()
                     if InList( m.b, T_FCT_ARR, T_FCT_ARR_DOT )
                        .typ = P_FONCTION
                     endif            
                  endif
                  .dot = ICase( InList( m.b, T_FOXVAR_DOT, T_VAR_DOT, T_FCT_ARR_DOT ), '.' ,;
                                m.b = T_VAR_COLON, '::',;
                                '' )
                  w = goStmt.NextWord()
                  .txt = .txt + gaVars( m.w + 1 )
               case InList( m.b, T_BYTE, T_INT2, T_INT4, T_REAL8, T_MONEY )
                  .typ = P_CONST
                  lnWidth = goStmt.NextByte()
                  do case
                     case m.b = T_Byte
                        b = goStmt.NextByte()
                        .txt = Ltrim( Str( m.b ) )
                     case m.b = T_INT2
                        w = goStmt.NextShort()
                        .txt = Ltrim( Str( m.w ) )
                     case m.b = T_INT4
                        i = goStmt.NextInt()
                        .txt = Ltrim( Str( m.i ) )
                     case InList( m.b , T_REAL8, T_MONEY )
                        dec = goStmt.NextByte()
                        dble = goStmt.NextDouble()
                        .txt = Iif( m.b = T_MONEY, '$', '' ) + Padl(Ltrim( Str( m.dble, m.lnWidth, m.dec )),m.lnWidth,'0')
                        b = goStmt.NextByte()
                        if b <> F_CC
                           goStmt.PushBack(Chr(m.b))
                        endif 
                  endcase
               case InList( m.b, T_TRIPLE )
                  local loStmt, lcMemo, lnLen
                  loStmt = CreateObject( "CMemory" )
                  .Typ = P_SELECT
                  lnLen = goStmt.NextTriple()
                  .txt = goStmt.Read( m.lnLen - 1 )
                  loStmt.Assign( goStmt ) && save current statement
                  lcMemo = goMemo.Harvest()
                  
                  goStmt.cMem = .txt + Chr( T_END_STMT )
                  goStmt.nPosition = 0
                  goStmt.NextByte()
                  SelectSQL_stmt()
                  if InList( m.gcCodeInst, S_UPDATE_SQL, S_SELECT_SQL ) then
                     .prio = 100
                     lcLPar = '('
                     lcRPar = ')'
                  else
                     store '' to lcLPar, lcRPar
                  endif
                  .txt = m.lcLPar + "select " + goMemo.Harvest() + m.lcRPar
                  
                  goMemo.cTxt = m.lcMemo 
                  goStmt.Assign( loStmt ) && restore current statement
		         otherwise
            endcase
      endcase
   endwith
   return m.token
endproc        
 
function IsOperator( b as Byte ) as boolean
   return (( m.b < AROBAS or m.b = OPER_MINUS_U ) and m.b <> 0)
endfunc


function IsFunction( b as Byte ) as Boolean
   return m.b > AROBAS and ;
          ( ( m.b <= T_FCT_ARR_DOT and ;
                not InList( m.b, C_FALSE, C_TRUE, C_NULL, T_FCT_ARR_DOT, OPER_MINUS_U, ;
                                 C_STRING, T_ARG_LIST, T_DOT, T_FOXVAR_DOT,;
                                 T_CLASSREF, T_PROP, T_MONEY ) ) or ;
              ( (m.b = T_F_EXTEND) and (m.b <> TAG_DISTINCT) ) ) 
endfunc


function IsTagDistinct( b as Byte ) as Boolean
   if m.b <> T_F_EXTEND then
      llRet = .F.
   else
      c = goStmt.NextByte()
      llRet = ( m.c = TAG_DISTINCT )
      if not m.llRet then
         goStmt.Back( 1 )
      endif
   endif
   return m.llRet      
end transaction
