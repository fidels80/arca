*/* DFox.prg
*/  For good looking, edit my files with tab size = 3 and indent size = 3 
*/------------------------------------------------------------------------
*/  This application decompiles a non crypted .app build with VFP 8 or 9.
*/  This project needs VFP 9 environment to compile and execute properly.
*/  It can be adapted for earlier VFP versions.
*/  We have other applications for FoxPro 2.x versions.  
*/------------------------------------------------------------------------
*/  License for DvFp
*/ 
*/  Copyright 2004-2006 by Robert Plagnard <robert.plagnard@ingelog.fr>
*/ 
*/  All Rights Reserved 
*/ 
*/  Permission to use, copy, modify, and distribute this software and its 
*/  documentation for any purpose and without fee is hereby granted, 
*/  provided that the above copyright notice appear in all copies and that 
*/  both that copyright notice and this permission notice appear in 
*/  supporting documentation. 
*/ 
*/  Robert Plagnard disclaims all warranties with regard to this 
*/  software, including all implied warranties of merchantability 
*/  and fitness, in no event shall Robert Plagnard be liable for any 
*/  special, indirect or consequential damages or any damages 
*/  whatsoever resulting from loss of use, data or profits, 
*/  whether in an action of contract, negligence or other 
*/  tortious action, arising out of or in connection with the use 
*/  or performance of this software.
*/
*/------------------------------------------------------------------------
lparameters cName   && optional filename to decompile
*/------------------------------------------------------------------------
*/  I usually use hungarian naming convention for variables. A prefix made of 
*/  one or two lowercase letters tells us about the scope and the type. 
*/  The prefix is followed by an uppercase letter which start the true name
*/  of the variable. But sometimes I also use simple names like i.
*/  Prefix   Stands for :
*/  go       global object
*/  gl       global logical
*/  ga       global array
*/  gn       global number
*/------------------------------------------------------------------------
#include FoxPro.h
#include dfox.h
#include dfoxLoc.h

   private gcVersion
   private goInput                && Input binary stream.            
   private goText                 && Output text stream.
   private goMemo                 && Internal memory stream.
   private goStmt                 && Current statement
   private gnNextInst             && Next statement offset
   private glDump                 && Do Hexadecimal dump 
   private glDebugExpression      && Expression debugging
   private glDecomp               && Do Decompile (can be done together with Dump)
   private glAllInOne             && All prg will go to one file
   private gaVars                 && array of object variables
   private glEcho                 && if true echoes some dots to screen
   private gnDotCount             && count the # of decompiled statements
   private gcProjPath             && New project's directory
   private gcFileName             && File Name to decompile
   private gcCodeInst
   private glSingleton
   private gcOutFile
   private Cosmetic

   dimension gaVars(1)
   
   local lnMemoWidth
   local lcSafety
   local lcAsserts
   local lcProcedure
   local loErr

   store .F. to ;
      gcVersion, goInput, goText, goMemo, goStmt, gnNextInst, glDump, glDebugExpression,;
      glDecomp, glAllInOne, gaVars, glEcho, gnDotCount, gcProjPath, gcFileName, glSingleton,;
      gcOutFile, Cosmetic, gcCodeInst
   
   try
      gcVersion = "3.141"   && more acurately build is 3.14159
      lnMemoWidth = Set( "Memowidth" )
      lcSafety    = Set( "safety" )
      lcAsserts   = Set( "Asserts" )
      lcProcedure = Set( "procedure" )
      
      set procedure to ;
         Tools, ;
         Streams, ;
         Statements, ;
         IsProcs, ;
         Expressions, ;
         Tokens, ;
         TextOut, ;
         AppFromExe additive
         
      set safety off
      set asserts on
      set memowidth to 8192
      _screen.Caption = "DVFP - " + m.gcVersion 
   
      Main( m.cName )
   
   catch to loErr
      ShowError( m.loErr, "DVFP Error" )
      close all            
   finally
      set memowidth to (m.lnMemoWidth )
      set asserts &lcAsserts
      set safety &lcSafety
      set procedure to &lcProcedure
      modify window screen
   endtry
   
endproc   

*/------------------------------------------------------------------------
procedure Main( cName as String )
*/------------------------------------------------------------------------
   local lnWord
   local lnByte
   local loApp
   local llDebugExp  
   local lcIni 
   local lcExeName
   
   private pcAllInOne   && set by ReadIniFile 
   pcAllInOne = ''      && allocate variable
   
   clear
   
   lcIni = sys(5) + curdir() + ExtractFilename(Sys(16)) + ".ini"
   ReadIniFile( m.lcIni )
   Cosmetic = CreateObject( "CCosmetic", m.lcIni )

   gnDotCount = 0
   do Inits

   if Empty( m.cName ) then
      cName = GetFile( "VFP compilation :exe,dll,app,fxp;All files:*.*","Select", "Decompile")
      if Empty( m.cName ) then
         return
      endif
   endif
   if not File( m.cName ) then
      error "File " + m.cName + " not found"
   endif
    
   gcFileName = ExtractFileName( m.cName )
   gcProjPath = ExtractFilePath( m.cName )
   glSingleton = .F.
   if not m.glAllInOne then
      glSingleton = not InList( Lower( ExtractFileExt( m.cName ) ), '.exe', '.dll', '.app' )
   endif
   
   goInput = CreateObject( "CBinaryFile", m.cName )
   
   if m.glAllInOne then
      gcOutFile = m.gcProjPath + m.pcAllInOne
      goText  = CreateObject( "CTextOut", m.gcOutFile )
   endif   
   
   * --- if we got an Exe or DLL file we need to extract the app file
   lnWord = m.goInput.NextWord()
   if m.lnWord = IMAGE_DOS_SIGNATURE then
      goInput = .F.   && release the object
      lcExeName = m.cName
      cName = AppExtract( m.cName )
      if Empty( m.cName ) then
         error m.lcExeName + LOC_APPNOTFOUNDINEXE
      endif
      goInput = CreateObject( "CBinaryFile", m.cName )
      lnWord = m.goInput.NextWord()
   endif
         
   if m.lnWord <> FOXPROAPP then
      error m.cName + LOC_NOTPROPERAPP 
   endif

   lnByte = m.goInput.NextByte()
   if not Visual()
      error m.cName + LOC_NOTVISUALFOXPRO
   endif
   do case
      case m.lnByte = NOCRYPTED
         loApp = CreateObject( "CAppFile" )
         * -------------
         loApp.Analyse()
         * -------------
      case m.lnByte = ENCRYPTED
         error m.cName + LOC_ISCRYPTED
      otherwise
         error m.cName + LOC_NOTSTANDARDAPP
   endcase

   release goInput, goText
   set procedure to 
   
   if m.glAllInOne or m.glSingleton then
      if Version(2) = 0 then && RunTime
         modify command (m.gcOutFile)
      else
         modify command (m.gcOutFile) nowait
      endif    
   endif   
   
endproc

*/------------------------------------------------------------------------
function Visual()
*/------------------------------------------------------------------------
   local array bytes(2)
   local lnPos
   lnPos = goInput.Position()
   bytes(1) = goInput.NextByte()
   bytes(2) = goInput.NextByte()
   goInPut.Positionne( m.lnPos )
   return bytes(2) = 2
endfunc

*/------------------------------------------------------------------------
procedure ReadIniFile( cIni as String )
*/------------------------------------------------------------------------
   local llDebugExp
   glDump     = Evaluate( GetPPS( m.cIni, [Prefs], [Dump]            , '.F.' ) )
   llDebugExp = Evaluate( GetPPS( m.cIni, [Prefs], [DebugExpressions], '.F.' ) )
   glDecomp   = Evaluate( GetPPS( m.cIni, [Prefs], [Decompile]       , '.T.' ) )
   glEcho     = Evaluate( GetPPS( m.cIni, [Prefs], [Echo]            , '.F.' ) )
   pcAllInOne =           GetPPS( m.cIni, [Prefs], [AllInOneFile]    , '' )
   glAllInOne = not Empty( m.pcAllInOne )
   glDebugExpression = m.llDebugExp
endproc


*/=============================================================================
define class CObject as Relation
*/=============================================================================
*  Ancestor of all our objects. We inherit from Relation because Relation is a
*  very small object. If we need properties like 'Class' we will shift to
*  Custom, but it's not the case. 
enddefine


*/=============================================================================
define class CCosmetic as CObject
*/=============================================================================
* Cosmetic options allows to show or not some informations (in comments).
* ProcBetween      : must be a char or empty, if not empty the procedure & function
*                    statements are written in between two lines of comment filled
*                    with that char.
* ClassBetween     : same as for proc but for "define class .." statements 
* All the cosmetic options are implicitly set to .T. when Dump is activated.
   
   AppHeader = .T.
   PartTable = .T.
   Partheader = .T.
   PartTitle = .T.
   ProcBetween = '-'
   ClassBetween = '='
   
   procedure Init( cIni as String )
      with this
         .AppHeader    = Evaluate( GetPPS( m.cIni, [Cosmetic], [AppHeader]   , '.T.' ) ) or m.glDump
         .PartTable    = Evaluate( GetPPS( m.cIni, [Cosmetic], [PartTable]   , '.T.' ) ) or m.glDump
         .PartTitle    = Evaluate( GetPPS( m.cIni, [Cosmetic], [PartTitle]   , '.T.' ) ) or m.glDump
         .Partheader   = Evaluate( GetPPS( m.cIni, [Cosmetic], [PartTable]   , '.T.' ) ) or m.glDump
         .ProcBetween  =           GetPPS( m.cIni, [Cosmetic], [ProcBetween] , '-'   )
         .ClassBetween =           GetPPS( m.cIni, [Cosmetic], [ClassBetween], '='   )
         if m.glDump then
            if Empty(.ProcBetween) then
               .ProcBetween = '-'
            endif
            if Empty(.ProcBetween) then
               .ClassBetween = '='
            endif
         endif
      endwith
   endproc
   
enddefine


*/=============================================================================
define class CPart as CObject
*/=============================================================================
*  An .APP file is a collection of parts which can stand for CODE, TABLE, etc.
*  A .FXP file is an .APP file with only one 'codefile' part.
*  This class models a Part
   nGenre      = 0   && Type of Part in ( gpCODEFILE, gpTABLE, gpMEMOFILE, gpDCX
                     && gpFILE, gpCLASSLIB, gpFORM, gpREPORT, gpLABEL )
   nStart      = 0   && Start offset of part in file
   nNextPart   = 0   && offset+1 of last byte of file (often next part offset but
                     && not always) 
   IDK1        = 0   && I dont know 
   nNameOffset = 0   && Offset name in Name table
   IDK2        = 0   && I dont know
   IDK3        = 0   && I dont know
   cName       = ""  && Part name
   lSnipet     = .F. && Compiled snipet (cName='')
   oApp        = .F.

   procedure Init( g, owner )
      with this
         .oApp        = m.owner
         .nGenre      = m.g
         .nStart      = goInput.NextUInt()
         .nNextPart   = goInput.NextUInt()
         .IDK1        = goInput.NextUInt()
         .nNameOffset = goInput.NextUInt()
         .IDK2        = goInput.NextUInt()
         .IDK3        = goInput.NextUInt()
         goInput.Positionne( m.owner.nEntryNameTableOffset + .nNameOffset )
         .cName       = goInput.NextCString()
         if Empty( .cName ) then
            .cName = "_snipet.fxp"
         endif 
      endwith
   endproc

   procedure Analyse()
      local lcDir
      local ldata
      local lh
      if not glAllInOne then
         do case
            case this.nGenre = gpTABLE
               this.oApp.cLastDir = "data"
            case this.nGenre = gpCLASSLIB
               this.oApp.cLastDir = "vcl"
            case this.nGenre = gpFORM
               this.oApp.cLastDir = "scr"
            case this.nGenre = gpREPORT
               this.oApp.cLastDir = "rpt"
            case this.nGenre = gpLABEL
               this.oApp.cLastDir = "lbl"
            case this.nGenre = gpFILE
               this.oApp.cLastDir = "oth"
            otherwise
         endcase
         lcDir = NeedPath( m.gcProjPath, this.oApp.cLastDir )
         goInput.Positionne( this.nStart )
         ldata = GoInput.Read( this.nNextPart-this.nStart )
         lh = Fcreate( m.lcDir + this.cName )
         Fwrite( m.lh, m.ldata )
         Fclose( m.lh )
      endif
   endproc
   
   procedure StartOut   
   endproc
   
   procedure EndOut
   endproc
      
enddefine


*/=============================================================================
define class CCodePart as CPart
*/=============================================================================
*  This class encapsulates a gpCODEFILE Part (.fxp, .qpx, .mpx)

   nbProc        = 0     && Number of proc/func in the part
   nbClass       = 0     && Number of classes in the part
   debMain       = 0     && Main procedure offset
   debProcTable  = 0     && Procedure table offset
   debClassTable = 0     && Class table offset
   IDK1          = 0     && I dont know
   IDK2          = 0     && idem
   dimension Procs(1)    && array of procedure entry
   dimension Classes(1)  && array of class entry
   
   procedure Analyse()
      this.StartOut()
      if Cosmetic.PartTitle then
         goText.Write( '*/* ' + this.cName )
      endif   
      goInput.Positionne( this.nStart )
      with this  
         .nbProc        = goInput.NextWord() + 1 && + 1 for Main
         .nbClass       = goInput.NextWord()
         .debMain       = goInput.NextUInt()
         .debProcTable  = goInput.NextUInt()
         .debClassTable = goInput.NextUInt()
         .IDK1          = goInput.NextUInt()         
         .IDK2          = goInput.NextUInt()
         if Cosmetic.PartHeader then
            goText.LnWrite( '*   debMain at offset ' + Transform(.debMain,'@0') ) 
            goText.LnWrite( '*   ' + Ltrim( Str( .nbProc ) ) + ' procs in ProcTable at offset ' + Transform(.debProcTable,'@0') )
            goText.LnWrite( '*   IDK1=' + cHexa(.IDK1)  + ' IDK2=' + cHexa(.IDK2) + ' IDK3=' + cHexa(.IDK3) )
         endif
         if .nbProc > 0 then
            dimension .procs( .nbProc )
            .procs(1) = CreateObject( "CProc", this ) 
            with .Procs( 1 )
               .cName   = ''
               .nPtr    = this.debMain
               .lMember = 0
               .nClass  = -1
            endwith
            goInput.Positionne( .nStart + .debProcTable )
            for p = 2 to .nbProc
               .Procs( m.p ) = CreateObject( "CProc", this )
               with .Procs( m.p )
                  .cName   = goInput.NextPString()
                  .nPtr    = goInput.NextUint()
                  .lMember = goInput.NextWord()
                  .nClass  = goInput.NextShort()
               endwith
            endfor
            for p = 1 to .nbProc
               with .Procs( m.p )
                  if .nClass = -1 then
                     if m.glDump
                        goText.LnWrite  ( '*       ' + Padl(.cName, 32 ) + Transform(.nPtr,'@0') +;
                                          ' ' + Ltrim(Str(.lMember)) + ' ' + Ltrim(Str(.nClass)) )
                     endif                    
                     try
                        .Decompile(0)
                     catch to Ex
                        ShowError( m.Ex, "DVFP Error" )
                     finally
                     endtry
                  endif
               endwith
            endfor   
         endif
         goText.Ln()
         if m.glDump then
            goText.LnWrite( '*   ' + Ltrim(Str(.nbClass)) + ' classes in ClassTable at offset ' + Transform(.debClassTable,'@0') )
         endif   
         if .nbClass > 0 then
            dimension .Classes( .nbClass ) 
            goInput.Positionne( .nStart + .debClassTable )
            for c = 1 to .nbClass
               .Classes( m.c ) = CreateObject( "CClass", this )
               with .Classes( m.c )
                  .cName = goInput.NextPString()
                  .cPere = Strtran(goInput.NextPString(),':', ' of ')
                  .nPtr  = goInput.NextUint()
                  .nOle  = goInput.NextWord()
               endwith
            endfor
            for c = 1 to .nbClass
               with .Classes( m.c )
                  if m.glDump then
                     goText.LnWrite( '*       ' + Padr(.cName, 32) + ' as ' + Padr(.cPere, 32) + Transform(.nPtr,'@0') ) 
                  endif   
                  if not empty(Cosmetic.ClassBetween)
                     goText.LnWrite( Padr( '*/', 80, Cosmetic.ClassBetween ) )
                  endif   
                  goText.LnWrite( 'define class ' + .cName + ' as ' + .cPere )
                  if .nOle = 1 then
                     goText.Write( " olepublic" )
                  endif
                  if m.glDump then
                     goText.Write( '   ' + Replicate('&',2) + ' at ' + Transform(.nPtr,'@0') ) 
                  endif   
                  if not empty(Cosmetic.ClassBetween)
                     goText.LnWrite( Padr( '*/', 80, Cosmetic.ClassBetween ) )
                  endif   
                  this.Classes( m.c ).Decompile(0)
                  goText.Indent(-1)
                  goText.LnWrite( 'enddefine' )
                  goText.Ln()
                  *goText.Ln()
               endwith
            endfor
         endif
      endwith
      this.EndOut()
   endproc
   
   procedure StartOut   
      local lcN, lcE
      if not glAllInOne then
         lcN = ExtractFileName( this.cName )
         lcE = ExtractFileExt( this.cName )
         if m.glSingleton then
            do case
               case m.lcE = '.fxp'
                  gcOutFile = m.gcProjPath + m.lcN + ".prg" 
               case m.lcE = '.qpx'
                  gcOutFile = m.gcProjPath + m.lcN + ".qpr" 
               case m.lcE = '.mpx'
                  gcOutFile = m.gcProjPath + m.lcN + ".mpr" 
            endcase
         else
            do case
               case m.lcE = '.fxp'
                  gcOutFile = NeedPath( m.gcProjPath, "prg" ) + m.lcN + ".prg" 
               case m.lcE = '.qpx'
                  gcOutFile = NeedPath( m.gcProjPath, "qpr" ) + m.lcN + ".qpr" 
               case m.lcE = '.mpx'
                  gcOutFile = NeedPath( m.gcProjPath, "mpr" ) + m.lcN + ".mpr" 
            endcase
         endif
         goText = CreateObject( "CTextOut", m.gcOutFile )
      endif
   endproc
   
   procedure EndOut
      if not m.glAllInOne then
         goText = .F.   && destroy the object without releasing the variable
      endif
   endproc

enddefine


*/=============================================================================
define class CCode as CObject
*/=============================================================================
*  Abstract class for a piece of code (procedure, function or classe)

   cName = ""   && Name of code proc/func/class
   oPart = .F.  && owner part
   nPtr  = 0    && piece of code start within owner part
   nbVar = 0    && Number of 'variables', in fact 'names' which contains variables
                && procedures called and other references (like 'this' for ex.)


   */------------------------------------------------
   procedure Init( aPart )
   */------------------------------------------------
      this.oPart = m.aPart
   endproc
   

   */------------------------------------------------
   procedure GetVars()
   */------------------------------------------------
      local nStart
      local j
      nStart = this.oPart.nStart + this.nPtr
      goInput.Positionne( m.nStart )
      L = goInput.NextWord()
      if m.glDump      
         goText.LnWrite( '*  L=' + Ltrim(Str(L)) )
      endif   
      goInput.Positionne( m.nStart + m.L + 2 )
      this.nbVar = goInput.NextWord()
      if m.glDump
         goText.Write( ', ' + Ltrim(Str(this.nbVar)) + ' variables :' )
      endif   
      if this.nbVar > 0 then
         * when we analyse a piece of code, we never need more than
         * one set of variables at the same time . So let it be a global array.
         * We could put this array local to the class but it would
         * be difficult to use it in further statement analysis.
         dimension gaVars(this.nbVar)
         for j = 1 to this.nbVar
            gaVars(m.j) = MyProper( goInput.NextPString() )
            if m.glDump
               goText.LnWrite( '*  ' + cSmall(m.j-1) + ' ' + gaVars(m.j) )
            endif   
         endfor
      endif   
   endproc

   
   */------------------------------------------------
   procedure Header
   */------------------------------------------------
   endproc

   
   */------------------------------------------------
   procedure Footer
   */------------------------------------------------
   endproc


   */------------------------------------------------
   procedure Decompile( lcIndent )
   */------------------------------------------------
      local nStart
      local lnSavePos
      local lnSaveNext
      local lnFrom

      goText.SetIndent( m.lcIndent )
      this.header() 
      this.GetVars()
      nStart = this.oPart.nStart + this.nPtr + 2
      goText.Indent(+1)

      goInput.Positionne( m.nStart )
      LongInst = goInput.NextWord()

      goStmt = CreateObject( "CMemory", goInput.Read( LongInst - 2 ) )
      goMemo = CreateObject( "CTextMem" )
      gcCodeInst = goStmt.NextByte()
      if m.glDump then
         goText.LnWrite( '* ' + goStmt.PlainDump( 0 , goStmt.Length - 1 ) )
      endif
      do while gcCodeInst <> S_ENDPROC
         if m.glDecomp then
            writeCode( gcCodeInst ) && it's a LnWrite
         endif
         if InList( gcCodeInst, S_METHOD, S_HIDDEN_PROC, S_PROTECTED_PR ) then
            b = goStmt.NextByte()
            assert m.b = T_INT4
            b = goStmt.NextByte()
            assert m.b = 0
            n = goStmt.NextInt()

            lnSavePos = goInput.Position()
            lnSaveNext = gnNextInst
            this.oPart.Procs( m.n + 1 ).Decompile(1)
            goInput.Positionne( m.lnSavePos )
            gnNextInst = lnSaveNext
            do Reste with .F.
         else
            if m.glDecomp and gcCodeInst <= MAXCOMMANDE and !Empty( gaParser( gcCodeInst )) then
               goStmt.NextByte()
               eval ( gaParser( gcCodeInst ) ) && Take it easy man
               if m.glEcho then
                  if m.gnDotCount > 0 and Mod( m.gnDotCount, 100 ) = 0 then
                     ? '.'
                  else
                     ?? '.'
                  endif
                  gnDotCount = m.gnDotCount + 1
               endif 
            endif
            do Fin with m.glDecomp && check end and if analysis is not complete dump extra bytes
         endif
         do Reste with m.glDecomp && if analysis is not complete dump extra bytes
         if m.glDecomp
            goText.Merge( goMemo )
         endif
         * --- Next statement
         LongInst = goInput.NextWord()
         * --- Old goStmt for garbage collector
         goStmt = CreateObject( "CMemory", goInput.Read( LongInst - 2 ) )
         goMemo = CreateObject( "CTextMem" )
         gcCodeInst = goStmt.NextByte()
         if m.glDump and not InList( gcCodeInst, S_METHOD, S_HIDDEN_PROC, S_PROTECTED_PR ) then
            goText.LnWrite( '* ' + goStmt.PlainDump(  0, goStmt.Length-1 ) )
         endif
      enddo
      if m.glDecomp then
         this.Footer() 
      endif
         
   endproc

enddefine


*/=============================================================================
define class CProc as CCode
*/=============================================================================
   lMember = .F.
   nClass  = 0

   */------------------------------------------------
   procedure Header
   */------------------------------------------------
      if not Empty( Cosmetic.ProcBetween ) then
         goText.LnWrite( Padr( '*/', 80, Cosmetic.ProcBetween ) )
      endif   
      if Empty(this.cName) then
         if m.glAllInOne then
            * --- When we put all sources in one file, we need to create an extra procedure
            *     for the leading code, to be able to verify compilation of AllInOne prg
            goText.LnWrite( 'procedure ' + ;
                            Left( this.oPart.cName, At('.',this.oPart.cName) - 1 ) + ;
                            Space(2) + Chr(38) + Chr(38) + '  added by dvfp when AllInOneFile is set' )
         else   
            goText.LnWrite( '*/ ' + this.oPart.cName )
         endif
      else
         if m.gcCodeInst = S_endproc then
            gcCodeInst = S_Method
         endif
         goText.LnWrite( gaCmdTxt( m.gcCodeInst ) + ' ' + this.cName )
      endif
      if not Empty( Cosmetic.ProcBetween ) then
         goText.LnWrite( Padr( '*/', 80, Cosmetic.ProcBetween ) )
      endif   
   endproc
   

   */------------------------------------------------
   procedure Footer
   */------------------------------------------------
      goText.Indent(-1)
      if not Empty(this.cName) then
         goText.LnWrite( gaCmdTxt(S_ENDPROC) )
      endif
      goText.Ln()
   endproc
 
enddefine


*/=============================================================================
define class CClass as CCode
*/=============================================================================
   cPere = ""
   nOle  = 0

enddefine


*/=============================================================================
define class CAppFile as CObject
*/=============================================================================
   cName   = ""                 && .APP, .FRX file name
   nbParts = 0                  && Nb parts in file
   nMain   = 0                  && Main part number (1 based)
   nEngine = 0                  && FoxPro engine
   nPartEntryTableOffset = 0    && Part entry table
   nEntryNameTableOffset = 0    && Part name table
   nEntryNameTableLength = 0    && Part name table length
   dimension aPart(1)           && array of Part objects
   cLastDir = ''

   
   */------------------------------------------------
   procedure Init()
   */------------------------------------------------
      this.nEngine = goInput.NextWord()
      this.nbParts = goInput.NextWord() 
      this.nMain   = goInput.NextWord() + 1 && 1 based
      if this.nbParts > 0 then
         dimension this.aPart(this.nbParts)
      endif
      this.nPartEntryTableOffset = goInput.NextUInt()
      this.nEntryNameTableOffset = goInput.NextUInt()
      this.nEntryNameTableLength = goInput.NextUInt()
   endproc
   

   */------------------------------------------------
   procedure Analyse()
   */------------------------------------------------
      local i
      local g
      local p
      local c
      
      if not m.glAllInOne then
         goText = CreateObject( "CTextOut", m.gcProjPath + ExtractFileName( goInput.cName ) + ".txt" )
      endif   
      goText.Write( '*/* ' + goInput.cName  )
      if Cosmetic.AppHeader then
         goText.LnWrite( '*   ' + time() + ' : ' + Ltrim(Str(this.nbParts)) + ' Parts, Main = ' + Ltrim(Str(this.nMain)) +;
                         ', Engine = ' + Ltrim(Str(Int(this.nEngine/256))) + '.' + Ltrim(Str(Mod(this.nEngine,256))) )
         goText.LnWrite( '*   Part Entry Table Offset = ' + Transform(this.nPartEntryTableOffset,'@0') )
         goText.LnWrite( '*   Entry Name Table Offset = ' + Transform(this.nEntryNameTableOffset,'@0') )  
         goText.LnWrite( '*   Entry Name Table length = ' + Transform(this.nEntryNameTableLength,'@0') )
      endif   
      if Cosmetic.PartTable then
         goText.LnWrite( '*   Part Genre      Start       Next NameOffset       IDK1       IDK2       IDK3 Name' )
      endif
      for i = 1 to this.nbParts
         goInput.Positionne( this.nPartEntryTableOffset + (m.i-1)* PARTENTRYSIZE ) 
         g = goInput.NextByte()
         do case 
            case m.g = gpCODEFILE  
               this.aPart( m.i ) = CreateObject( "CCodePart", m.g, this )
            otherwise
               this.aPart( m.i ) = CreateObject( "CPart", m.g, this )
         endcase
         if Cosmetic.PartTable then      
            with this.aPart( m.i )
               goText.LnWrite( '* ' + Str(m.i,6) + Str(.nGenre,6) + cHexa(.nStart,11) + cHexa(.nNextPart,11) +;
                      cHexa(.nNameOffset,11) + cHexa(.IDK1,11) + cHexa(.IDK2,11) + cHexa(.IDK3,11) + ' ' + .cName )
            endwith
         endif
      endfor
      goText.Ln()
      
      if not m.glAllInOne then
         goText = .F.
      endif
      
      for i = 1 to this.nbParts
         this.aPart( m.i ).Analyse()
      endfor
         
   endproc
   
enddefine
   

*/---------------------------------------------------------------------
procedure WriteCode( b as Byte )
*/---------------------------------------------------------------------
   if m.b <= MAXCOMMANDE then
      do case
         case InList( m.b, S_case, S_else, S_otherwise, S_CATCH, S_FINALLY )
            goText.Indent(-1)
            goMemo.LnWrite( gaCmdTxt(m.b) )
            goText.PostIndent(+1)
         case InList( m.b, S_enddo, S_endif, S_endfor, S_Endwith, S_ENDTRY, S_endprintjob, s_endscan, S_endfor_each )
            goText.Indent(-1)
            goMemo.LnWrite( gaCmdTxt(m.b) )
         case b = S_EndCase
            goText.Indent(-2)
            goMemo.LnWrite( gaCmdTxt(m.b) )
         case InList( m.b, S_IF, s_with, S_TRY, S_printjob, S_Scan )
            goMemo.LnWrite( gaCmdTxt(m.b) )
            goText.PostIndent(+1)
         case m.b = S_text
            goText.IndentOff()   
            goMemo.LnWrite( gaCmdTxt(m.b) )
         case m.b = S_endText
            goMemo.LnWrite( gaCmdTxt(m.b) )
            goText.IndentOn()   
         otherwise
            goMemo.LnWrite( gaCmdTxt(m.b) )
      endcase
   else
      if m.b = P_STRING then
         * Case of strings between text ... endtext
         goMemo.LnWrite( goStmt.NextPString() )
      else
         goMemo.LnWrite( cByte(m.b) )
      endif   
   endif
endproc


*/---------------------------------------------------------------------
procedure Reste( lEcrire )
*/---------------------------------------------------------------------
   local lcS
   local b
   lcS = ''
   b = 0
   do while goStmt.Position() < goStmt.Length
      b = goStmt.NextByte()
      lcS = m.lcS + ' ' + cByte(m.b)
   enddo
   if m.lEcrire and !Empty( m.lcS ) then
      goMemo.Write( m.lcS )
   endif 
endproc 


*/---------------------------------------------------------------------
procedure Fin( lEcrire )
*/---------------------------------------------------------------------
   local b as Byte
   if goStmt.Position() = goStmt.Length - 1
      b = goStmt.nextByte()
      if b = T_END_STMT then
         return 
      endif
   endif   
   do Reste with m.lEcrire
endproc   


*/---------------------------------------------------------------------
function MyProper( s as String ) as string
*/---------------------------------------------------------------------
   local r
   do case
      case m.s == "THIS"
         r = "this"
      case m.s == "THISFORM"
         r = "thisform"
      case Len(m.s) > 2 and InList( m.s, "LN", "LC", "LL", "LU", "LD", "LO", "LA",;
                                         "PN", "PC", "PL", "PU", "PD", "PO", "PA",;
                                         "GN", "GC", "GL", "GU", "GD", "GO", "GA" )
         r = Lower( Left( m.s, 2 ) ) + Proper( Substr( m.s, 3 ) )
      case Len(m.s)>1 and InList( m.s, "O" ) 
         r = Lower( Left( m.s, 1 ) ) + Proper( Substr( m.s, 2 ) )
      case Len(m.s)=1 and m.s <> "L"
         r = Lower( m.s )
      otherwise
         r = Proper( m.s )
   endcase
   return m.r
endfunc


