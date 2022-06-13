*/* Expressions

#include dfox.h

external array gaVars

function LiteralOrExpression( b as byte ) as boolean
   do case
      case m.b = 0xFB
         goMemo.Write( ' ' + goStmt.NextPString() )
      case m.b = 0xFC
         Expression( m.b )
      case m.b = 0xE8
         SubSelect( m.b )
      otherwise
         return .F.
   endcase
   return .T.
endfunc


function NextVar( b as byte, llLeadingSpace as boolean) as boolean
   local w
   do case
      case m.b = T_DOT
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + '.' )
         NextVar( goStmt.NextByte() )
      case m.b = T_VAR_DOT
         w = goStmt.NextWord()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaVars(w+1) )
         b = goStmt.NextByte()
         if InList( m.b, T_VAR_DOT, T_FCT_ARR, T_VAR, T_FCT_ARR_DOT ) then
            goMemo.Write( '.' )
            NextVar( m.b )
         endif
      case m.b = T_VAR_COLON
         w = goStmt.NextWord()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaVars(w+1) )
         b = goStmt.NextByte()
         if InList( m.b, T_VAR_DOT, T_FCT_ARR, T_VAR ) then
            goMemo.Write( '::' )
            NextVar( m.b )
         endif
      case m.b = T_LETTER_DOT
         b = goStmt.NextByte()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + Chr(Asc('a')+ m.b-1 ) + '.' )
         b = goStmt.NextByte()
         NextVar( m.b )
      case InList( m.b, T_FCT_ARR, T_FCT_ARR_DOT )
         w = goStmt.NextWord()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaVars(w+1) )
         goMemo.Write( '(' )
         b = goStmt.NextByte()
         do while ( m.b <> OPER_PAR ) and ( b <> 0x16 ) 
            do Expression with b
            b = goStmt.NextByte()
            if m.b = T_VIRGULE then
               goMemo.Write( ',' )
               b = goStmt.NextByte()
            endif
         enddo
         goMemo.Write( ')' )
         b = goStmt.NextByte()
         if InList( m.b, T_VAR_DOT, T_FCT_ARR, T_VAR ) then
            goMemo.Write( '.' )
            NextVar( m.b )
         else
            goStmt.Back(1)
         endif
      case m.b = T_VAR
         w = goStmt.NextWord()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaVars(w+1) )
      case m.b = T_FOXVAR
         b = goStmt.NextByte()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaFoxVar( m.b + 1 ) )
      case m.b = T_FOXVAR_DOT
         b = goStmt.NextByte()
         goMemo.Write( Iif(m.llLeadingSpace, ' ', '' ) + gaFoxVar( m.b + 1 ) )
         b = goStmt.NextByte()
         if InList( m.b, T_VAR_DOT, T_FCT_ARR, T_VAR ) then
            goMemo.Write( '.' )
            NextVar( m.b )
         endif
      case m.b = T_STAR
         goMemo.Write( '*' )
         return .T.   
      otherwise
         return .F.
   endcase
endproc


procedure Expression( b as byte, llStick as boolean )
#define MAXTOKEN 4000

  local p as integer
  private aToken, pnToken
  dimension aToken( MAXTOKEN )   
  pnToken = 0
  if b <> 0xFC then
     return .F.
  endif
  b = goStmt.NextByte()
  do while b <> 0xFD
     pnToken = m.pnToken + 1 
     aToken( m.pnToken ) = NextToken( m.b ) 
     b = goStmt.Nextbyte()
  enddo

  WriteExpression( llStick )

endproc

procedure SubSelect( b as byte, llStick as boolean )
#define MAXTOKEN 4000

  local p as integer
  private aToken, pnToken
  dimension aToken( 1 )
  pnToken = 1   
  aToken( 1 ) = NextToken( m.b ) 

  WriteExpression( llStick )

endproc


function ExpressionGenerale( nByte as Byte, lStick as boolean ) as boolean

   local lnWord
   local lnInt
   local lnFrac
   local lnRet
   local lcConnector 
   local llFini 
   
   lnRet = .T.
   lcConnector = ''
   do case
      case m.nByte = T_NUMBER
         if !m.lStick
            goMemo.Write( ' ' )
         endif   
         * --- a strange way to store numbers !
         lnWord = goStmt.NextWord()
         lnInt  = Int( goStmt.NextWord() )
         lnFrac = lnWord / 65536
         goMemo.Write( Ltrim( Str( m.lnInt ) ) + Trim0( Substr( Str( m.lnFrac, 8, 6 ), 2 ) ) )
      case m.nByte = T_FOXCST
         if !m.lStick
            goMemo.Write( ' ' )
         endif
         nByte = goStmt.NextByte()
         if m.nByte = M_Escape then
            goMemo.write( gaFoxCstExt( 1 + goStmt.NextByte() ) )
         else
            goMemo.Write( gaFoxCst( 1 + m.nByte ) )
         endif   
      case InList( m.nByte, T_DOT, T_VAR_DOT, T_LETTER_DOT, T_FCT_ARR, T_FCT_ARR_DOT, T_VAR, T_STAR, T_FOXVAR_DOT, T_VAR_COLON )
         if !m.lStick
            goMemo.Write( ' ' )
         endif 
         llFini = .F.  
         do while not m.llFini and InList( m.nByte, T_DOT, T_VAR_DOT, T_LETTER_DOT, T_FCT_ARR, T_FCT_ARR_DOT, T_VAR, T_STAR,;
                                                    T_FOXVAR_DOT, T_VAR_COLON )
            do case
               case m.nByte = T_DOT
                  goMemo.Write( '.' )
               case m.nByte = T_VAR_DOT
                  if !Empty(m.lcConnector)
                     goMemo.Write( m.lcConnector )
                  endif
                  lnWord = goStmt.NextWord()
                  goMemo.Write( gaVars( m.lnWord + 1 ) )
               case m.nByte = T_VAR_COLON
                  if !Empty(m.lcConnector)
                     goMemo.Write( m.lcConnector )
                  endif
                  lnWord = goStmt.NextWord()
                  goMemo.Write( gaVars( m.lnWord + 1 ) )
               case m.nByte = T_LETTER_DOT
                  nByte = goStmt.NextByte()
                  goMemo.Write( Chr(Asc('a')+m.nByte-1) + '.' )
                  nByte = goStmt.NextByte()
                  lnWord = goStmt.NextWord()
                  goMemo.Write( gaVars( m.lnWord + 1 ) )
               case InList( m.nByte, T_FCT_ARR, T_FCT_ARR_DOT )
                  if !Empty(m.lcConnector)
                     goMemo.Write( m.lcConnector )
                  endif
                  lnWord = goStmt.NextWord()
                  goMemo.Write( gaVars( m.lnWord + 1 ) + '(' )
                  nByte = goStmt.NextByte()
                  do while ( m.nByte <> OPER_PAR ) and ( nByte <> 0x16 ) 
                     do Expression with nByte
                     nByte = goStmt.NextByte()
                     if m.nByte = T_VIRGULE then
                        goMemo.Write( ',' )
                        nByte = goStmt.NextByte()
                     endif
                  enddo
                  goMemo.Write( ')' )
               case m.nByte = T_STAR 
                  if !Empty(m.lcConnector)
                     goMemo.Write( m.lcConnector )
                  endif
                  goMemo.Write( '*' )
               case m.nByte = T_VAR 
                  if !Empty(m.lcConnector)
                     goMemo.Write( m.lcConnector )
                  endif
                  lnWord = goStmt.NextWord()
                  goMemo.Write( gaVars( m.lnWord + 1 ) )
                  llFini = .T.
               case m.nByte = T_FOXVAR_DOT
                  nByte = goStmt.NextByte()
                  goMemo.Write( ' ' + gaFoxVar( m.nByte + 1 ) )   
            endcase
            lcConnector = Iif( m.nByte = T_VAR_COLON, '::',;
                               Iif( InList( m.nByte, T_FCT_ARR, T_VAR, T_STAR, T_DOT ), '', '.' ) )
            nByte = goStmt.NextByte()            
         enddo
         goStmt.Back( 1 )
      case InList( m.nByte, T_BYTE, T_INT2, T_INT4, T_REAL8, T_MONEY )
         if !m.lStick
            goMemo.Write( ' ' )
         endif   
         width = goStmt.NextByte()
         do case
            case m.nByte = T_Byte
               nByte = goStmt.NextByte()
               goMemo.Write( Ltrim(Str( m.nByte )) )
            case m.nByte = T_INT2
               lnWord = goStmt.NextShort()
               goMemo.Write( Ltrim(Str( m.lnWord )) )
            case m.nByte = T_INT4
               lnInt = goStmt.NextInt()
               goMemo.Write( Ltrim(Str( m.lnInt )) )
            case InList( m.nByte, T_REAL8, T_MONEY ) 
               dec = goStmt.NextByte()
               dble = goStmt.NextDouble()
               goMemo.Write( Iif( m.nByte = T_MONEY, '$', '' ) + Ltrim(Str( m.dble, m.width, m.dec )) )
         endcase
      case InList( m.nByte, P_STRING, C_STRING )
         if !m.lStick
            goMemo.Write( ' ' )
         endif   
         goMemo.Write( Quote( goStmt.NextPString() ) )
      case m.nByte = T_DATE_
         if !m.lStick
            goMemo.Write( ' ' )
         endif
         goMemo.Write( ConstDateToC(goStmt.NextDouble()) )   
      case m.nByte = T_DATETIME_
         if !m.lStick
            goMemo.Write( ' ' )
         endif
         goMemo.Write( ConstDatetimeToC(goStmt.NextDouble()) )   
      case m.nByte = T_EXPRESSION
         Expression( m.nByte, m.lStick )
      case m.nByte = T_FOXVAR
         if !m.lStick
            goMemo.Write( ' ' )
         endif   
         nByte = goStmt.NextByte()
         goMemo.Write( gaFoxVar( m.nByte + 1 ) )
      case m.nByte = T_CLASSREF      
         nByte = goStmt.NextByte()
         return ExpressionGenerale( m.nByte, m.lStick )
      otherwise
         lnRet = .F.   
   endcase
   return m.lnRet
endproc     

function ConstDateToC( dble as Double )
   local lcRet
   if Empty( m.dble ) 
      lcRet = '{}'
   else
      lcRet = Dtos( {^1900-01-01} + ( m.dble - 2415021 ) )
      lcRet = Stuff( m.lcRet,7,0,'-' )
      lcRet = Stuff( m.lcRet,5,0,'-' )
      lcRet = '{^' + m.lcRet + '}'
   endif 
   return m.lcRet  
endfunc    

function ConstDatetimeToC( dble as Double )
   local lcRet, lc1, lc2, ld
   if Empty( m.dble ) 
      lcRet = '{}'
   else
      ld = {^1900-01-01} + ( Floor(m.dble) - 2415021 )
      lc1 = Dtos( m.ld )
      lc2 = Ttoc( Dtot( m.ld ) + ( m.dble - Floor(m.dble) )*86400 )
      lc1 = Stuff( m.lc1,7,0,'-' )
      lc1 = Stuff( m.lc1,5,0,'-' )
      lcRet = m.lc1 + Right( m.lc2, 9 ) 
      lcRet = '{^' + m.lcRet + '}'
   endif 
   return m.lcRet  
endfunc    

procedure WriteExpression( llStick as Boolean )

   local cExp as string
   local PeutSupprPar as boolean
   local prio as integer
   local ret as integer
   local i   as integer

   if m.pnToken = 0 then
      return
   endif   
   for i = 1 to m.pnToken
      if ( aToken( m.i ).typ = P_ARG_LIST ) and ( aToken( m.i ).deg = 0 ) then
         if not CalculDegre( m.i+1, @ret ) then
            goMemo.Write( '<Expression incomprise>' )
            return
         endif   
      endif
   endfor
   if m.glDebugExpression
      * --- only for debugging purpose and very short programs
      for i = 1 to m.pnToken
         do writepol with m.i, aToken(m.i)
      endfor
      goMemo.Ln()    
   endif
   PeutSupprPar = .T.
   cExp = BuildExpression( pnToken, @ret, @PeutSupprPar, @prio )
   if PeutSupprPar and ( Len( m.cExp ) >= 2 ) then
      if Left( m.cExp, 1 ) = '(' and Right( m.cExp, 1 ) = ')' then
         cExp = Substr( m.cExp, 2, Len( m.cExp ) - 2 )
      endif
   endif
   goMemo.Write( Iif( m.llstick, '', ' ' ) + m.cExp )
  
endproc

function CalculDegre( n as integer, ret as integer, dec as integer ) as boolean
*
*  -> -> X X X F -> X F X F -> X X F
*  Quand on rencontre un -> on appelle CalCulDegree
*  Quand on rencontre un F on lui met le degré correspondant
*
   local degree as integer
   local r      as integer
   local typ    as integer
   local d      as integer
   degree = 0
   d = 1
   do while ( m.n <= m.pnToken ) and ( !InList( aToken( m.n  ).typ, P_FONCTION, P_MEMBER) )
      typ = aToken( m.n ).typ
      if Empty( aToken( m.n ).dot )
         do case
            case InList( m.typ, P_TERME, P_SELECT, P_CONST, P_REFERENCE )
               degree = m.degree - 1 
            case InList( m.typ, P_VAR )
            case m.Typ = P_OPERATOR and aToken(m.n).txt = '*' and aToken(m.n+1).Typ = P_FONCTION and aToken(m.n+1).fct = 0x100 + F__Count
               * Very special case of count(*) in a select, we turn the * operator to constant 
               with aToken(m.n)
                  .typ = P_CONST
                  .deg = 0
                  .prio = 100
               endwith   
               degree = m.degree - 1
            case InList( m.typ, P_OPERATOR, P_PARENTHESES )
               degree = m.degree + aToken( m.n ).deg - 1
            case m.typ = P_ARG_LIST
               if not CalculDegre( m.n + 1, @m.r, @m.d ) then
                  return .F.
               endif
               n = m.r
               degree = m.degree - d 
            case m.typ = P_NULL
            otherwise 
               return .F.
         endcase
      endif   
      n = m.n + 1
   enddo
   if m.n <= m.pnToken
      if aToken( m.n ).Typ = P_FONCTION then
         dec = 1
      else
         dec = 0
      endif
      ret = m.n
      if m.n <= pnToken then
         aToken( n ).deg = -m.degree
      endif  
   endif 
   return .T.
endproc

function BuildExpression( n         as integer, ;
                          arr       as integer, ;
                          mayStrip  as boolean, ;
                          priorite  as byte,;
                          lArgument  as boolean ) as string
*
*   L'optimisation du parenthèsage est gérée de la façon suivante:
*   On affecte une priorité aux expressions. Si elles sont entre
*   parenthèse, leur prio est infinie (100). Si elles ne sont pas
*   entre parenthèse, on leur affecte le min des priorités des
*   opérateurs qui lient leurs termes.
*   Quand on construit une expression elle n'est à priori pas mise
*   entre parenthèse (sauf dans le cas de l'opérateur () )
*   3 cas sont possibles :
*   1) Cas d'un Op unaire : [ EXPR, £ ]
*      On met EXPR entre () ssi Prio(EXPR) < Prio(£)
*   2) Cas d'un Op binaire : [ EXPR1, EXPR2, £ ]
*      On met EXPR1 entre () ssi Prio(EXPR1) < Prio(£)
*      On met EXPR2 entre () ssi ( Prio(EXPR2) < Prio(£) ) ou
*                              ( ( Prio(EXPR2) = Prio(£) ) et
*                                  £ non associatif  )
*   3) Cas des termes et fonctions : On ne met pas de parenthèse
*

#define MxArgFct 32  && Normally 26
#define ParG  '('
#define ParD  ')'
#define Virg  ','
#define ESPACE ''
 
   local array args( MxArgFct )
   local res  as string
   local arg1 as string
   local arg2 as string
   local oper as string
   local i    as integer
   local k    as integer
   local d    as integer
   local a    as integer
   local rien as boolean
   local pE1 as byte, pE2 as byte, pOp as byte
   local par1 as boolean, par2 as boolean
   local inw  as boolean
   local idxFn as integer
   local llTrimArobas as boolean
   local lcSep
   local lcParG
   local lcParD
   local llNoPar
 
   lcParG = ParG
   lcParD = ParD
   
   pE1 = 0
   pE2 = 0
   rien = .F.
   arr = m.n
   mayStrip = .F.
   do while ( m.n > 0 ) and InList( aToken( m.n ).typ, P_NULL, P_ARG_LIST ) 
      n = m.n - 1       
   enddo
   if m.n <= 0 then
      lcExpression = '<build error 1>'
      return lcExpression
   endif 
   if InList( aToken( m.n ).typ, P_VAR, P_TERME, P_CONST, P_REFERENCE, P_SQL_TAG ) then
      if !InList(aToken( m.n ).typ, P_CONST, P_REFERENCE) and !m.lArgument and m.n > 1 and !Empty( aToken( m.n - 1 ).dot ) then
         res = BuildExpression( m.n - 1, @arr, @rien, @pE1 ) + aToken( m.n - 1 ).dot + aToken(m.n).txt
      else
         res = aToken(m.n).txt
         arr = m.n
      endif 
      priorite = 100
   else
      if aToken( m.n ).typ = P_SELECT then
         priorite = aToken( m.n ).prio
         res = aToken(m.n).txt
         arr = m.n
      else
         if aToken( m.n ).typ = P_PARENTHESES then
            arg1 = BuildExpression( m.n - 1, @arr, @rien, @pE1 )
            res  = m.lcParG + m.arg1 + m.lcParD
            mayStrip = .F.
            priorite = 100
         else
            if aToken( m.n ).typ = P_OPERATOR then
               if aToken( m.n ).deg = 1 then
                  arg1 = BuildExpression( n - 1, @arr, @rien, @pE1 )
                  res = aToken( m.n ).txt
                  if pE1 <= aToken( m.n ).prio then
                     res = m.lcParG
                  endif
                  res = m.res + m.arg1
                  if pE1 <= aToken( m.n ).prio then
                     res = m.lcParD
                     priorite = 100
                  else
                     priorite = aToken( m.n ).prio
                  endif   
               else
                  if aToken( m.n ).deg = 2 then
                     *try
                        arg2 = BuildExpression( n - 1, @k, @rien, @pE2 )
                        arg1 = BuildExpression( k - 1, @arr, @rien, @pE1 )
                        oper = aToken( m.n ).txt
                        oper = Iif( IsAlpha(m.oper), ' ' + m.oper + ' ', m.oper )
                        res = ''
                        *\prio=<<aToken(m.n).prio>>  pE1=<<pE1>>
                        Par1 = aToken(m.n).prio > pE1
                        Par2 = (aToken(m.n).prio > pE2) and ( not aToken(m.n).associatif )
                        if Par1 then
                           res = m.res + m.lcParG
                        endif   
                        res = res + m.arg1
                        if Par1 then
                           res = m.res + m.lcParD
                           pE1 = 100
                        endif   
                        res = res + m.oper
                        if Par2 then
                           res = m.res + m.lcParG
                        endif   
                        res = m.res + arg2
                        if Par2 then
                           res = m.res + m.lcParD
                           pE2 = 100
                        endif   
                        priorite = min( pE1, pE2, aToken(m.n).prio )
                     *catch
                     *   set step on
                     *endtry
                  else
                     return = '<Build error 2>'
                  endif
               endif   
            else
               if InList( aToken( m.n ).typ, P_FONCTION, P_MEMBER ) then
                  idxFn = m.n
                  d = aToken( m.n ).deg

                  if !m.lArgument and m.n > 1 and !Empty( aToken( m.n - 1 ).dot) then
                     oper = BuildExpression( m.n - 1, @arr, @rien, @pE1 ) + aToken( m.n - 1 ).dot + aToken(m.n).txt
                     inw = .F.
                     llNoPar = .F.
                  else
                     oper = aToken(m.n).txt
                     inw = aToken(m.n).fct = F_SQL_IN
                     llNoPar = InList( aToken(m.n).fct, F_SQL_IN, 0x100 + F_EXISTS_SELECT )
                     arr = m.n
                  endif 

                  n = m.arr
                  llTrimArobas = Upper(m.oper)=="ISBLANK" or Upper(m.Oper)=="OBJNUM" or Upper(m.Oper) == "LOOKUP" 
                  do while m.n > 1 and !Empty( aToken( m.n - 1 ).dot )
                     oper = aToken( m.n - 1 ).txt + aToken( m.n - 1 ).dot + m.Oper
                     n = m.n - 1
                  enddo
                  k = n
                  for a = 1 to d
                     args[ d - a + 1 ] = BuildExpression( n - 1, @k, @rien, @pE1, .F. )
                     n = k
                  endfor
                  arr = k
                  if m.inw then && special case of arg1 in ( arg2, arg3, ... ) of where clause (VFP9)
                     res = Iif( llTrimArobas and args(1) = '@', Substr( args( 1 ),2), args(1) ) + ' ' + m.oper + ' ' + m.lcParG
                     res = m.res + ESPACE + Iif( llTrimArobas and args(2) = '@', Substr( args( 2 ),2), args(2) )
                     for a = 3 to d
                        res = m.res + Virg + ESPACE + Iif( llTrimArobas and args(a) = '@', Substr( args( a ),2), args(a) )
                     endfor
                  else
                     if aToken( m.idxfn ).fct = 0x100 + F_EXISTS_SELECT then
                        res = m.oper
                     else   
                        res = m.oper + m.lcParG
                     endif   
                     if aToken( m.idxFn ).fct = 0x200 + F_Cast && very special case of the Cast function
                        res = m.res + ESPACE
                        res = m.res + Iif( llTrimArobas and args(1) = '@', Substr( args( 1 ),2), args(1) )
                        res = m.res + ' as ' + UnQuote(args(2))
                        if m.d > 3 then
                           res = m.res + m.lcParG + Iif( llTrimArobas and args(1) = '@', Substr( args( 1 ),3), args(3) )
                           if m.d > 4 then
                              res = m.res + Virg + ESPACE + Iif( llTrimArobas and args(1) = '@', Substr( args( 1 ),4), args(4) )
                           endif
                           res = m.res + m.lcParD
                        endif
                        do case
                           case args(m.d) = ".T."
                              res = m.res + " Null" 
                           case args(m.d) = ".F."
                              res = m.res + " not Null"
                           otherwise
                        endcase
                     else && general case
                        if d > 0 then
                           res = m.res + ESPACE
                           res = m.res + Iif( llTrimArobas and args(1) = '@', Substr( args( 1 ),2), args(1) )
                        endif
                        if InList( aToken( m.idxFn ).fct - 0x100, F__Count, F__Sum, F__Avg, F__Max, F__Min ) then
                           lcSep = " "
                        else   
                           lcSep = Virg + ESPACE
                        endif 
                        * goMemo.Write( '['+m.res+']' )
                        *if Lower(m.res) = "count(" + ESPACE + "distinct" then
                        *   lcSep = " "
                        *endif 
                        for a = 2 to d
                           res = m.res + m.lcSep + Iif( llTrimArobas and args(a) = '@', Substr( args( a ),2), args(a) )
                        endfor
                     endif
                  endif
                  if aToken( m.idxfn ).fct = 0x100 + F_EXISTS_SELECT then
                     res = m.res + ESPACE
                  else
                     res = m.res + ESPACE + m.lcParD
                  endif   
                  priorite = 100
               endif
            endif
         endif   
      endif
   endif         
   return m.res
 endproc


 procedure writePol( i as integer, pol as C_Polish )
    with pol
       goMemo.LnWrite( Ltrim(Str(i)) + ' typ=' )
       do case
          case .typ = P_NULL
             goMemo.Write( 'Nul' )
          case .typ = P_OPERATOR
             goMemo.Write( 'Ope' )
          case .typ = P_VAR
             goMemo.Write( 'Var' )
          case .typ = P_TERME
             goMemo.Write( 'Trm' )
          case .typ = P_REFERENCE
             goMemo.Write( 'Ref' )
          case .typ = P_CONST
             goMemo.Write( 'Cst' )
          case .typ = P_FONCTION
             goMemo.Write( 'Fct' )
          case .typ = P_MEMBER
             goMemo.Write( 'Mbr' )
          case .typ = P_ARG_LIST
             goMemo.Write( 'Arg' )
          case .typ = P_PARENTHESES
             goMemo.Write( '( )' )
          case .typ = P_SELECT
             goMemo.Write( 'Sub' )   && Sub Querry
          otherwise
             goMemo.Write( '$' + cByte(.typ) )
       endcase
       goMemo.Write  ( ' deg= ' + Ltrim(Str(.deg)) )
       goMemo.Write  ( ' dot= ' + Padr( .dot, 3 ) )
       goMemo.Write  ( ' txt= ' + .txt )
       goMemo.Write  ( ' prio=' + Ltrim(Str(.prio)) )
    endwith
 endproc

 function Trim0( cNum as String ) as String
    if At('.',m.cNum) > 0 then
       i = Len( m.cNum )
       do while Right( m.cNum, 1 ) = '0'
          cNum = Left( m.cNum, Len( m.cNum ) - 1 )
       enddo
       if Right( m.cNum, 1 ) = '.' then
          cNum = Left( m.cNum, Len( m.cNum ) - 1 )
       endif
    endif
    return m.cNum
 endfunc
 

  