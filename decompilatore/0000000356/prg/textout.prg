*/* TextOut.prg
*/----------------------------------------------------------------------------
*/  This classes encapsulates some nice behaviours of output byte streams.
*/  Opening, closing, indentation, merge, ...
*/  Allows indentation of text stream with methods IndentOn() IndentOff() Indent(+/-inc)
*/  SetIndent( nVal ) PostIndent(+/-inc)
*/  property nIndentSpaces can be changed
*/  Exemples if s is an output stream :
*/     s.WriteLn( "aaaxxx")
*/     s.Indent( +2 )
*/     s.Writeln( "bbb" )
*/     s.Writeln( "ccc" )
*/     s.Indent( -1 )
*/     s.Writeln( "ddd" )
*/  will output :
*/
*/  aaaxxx
*/        bbb
*/        ccc
*/     ddd 
*/
*/  CTextOut and CTextMem inherits from abstract class CText 
*/  RP 01-2005
*/----------------------------------------------------------------------------  

*/=============================================================================
define class CText as CObject
*/=============================================================================
*  Abstract class for output stream

   nIndent = 0
   nIndentSpaces = 3
   nPostedIndent = 0
   nIndentSave = 0
   
   */--------------------------------------------------------------------------   
   procedure Init( cFileName )
   */--------------------------------------------------------------------------   
      error "CText is an abstract class"
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Close
   */--------------------------------------------------------------------------   
   endproc

   */--------------------------------------------------------------------------   
   procedure Destroy
   */--------------------------------------------------------------------------   
      this.Close()
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Ln
   */--------------------------------------------------------------------------   
      error "CText::Write is abstract"
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Write( s as String )
   */--------------------------------------------------------------------------   
      error "CText::Write is abstract"
   endproc
   
   */--------------------------------------------------------------------------   
   procedure WriteLn( s as String )
   */--------------------------------------------------------------------------   
      this.Write( s )
      this.Ln()
   endproc
   
   */--------------------------------------------------------------------------   
   procedure LnWrite( s as String )
   */--------------------------------------------------------------------------   
      this.Ln()
      this.Write( m.s )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Indent( inc as Integer )
   */--------------------------------------------------------------------------   
      this.nIndent = Max( 0, this.nIndent + m.inc )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure PostIndent( inc as Integer )
   */--------------------------------------------------------------------------   
      this.nPostedIndent = m.inc
   endproc

   */--------------------------------------------------------------------------   
   procedure SetIndent( nVal as integer )
   */--------------------------------------------------------------------------   
      this.nIndent = m.nVal
   endproc
   
   */--------------------------------------------------------------------------   
   procedure IndentOff
   */--------------------------------------------------------------------------   
      this.nIndentSave = this.nIndent
      this.nPostedIndent = -this.nIndent
   endproc
   
   */--------------------------------------------------------------------------   
   procedure IndentOn
   */--------------------------------------------------------------------------   
      this.nIndent = this.nIndentSave 
   endproc
   
enddefine


*/=============================================================================
define class CTextOut as CText
*/=============================================================================
*  Output stream based on text file

   hOut = -1
   
   */--------------------------------------------------------------------------   
   procedure Init( cFileName as String )
   */--------------------------------------------------------------------------   
      this.Open( m.cFileName )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Open( cFileName as String )
   */--------------------------------------------------------------------------   
      this.hOut = Fcreate( m.cFileName )
   endproc

   */--------------------------------------------------------------------------   
   procedure Close
   */--------------------------------------------------------------------------   
      Fclose( this.hOut )
   endproc

   */--------------------------------------------------------------------------   
   procedure Ln
   */--------------------------------------------------------------------------   
      Fwrite( this.hOut, Chr(13) + Chr(10) + Space(this.nIndent*this.nIndentSpaces) )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Write( s as String )
   */--------------------------------------------------------------------------   
      Fwrite( this.hOut, m.s )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Merge( Mem as CTextMem )
   */--------------------------------------------------------------------------   
      local lnNb
      local i
      local lcLast
      lnNb = Memlines( Mem.cTxt )
      for i = 1 to m.lnNb - 1
         this.Write( Mline( Mem.cTxt, m.i ) )
         this.Ln()
      endfor
      lcLast = Mline( Mem.cTxt, m.lnNb )
      if Len( m.lcLast ) > 0
         this.Write( m.lcLast )
      else
         this.Ln()   
      endif
      if this.nPostedIndent <> 0 then
         this.nIndent = this.nIndent + this.nPostedIndent
         this.nPostedIndent = 0
      endif   
   endproc
   
enddefine


*/=============================================================================
define class CTextMem as CText
*/=============================================================================
*  In memory output stream. Output is done to a string

   cTxt = ''   && Value of the output stream
   
   */--------------------------------------------------------------------------   
   function Harvest   && Moissonner (for frogs), get the value and reset to ''
   */--------------------------------------------------------------------------   
      local lcTxt
      lcTxt = this.cTxt
      this.cTxt = ''
      return m.lcTxt
   endfunc
   
   */--------------------------------------------------------------------------   
   procedure Init( cTxt )
   */--------------------------------------------------------------------------   
      if !Empty( m.cTxt )   
         this.cTxt = m.cTxt
      endif 
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Ln
   */--------------------------------------------------------------------------   
      this.cTxt = this.cTxt + Chr(13) + Chr(10)
      if this.nIndent > 0 then
         this.cTxt = this.cTxt + Space(this.nIndent*this.nIndentSpaces)
      endif   
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Write( s )
   */--------------------------------------------------------------------------   
      this.cTxt = this.cTxt + m.s
   endproc

enddefine
