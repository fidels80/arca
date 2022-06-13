*/* AppFromExe
*/-----------------------------------------------------------------------

* --- just for testing purpose (change at your convenience)
clear
set procedure to prg\Streams,prg\tools 
try
   ? Quote( AppExtract( "C:\Dev\DVFP2\Test\webservice\wsenvoiod.dll" ) )
catch to Err
   ? "Error '" + Err.Message + "' at line " + Ltrim( Str(Err.Lineno) ) + " in " + Err.Procedure
finally
endtry

#include dfox.h
#include dfoxloc.h

*/------------------------------------------------------------------------
function AppAddr( cExeName as String ) as integer
*/------------------------------------------------------------------------
*  Returns the offset address of the APP stored in an EXE file created by
*  VFP. If it fails to find the APP it returns a negative value. 
*  For more explanations see microsoft windows.h of visual studio
*  and http://www.microsoft.com/whdc/system/platform/firmware/PECOFF.mspx
*  And Portable Executable File Format from Prasad Dabak Publisher
*  M&T Books

   local loExe                  && CBinaryFile (permanent input stream)
   local loMem                  && CMemory (in memory input stream)
   local lnSections             && number of sections .text, .data, ...
   local lnOptionalHeaderSize   && read from the exe file
   local lcSection              && section name 
   local lnSizeOfRowData        && The app is located after the last section
   local lnPointerToRowData     && 
   local lnRet                  && return value (can be < 0 if we do not found)
   local lnPEPtr
   local lnIconLen
   
   loExe = CreateObject( "CBinaryFile", m.cExeName )
   if loExe.NextWord() <> IMAGE_DOS_SIGNATURE then
      return -1 && error m.cExeName + LOC_NOTANEXEFILE
   endif
   
   loExe.Positionne( IMAGE_PE_ADDRESS )
   lnPEPtr = loExe.NextUInt()
   if m.lnPEPtr > loExe.Length - 4 then
      return -2 && error m.cExeName + LOC_NOTANEXEFILE32
   endif   
   loExe.Positionne( m.lnPEPtr )
   if loExe.NextInt() <> IMAGE_PE_SIGNATURE then
      return -3 && error m.cExeName + LOC_NOTANEXEFILE
   endif
   
   * --- read File header in memory for convenience
   loMem = CreateObject( "CMemory", loExe.Read(IMAGE_FILE_HEADER_SIZE) )
   loMem.Positionne( 2 )
   lnSections = loMem.NextWord()
   loMem.Positionne( 0x10 )
   lnOptionalHeaderSize = loMem.NextWord() 
   
   * --- continue with exe file, skip optional header and n-1 section headers
   loExe.Positionne( loExe.Position() + ;
                     m.lnOptionalHeaderSize + ;
                     ( m.lnSections - 1 ) * IMAGE_SIZEOF_SECTION_HEADER )

   * --- read last section header in memory
   loMem = CreateObject( "CMemory", loExe.Read( IMAGE_SIZEOF_SECTION_HEADER ))
   lcSection = loMem.NextCString()

   loMem.Positionne( 0x10 )
   lnSizeOfRowData = loMem.NextInt()
   lnPointerToRowData = loMem.NextInt()
   lnRet = m.lnPointerToRowData + m.lnSizeOfRowData
   loExe.Positionne( m.lnRet )
   
   * --- App file can be there
   lwSuite = loExe.NextWord()
   loExe.Back(2)
   if m.lwSuite <> FOXPROAPP then && not found yet
      if m.lwSuite = 0x2020 && two blanks in DLL olepublic case
         lcStr = loExe.NextCstring()
         lnRet = loExe.Position() + 0x0E - 1 
      else && may be an exe with icon
         lnIconLen = IconSize( m.loExe ) && returns < 0 if it fails to be an icon
         if m.lnIconLen < 0 then
            return -6
         endif   
         lnRet = m.lnRet + m.lnIconLen + 0x0E
      endif
      loExe.Positionne( m.lnRet )
      lwSuite = loExe.NextWord()
   endif
   
   * --- we check if it's really an APP
   if m.lwSuite <> FOXPROAPP
      lnRet = -5
   endif

   return m.lnRet

endfunc


*/------------------------------------------------------------------------
function IconSize( oStream ) as integer
*/------------------------------------------------------------------------
* see http://www.daubnet.com/formats/ICO.html

#define ICON_ENTRY_SIZE 0x10 

   local i
   local loMem
   local lnSize
   local lnNbIcons
   
   oStream.NextWord()                   && should be 0x00 but I met 0xF0 !
   if oStream.NextWord() <> 1 then      && should be 1 
      return -1 && error "Error analysing icon data"
   endif
   lnNbIcons = oStream.NextWord()       && should be a very short number in our case
   if m.lnNbIcons > 32 then
      return -2 && error "Error analysing icon data"
   endif
   lnSize = 6 + ICON_ENTRY_SIZE * lnNbIcons
   for i = 1 to m.lnNbIcons
      loMem = CreateObject( "CMemory", oStream.Read( ICON_ENTRY_SIZE ) )
      loMem.Positionne( 8 )
      lnSize = m.lnSize + loMem.NextInt()
   next i
   
   return m.lnSize

endproc

*/------------------------------------------------------------------------
function AppExtract( cExeName as String ) as string
*/------------------------------------------------------------------------
*/  Returns the pathname of the extracted app.
*/  Returns empty string if we fail to find an app in the exe/dll file

#define BUFFERSIZE 0x8000

   local lnPos
   local lcAppName
   local lh
   local lw
   local lnOffset
   
   lnPos = Rat( ".", Lower( m.cExeName ) )
   lcAppName = Left( m.cExeName, m.lnPos ) + "app"
   try
      lnOffSet = AppAddr( m.cExeName )
      if m.lnOffset > 0 then
         lh = Fopen( m.cExeName, 0 )
         lw = Fcreate( m.lcAppName )
         Fseek( m.lh, m.lnOffSet )
         do while not Feof( m.lh )
            lBuffer = Fread( m.lh, BUFFERSIZE )
            Fwrite( m.lw, m.lBuffer )
         enddo
      else
         lcAppName = ''   
      endif
   catch to e
      showError( e, "Pas d'APP extrait" )
      lcAppName = ""
   finally
      Fclose( m.lh )
      Fclose( m.lw )   
   endtry
   
   return m.lcAppName
   
endfunc
   