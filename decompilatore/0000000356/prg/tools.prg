*/* Tools
*/---------------------------------------------------------------------
*/  Some tools for Dump and DVFP
*/  Copyright 2004-2006 by Robert Plagnard <robert.plagnard@ingelog.fr>
*/---------------------------------------------------------------------
#include FoxPro.h

   * --- to do some simple tests just run this file
   clear
   atest("abc.def")
   atest("c:\ppp\qqq\abc.def")
   atest("d:abc.def")
   atest("d:abc.def\")
   atest("d:")
   atest("")
   ? cHighNibble( 0xAB ), cLowNibble( 0xAB )
   ? cSmall(-1)
   ? cSmall(65535)
   ? cSmall(65536)
   ? cSmall(-32768)
   ? cInt( 2^31 - 1 )
   ? cInt( -2^31 )
 
function atest(x)
   ? Quote(x), ;
     Quote( ExtractFilePath(x)), Quote(JustPath(x)),;
     Quote( ExtractFileName(x)), Quote(JustFname(x)),;
     Quote( ExtractFileExt(x) ), Quote(JustExt(x)),;
     x == ExtractFilePath(x) + ExtractFileName(x) + ExtractFileExt(x)
endfunc

*/---------------------------------------------------------------------
function cHighNibble( nByte )
*/---------------------------------------------------------------------
*  A nibble is half a byte. It's 4 bits or a hexadecimal digit.
*  It once happens that we need to cut bytes into nibbles when we
*  will analyse an APP file.
*  Input should be between 0 and 255
*  Return the high (or left) hexadecimal character of a byte
   return Right( Transform( BitRShift(m.nByte,4), '@0' ), 1 )
endfunc


*/---------------------------------------------------------------------
function cLowNibble( nByte )
*/---------------------------------------------------------------------
*  Return the low (or right) hexadecimal character of a byte
*  Input should be between 0 and 255
   return Right( Transform( BitAnd(m.nByte,0x0F), '@0' ), 1 )
endfunc


*/---------------------------------------------------------------------
function cByte( nByte )
*/---------------------------------------------------------------------
*  Return a string of two hexadecimal digits. Ex 127 --> '7F'
*  Input should be between 0 and 255
   return Right( Transform( m.nByte, '@0' ), 2 )
endfunc


*/---------------------------------------------------------------------
function cSmall( nSmall )
*/---------------------------------------------------------------------
*  Return a string of 4 hexadecimal digits. Ex 65535 --> 'FFFF'
*  Input should be unsigned between 0 and 65535 = 2^16 -1, but it also
*  works for negatives ex: -1 --> 'FFFF' Strange isn't it. No because
*  as small integer, -1 and 65535 have the same bit pattern. It's
*  only a question of interpretation.
   return Right( Transform( m.nSmall, '@0' ), 4 )
endfunc


*/---------------------------------------------------------------------
function cTriple( nInt )
*/---------------------------------------------------------------------
*  Return a string of 6 hexadecimal digits. 
*  Input should be between 0 and 2^24 -1
   return Right( Transform( m.nInt, '@0' ), 6 )
endfunc


*/---------------------------------------------------------------------
function cInt( nInt )
*/---------------------------------------------------------------------
*  Return a string of 8 hexadecimal digits. Ex 14 --> '0000000E'
*  Input should be between 0 and 2^32 -1
   return Right( Transform( m.nInt, '@0' ), 8 )
endfunc


*/---------------------------------------------------------------------
function cHexa( nInt, nWidth )
*/---------------------------------------------------------------------
*  Return the heaxadecimal string of nInt, without leading zeros and 
*  left padded with blanks for a total length of nWidth characters.
   local lcS
   local n 

   lcS = Right( Transform( m.nInt, '@0' ), 8 )
   n = 1
   do while m.n < 8 and Substr( m.lcs, m.n, 1 ) == '0'
      m.n = m.n + 1
   enddo
   lcS = Right( m.lcS, 8 - m.n + 1 )
   if not Empty( m.nWidth ) and m.nWidth > Len( m.lcS ) then
      lcS = Padl( m.lcS, m.nWidth )
   endif
   return m.lcS
endfunc


*/---------------------------------------------------------------------
function cPrintable( nByte )
*/---------------------------------------------------------------------
*  Try to return Chr(nByte) but returns '.' when the character (8 bits)
*  is not printable. Between 9F and FF it's as you like. Because I'm 
*  french I print some characters with accents, but not all for
*  sake of easy reading. Usefull function to write a memory dump.
   return Iif( m.nByte < 0x20 or ;
              ( m.nByte >= 0x7F and not ( Chr(m.nByte) $ "éèêàùöëâ" ) ),;
              '.',;
              Chr( m.nByte ) )
endfunc


*/---------------------------------------------------------------------
function Quote( s as String ) as String
*/---------------------------------------------------------------------
*  Try to "quotes" a string, for being compilable.
*  Ex :
*  abcd     -->  'abcd'     simple if there is no ' we use it 
*  ab"]cd   -->  'ab"]cd'   idem
*  ab'c]d   -->  "ab'c]d"   we cannot use ' so we take "
*  ab'c"[d  -->  [ab'c"[d]  we cannot use ' neither " so we take [ and ]
*  ab'c"]d  -->  'ab`c"]d'  if ' " and ] are all present we change "'" 
*                           by a grave accent.   
   if At("'",m.s) = 0 then
      s = "'" + m.s + "'"
   else
      if At( '"', m.s ) = 0 then
         s = '"' + m.s + '"'
      else
         if At( "]", m.s ) = 0 then
            s = '[' + m.s + ']' 
         else
            * --- Very few chance to get there but rather than raise an
            *     error I prefer to change the single quote into grave
            *     accent, so there is always an answer to the function.
            s = "'" + Chrtran( m.s, "'", "`" ) + "'"
         endif
      endif
   endif
   return m.s                   
endfunc

*/---------------------------------------------------------------------
function UnQuote( s as String ) as String
*/---------------------------------------------------------------------
*  Try to strip quotes, if any, in first and last position of the string
   return Iif( Len( m.s ) >= 2 and ;
                  (( InList(Left(m.s,1),['], ["]) and Right(m.s,1) = Left(m.s,1) ) or;
                   ( Left(m.s,1) = '[' and Right(m.s,1) = ']' )),;
               Substr( m.s, 2, Len( m.s ) - 2 ),; 
               m.s )
endfunc


*/---------------------------------------------------------------------
function ExtractFilePath( cName as string ) as string
*/---------------------------------------------------------------------
*  The file path is before the file name. It can be empty. 
*  the last "\" or the "C:" belongs to the file path such that we assert :
*  x == ExtractFilePath(x)+ExtractFileName(x)+ExtractFileExt(x)
   lnBS = At('\',m.cName)
   return Iif( m.lnBS = 0, JustDrive( m.cName ), Addbs(JustPath( m.cName )) )
endfunc


*/---------------------------------------------------------------------
function ExtractFileName( cName as string ) as string
*/---------------------------------------------------------------------
*  The filename is between the path and the extension
   local lc, lnDot
   lc = JustFname( m.cName )
   lnDot = Rat( '.', m.lc )
   return Iif( m.lnDot = 0, m.lc, Left( m.lc, m.lnDot - 1 ) )
endfunc


*/---------------------------------------------------------------------
function ExtractFileExt( cName as string ) as string
*/---------------------------------------------------------------------
*  The extension is the last "dot something". It can be empty. 
*  the dot belongs to extension ex: ".prg" or ".exe" such that
*  x == ExtractFilePath(x)+ExtractFileName(x)+ExtractFileExt(x)
   local lc
   lc = JustExt( m.cName )
   return Iif( Empty(m.lc), '', '.' + m.lc )
endfunc


*/---------------------------------------------------------------------
Function NeedPath( cPath as string, cSubPath as string ) as string
*/---------------------------------------------------------------------
*  if it does not exist creates a subdirectory cSubPath of cPath.
*  cPath must exists
   local lcName
   assert Type( "m.cPath" ) = "C"
   assert Type( "m.cSubPath" ) = "C"
   lcName = Addbs(m.cPath) + Addbs(m.cSubPath)
   if not Directory( m.lcName )
      if not Directory( m.cPath )   
         error "Directory " + m.cPath + " not found"
      endif
      md ( m.lcName )
   endif
   return m.lcName
endproc


*/-----------------------------------------------------------------------------
function GetPPS( FicIni  as string ,; && full pathname of a .INI file
                 Section as string ,; && Name of a [Section]
                 Cle     as String ,; && key name searched
                 Defaut  as string ); && default value
                 as string 
*/-----------------------------------------------------------------------------
*  Abreviates GetPrivateProfileString
*  Allows to read a key in an .INI file

   declare integer GetPrivateProfileString IN win32api as GetPrivateString ;
      string Section  ,;
      string Clef     ,;
      string Defaut   ,;
      string @ buffer ,;
      long   BufSize  ,;
      string IniFile

   local  buffer
   local  n

   buffer = space( 80 )
   n = GetPrivateString( m.Section, m.Cle, m.Defaut, @m.buffer, 80, m.FicIni )

   return alltrim( left( m.buffer, m.n ) )

endfunc


*/-----------------------------------------------------------------------------
procedure ShowError( e as Exception , cCaption as String )
*/-----------------------------------------------------------------------------
*  Can be used when you catch an error
   with m.e
      MessageBox( Iif( Type("m.e.UserValue.Message")='C', .UserValue.Message + Chr(13), '' ) +;
                  "Error " + Ltrim(Str( .ErrorNo )) + " : " + .Message + Chr(13) +;
                  "Line " + Ltrim(Str( .LineNo ))  + " in procedure " + .Procedure + Chr(13) +;
                  Iif( Empty(.Class), '', "Class " + .Class + Chr(13)) +;
                  Iif( Empty(.ClassLibrary), '', "ClassLibrary " + .ClassLibrary + Chr(13)) ,;
                  MB_ICONSTOP,;
                  m.cCaption )            
   endwith
endproc   

