*/* Dump.prg
*/  For good looking, edit my files with tab size = 3 and indent size = 3 
*/------------------------------------------------------------------------
*/  This application dumps a non crypted .app build with VFP 8 or 9.
*/------------------------------------------------------------------------
*/  License for Dump
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
   private gcProjPath             && New project's directory
   private gcFileName             && File Name to decompile
   private gcCodeInst
   private gcOutFile
   private goOptions

   local lnMemoWidth
   local lcSafety
   local lcAsserts
   local lcProcedure
   local loErr

   store .F. to ;
      gcVersion, goInput, goText, goMemo, ;
      gcProjPath, gcFileName, ;
      gcOutFile, goOptions, gcCodeInst
   
   try
      gcVersion = "3.14"   && more acurately it is build 3.14159
      lnMemoWidth = Set( "Memowidth" )
      lcSafety    = Set( "safety" )
      lcAsserts   = Set( "Asserts" )
      lcProcedure = Set( "procedure" )
      
      set procedure to ;
         Tools, ;
         Streams, ;
         TextOut, ;
         AppFromExe additive
         
      set safety off
      set asserts on
      set memowidth to 8192
      _screen.Caption = "Dump - " + m.gcVersion 
   
      Main( m.cName )
   
   catch to loErr
      ShowError( m.loErr, "Dump Error" )
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
   
   clear
   
   lcIni = sys(5) + curdir() + ExtractFilename(Sys(16)) + ".ini"
   ReadIniFile( m.lcIni )
   goOptions = CreateObject( "COptions", m.lcIni )

   if Empty( m.cName ) then
      cName = GetFile( "VFP dump :exe,dll,app,fxp;All files:*.*","Select", "Dump")
      if Empty( m.cName ) then
         return
      endif
   endif
   if not File( m.cName ) then
      error "File " + m.cName + " not found"
   endif
    
   gcFileName = ExtractFileName( m.cName )
   gcProjPath = ExtractFilePath( m.cName )
   
   goInput = CreateObject( "CBinaryFile", m.cName )
   
   gcOutFile = m.gcProjPath + m.gcFileName + '.txt'
   goText  = CreateObject( "CTextOut", m.gcOutFile )
   goText.WriteLn( "Dump started " + Ttoc(Datetime()) )
   
   * --- if we got an Exe file we need to extract the app file
   lnWord = m.goInput.NextWord()
   if m.lnWord = IMAGE_DOS_SIGNATURE then
      goInput = .F.   && release the object
      lcExeName = m.cName
      cName = AppExtract( m.cName )
      if Empty( m.cName )
         error m.lcExeName + LOC_APPNOTFOUNDINEXE
      endif
      goInput = CreateObject( "CBinaryFile", m.cName )
      lnWord = m.goInput.NextWord()
   endif
         
   if m.lnWord <> FOXPROAPP then
      error m.cName + LOC_NOTPROPERAPP 
   endif

   lnByte = goInput.NextByte()
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
   
   goText.LnWrite("Dump ended " + Ttoc(Datetime()) )

   release goInput, goText
   set procedure to 
   
   if Version(2) = 0 then && RunTime
      modify File(m.gcOutFile)
   else
      modify File(m.gcOutFile) nowait
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
endproc


*/=============================================================================
define class CObject as Relation
*/=============================================================================
*  Ancestor of all our objects. We inherit from Relation because Relation is a
*  very small object. If we need properties like 'Class' we will shift to
*  Custom, but it's not the case. 
enddefine


*/=============================================================================
define class COptions as CObject
*/=============================================================================
* Options object 
   
   AppDump       = .F.
   CodePartDump  = .F.
   OtherPartDump = .F.
   LineTable     = .F.
   lEcho         = .F.
   
   procedure Init( cIni as String )
      with this
         .AppDump       = Evaluate( GetPPS( m.cIni, [Options], [AppDump]      , '.F.' ) )
         .CodePartDump  = Evaluate( GetPPS( m.cIni, [Options], [CodePartDump] , '.F.' ) )
         .OtherPartDump = Evaluate( GetPPS( m.cIni, [Options], [OtherPartDump], '.F.' ) )
         .LineTable     = Evaluate( GetPPS( m.cIni, [Options], [LineTable]    , '.F.' ) )
         .LineTable     = Evaluate( GetPPS( m.cIni, [Options], [LineTable]    , '.F.' ) )
         .lEcho         = Evaluate( GetPPS( m.cIni, [Options], [Echo]         , '.T.' ) )
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
   fileType    = 0   && type of dbf (scx,frx,vcx,...) 
   nNameOffset = 0   && Offset name in Name table
   unused1     = 0   && 
   unused2     = 0   && 
   cName       = ""  && Part name
   lSnipet     = .F. && Compiled snipet (cName='')
   oApp        = .F.

   procedure Init( g, owner )
      with this
         .oApp        = m.owner
         .nGenre      = m.g
         .nStart      = goInput.NextUInt()
         .nNextPart   = goInput.NextUInt()
         .fileType    = goInput.NextUInt()
         .nNameOffset = goInput.NextUInt()
         .unused1     = goInput.NextUInt()
         .unused2     = goInput.NextUInt()
         goInput.Positionne( m.owner.nEntryNameTableOffset + .nNameOffset )
         .cName       = goInput.NextCString()
         if Empty( .cName ) then
            .cName = "_snipet.fxp"
         endif 
      endwith
   endproc

   procedure Analyse()
      if goOptions.OtherPartDump then 
         goText.LnWrite( GoInput.DecoratedDump( this.nStart, this.nNextPart - 1, goOptions.lEcho ) )
      else
         goText.Write( ' ...' )
      endif   
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
   debIdkTable1  = 0     && I dont know
   lenStmtTable  = 0     && idem
   debStmtTable  = 0     && I dont know
   
   dimension IdkByte(9)
   dimension Procs(1)    && array of procedure entry
   dimension Classes(1)  && array of class entry
   
   procedure Analyse()
      local w
      local l1, l3, iStmt, iLine
      goText.LnWrite( 'PART HEADER' )
      goInput.Positionne( this.nStart )
      with this  
         .nbProc        = goInput.NextWord() + 1 && + 1 for Main
         .nbClass       = goInput.NextWord()
         .debMain       = goInput.NextUInt()
         .debProcTable  = goInput.NextUInt()
         .debClassTable = goInput.NextUInt()
         .debIdkTable1  = goInput.NextUInt()
         .lenStmtTable  = goInput.NextUInt()         
         .debStmtTable  = goInput.NextUInt()
         for i = 1 to 9
            .IdkByte(i) = GoInput.NextByte()
         endfor
         
         goText.LnWrite( '   NbProc       ' + cSmall( .nbProc - 1 ) )
         goText.LnWrite( '   NbClass      ' + cSmall( .nbClass ) )
         goText.LnWrite( '   ^Main        ' + cInt  ( .debMain ) )
         goText.LnWrite( '   ^ProcTable   ' + cInt  ( .debProcTable ) )
         goText.LnWrite( '   ^ClassTable  ' + cInt  ( .debClassTable ) )
         goText.LnWrite( '   ^IdkTable1   ' + cInt  ( .debIdkTable1 ) )
         goText.LnWrite( '   LineTableLen ' + cInt  ( .lenStmtTable ) )
         goText.LnWrite( '   ^LineTable   ' + cInt  ( .debStmtTable ) )
         goText.LnWrite( '   IdkBytes     ' )
         for i = 1 to 9
            goText.Write( cByte( .IdkByte(i) ) + ' ' )
         endfor
         if goOptions.CodePartDump then
            goText.LnWrite( 'PART DUMP' )
            goText.LnWrite( GoInput.DecoratedDump( this.nStart, this.nNextPart - 1, goOptions.lEcho ) )
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
            if .nbProc > 1 then
               goText.LnWrite('  ProcTable')
               goText.LnWrite('  Proc    Start Member Class Name' )
               *                    1 00000000   0000  0000 abcd.fxp
            endif
            for p = 2 to .nbProc
               with .Procs( m.p )
                  goText.LnWrite( '  ' + csmall( p-2 ) + ' ' + cInt( .nPtr ) + '   ' + cSmall( .lMember ) + '  ' + cSmall(.nClass) + ' ' + .cName )
               endwith
            endfor
         endif
         
         if goOptions.LineTable then
            goText.LnWrite( '  LineTable' )
            * goText.LnWrite( '  Stmt  Len  Lines' )
            * Better
            goText.LnWrite( '   Stmt   Line' )
            goInput.Positionne( .nStart + .debStmtTable )
            iStmt = 0
            iLine = 0
            i = 0
            do while m.i <= .lenStmtTable 
               b1 = goInput.NextByte()
               b2 = goInput.NextByte()
               i = m.i + 1
               * goText.LnWrite( '  ' + cSmall( i - 1 ) + '  ' +  cByte(m.b2) + cHighNibble( m.b1) + '  ' + cLowNibble( m.b1 )  )
               * Better
               l3 = BitLShift( m.b2, 4 ) + BitRShift( m.b1,4 )
               l1 = BitAnd( m.b1, 0x0F )
               iStmt = m.iStmt + 1
               if m.l1 > 0 then
                  iLine = m.iLine + m.l1
                  goText.LnWrite( Str( m.iStmt, 7, 0 ) + Str( m.iLine, 7 , 0 ) )
               else
                  iLine = m.iLine + m.l3 + 1
                  goText.LnWrite( Str( m.iStmt, 7, 0 ) + Str( m.iLine, 7 , 0 ) )
                  b1 = goInput.NextByte()
                  b2 = goInput.NextByte()
                  i = m.i + 1
                  * goText.LnWrite( '  ' + cSmall( i - 1 ) + '  ' +  cByte(m.b2) + cHighNibble( m.b1) + '  ' + cLowNibble( m.b1 )  )
               endif
            enddo
         endif
         
         goText.Ln
         goText.LnWrite( '  Table1' )
         goText.LnWrite( '  ' )
         goInput.Positionne( .nStart + .debIdkTable1 )
         for i = 1 to 16
            goText.Write( cByte( goInput.NextByte() ) + ' ' )
         endfor
         
         if .nbProc > 1
            goText.Ln
            goText.LnWrite( '  ProcSrcPtr' )
            goText.LnWrite( '  proc  LstLnPre FrstByte LastByte FrstLine' )
         endif
         for p = 2 to .nbProc 
            goText.LnWrite( '  ' + cSmall( p - 2 ) + '  ' )
            for j = 1 to 4
               goText.Write(  cInt( goInput.NextInt() ) + ' ' )
            endfor
         endfor
         if .nbClass > 0 then
            goText.Ln
            goText.LnWrite( '  ClassSrcPtr' )
            goText.LnWrite( '  Class LstLnPre FrstByte LastByte FrstLine' )
         endif   
         for c = 1 to .nbClass 
            goText.LnWrite( '  ' + cSmall( c - 1 ) + '  ' )
            for j = 1 to 4
               goText.Write(  cInt( goInput.NextInt() ) + ' ' )
            endfor
         endfor
         
      
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
            goText.Ln
            goText.LnWrite('  ClassTable')
            goText.LnWrite('  Class   Start OlePub Name                             Ancestor' )
            *                    1 00000000   0000 abcd                             object
            for c = 1 to .nbClass
               with .Classes( m.c )
                  goText.LnWrite( '  ' + cSmall( c - 1) + ' ' + cInt( .nPtr ) + '   ' + cSmall( .nOle ) + ' ' + .cName + Space( 33 - Len(.cName)) + .cPere  )
               endwith
            endfor
         endif
         
      endwith
      
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
   endproc
   

   */------------------------------------------------
   procedure Footer
   */------------------------------------------------
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
   nEngine = 0                  && FoxPro engine version
   nPartEntryTableOffset = 0    && Part entry table
   nEntryNameTableOffset = 0    && Part name table
   nEntryNameTableLength = 0    && Part name table length
   dimension aIdk(6)
   
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
      for i = 1 to 4
         this.aIdk(i) = goInput.NextUInt()
      endfor
      this.aIdk(5) = goInput.NextWord()
      this.aIdk(6) = goInput.NextWord()
   endproc
   

   */------------------------------------------------
   procedure Analyse()
   */------------------------------------------------
      local i
      local g
      local p
      local c
      
      goText.Write  ( 'APP HEADER of ' + goInput.cName  )
      goText.LnWrite( '   Signature          ' + cSmall(FOXPROAPP) )
      goText.LnWrite( '   Crypted            ' + cByte (NOCRYPTED) )
      goText.LnWrite( '   Engine             ' + cSmall(this.nEngine) )
      goText.LnWrite( '   nbParts            ' + cSmall(this.nbParts) )
      goText.LnWrite( '   MainPart           ' + cSmall(this.nMain) )
      goText.LnWrite( '   ^PartTable         ' + cInt(this.nPartEntryTableOffset) )
      goText.LnWrite( '   ^PartNameTable     ' + cInt(this.nEntryNameTableOffset) )  
      goText.LnWrite( '   PartNameTable size ' + cInt(this.nEntryNameTableLength) )
      for i = 1 to 4
         goText.LnWrite( '   Idk('+Ltrim(Str(i))+ ')             ' + cInt(this.aIdk(i)) )
      endfor   
      goText.LnWrite( '   Idk(5)             ' + cSmall(this.aIdk(5)) )
      goText.LnWrite( '   Idk(6)             ' + cSmall(this.aIdk(6)) )
      goText.Ln()
      if goOptions.AppDump then
         goText.LnWrite( "APP DUMP" )
         goText.LnWrite( goInput.DecoratedDump( 0, this.nPartEntryTableOffset + PARTENTRYSIZE*this.nbParts - 1, goOptions.lEcho ))
         goText.Ln()
      endif
      goText.LnWrite( 'PART TABLE' )
      goText.LnWrite( '   Part Type       Start       Next   FileType NameOffset    unused1    unused2  Name' )
      for i = 1 to this.nbParts
         goInput.Positionne( this.nPartEntryTableOffset + (m.i-1)* PARTENTRYSIZE ) 
         g = goInput.NextByte()
         do case 
            case m.g = gpCODEFILE  
               this.aPart( m.i ) = CreateObject( "CCodePart", m.g, this )
            otherwise
               this.aPart( m.i ) = CreateObject( "CPart", m.g, this )
         endcase
         with this.aPart( m.i )
            goText.LnWrite( Str(m.i,7) + '   ' + cByte(.nGenre) + '    ' + cInt(.nStart) + '   ' + cInt(.nNextPart) +;
                   '   ' + cInt(.fileType   ) + ;
                   '   ' + cInt(.nNameOffset) + ;
                   '   ' + cInt(.unused1    ) + ;
                   '   ' + cInt(.unused2    ) + ;
                   '  ' + .cName )
         endwith
      endfor
      goText.Ln()
      
      for i = 1 to this.nbParts
         goText.Ln()
         goText.LnWrite( 'PART ' + this.aPart( m.i ).cName )
         ?? '.'
         this.aPart( m.i ).Analyse()
      endfor
         
   endproc
   
enddefine
   



