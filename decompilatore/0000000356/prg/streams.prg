*/* Streams.prg
*/----------------------------------------------------------------------------
*/  This classes encapsulates some nice behaviours of input byte streams.
*/  Opening, closing, positionning, reading byte, bytes, string (C or Pascal),
*/  integer, doubles and even pushback characters, dump, and some more ...
*/  CBinaryFile and CMemory inherits from abstract class CStream 
*/  RP 01-2005
*/----------------------------------------------------------------------------  

#define FROM_BEGINNING_OF_FILE   0
#define FROM_END_OF_FILE        2
#define FROM_CURRENT_POSITION   1
#define FROM_END_OF_FILE        2
#define MAXINT32  0x7FFFFFFF
#define MAXBUFFER 80


*/=============================================================================
define class CStream as Relation
*/=============================================================================
   nPosition = -1
   nLastByte = 0
   Length = 0
   Buffer = ''

   
   */--------------------------------------------------------------------------   
   procedure init()
   */--------------------------------------------------------------------------   
      error "abstract class, cannot be instanciated"
   endproc

   
   */--------------------------------------------------------------------------   
   function Read( nByte as Integer ) as String
   */--------------------------------------------------------------------------   
      error "abstract procedure, must be overidden"
   endfunc

   
   */--------------------------------------------------------------------------   
   function nPosition_Access() as Integer
   */--------------------------------------------------------------------------   
      return this.nPosition
   endfunc

   
   */--------------------------------------------------------------------------   
   procedure nPosition_Assign( nValue as Integer )
   */--------------------------------------------------------------------------   
      error "abstract procedure, must be overidden"
   endproc

   
   */--------------------------------------------------------------------------   
   procedure Positionne( nValue as Integer )
   */--------------------------------------------------------------------------   
      this.nPosition = m.nValue
   endproc

   
   */--------------------------------------------------------------------------   
   function Position
   */--------------------------------------------------------------------------   
      return this.nPosition
   endproc

   
   */--------------------------------------------------------------------------   
   function PlainDump( nFrom, nTo ) as string
   */--------------------------------------------------------------------------   
      local lnSavePos
      local lcBuff
      local lnLong
      local i
      local lcRet
      
      lnSavePos = this.nPosition
      this.nPosition = m.nFrom
      lnLong = m.nTo - m.nFrom + 1
      if m.lnLong > 0 then
         lcBuff = this.Read( m.lnLong )
         lcRet = ''
         for i = 1 to m.lnLong
            lcRet = m.lcRet + cByte(Asc(Substr(m.lcBuff,m.i,1))) + ' '
         endfor
      endif
      this.nPosition = m.lnSavePos
      return m.lcRet
   endproc


   */--------------------------------------------------------------------------   
   function DecoratedDump( nFrom, nTo, lEcho ) as string
   */--------------------------------------------------------------------------
   *  Multiline dump(16 bytes per line) with address and ascii interpretation.
   *  Hexa relative address on the left of dump start at 0 for nFrom.
   *  Alpha interpretation is on the right side. 
   *  lEcho is optional, if .T. echoes a dot to screen each BUFSIZE characters.
   *  Remark : I found faster to write to a file and read it back at end
   *  than to depend on the VFP string memory management doing many 
   *  s = s + x when s becomes larger and larger (100K to 1000K)
      
      #define BUFSIZE  0x4000 && 16K
      local lnSavePos
      local lcBuff
      local lnLong
      local i
      local lh
      local k
      local b
      local lcAlpha
      local lnSize
      
      lnSavePos = this.nPosition
      this.nPosition = m.nFrom
      lnLong = m.nTo - m.nFrom + 1
      k = 0
      lcAlpha = ''
      lcTempFile = Addbs(Sys(2023))+Sys(3)
      lh = Fcreate( lcTempFile )

      do while m.lnLong > 0
         lcBuff = this.Read( Min( BUFSIZE, m.lnLong ) )
         if m.lEcho then
            ?? '.'
         endif   
         lnBuff = Len( m.lcBuff )
         lnLong = m.lnLong - m.lnBuff
         for i = 1 to m.lnBuff
            lcRet = ''
            if Mod( m.k, 16 ) = 0
               if m.k > 0 then
                  lcRet = m.lcRet + '   ' + m.lcAlpha + Chr(13) + Chr(10)
                  lcAlpha = ''
               endif
               lcRet = m.lcRet + cInt( m.k ) + '  '
            else
               if Mod( m.k, 8 ) = 0 then
                  lcRet = m.lcRet + '-'
               else
                  lcRet = m.lcRet + ' '
               endif
            endif
            b = Asc(Substr(m.lcBuff,m.i,1))
            lcRet = m.lcRet + cByte(m.b)
            lcAlpha = m.lcAlpha + cPrintable( m.b )
            k = m.k + 1
            Fwrite( lh, m.lcRet )
         endfor
      enddo
      lcRet = ''
      ln = Len( m.lcAlpha ) 
      if m.ln > 0 then
         if m.ln < 16 then
            lcRet = m.lcRet + Space( 3*(16 - m.ln) )
         endif
         lcRet = m.lcRet + '   ' + m.lcAlpha    
      endif
      if not Empty( m.lcRet )
         Fwrite( lh, m.lcRet )
      endif
      
      Fclose( m.lh )
      lh = Fopen( m.lcTempFile )
      lnSize = Fseek( m.lh, 0, FROM_END_OF_FILE ) + 1
      Fseek( m.lh, 0, FROM_BEGINNING_OF_FILE )
      lcRet = Fread( m.lh, m.lnSize )
      Fclose( m.lh )
      erase( m.lcTempFile )
      
      this.nPosition = m.lnSavePos
      
      return m.lcRet
      #undef BUFSIZE
   endproc

   */--------------------------------------------------------------------------   
   procedure Back( nByte as Integer )
   */--------------------------------------------------------------------------   
      this.nPosition = this.nPosition - m.nByte
   endproc


   */--------------------------------------------------------------------------   
   procedure PushBack( cBuf as string )
   */--------------------------------------------------------------------------
      if Type( "m.cBuf" ) <> "C" then
         *MessageBox( "must only push characters on stream" )
         error( "must only push back characters on stream" )
      endif   
      this.Buffer = m.cBuf + this.Buffer
   endproc

   
   */--------------------------------------------------------------------------   
   function LastByte() as integer
   */--------------------------------------------------------------------------   
      return this.nLastByte
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextByte() as integer
   */--------------------------------------------------------------------------   
      this.nLastByte = Asc( This.Read( 1 ) )
      return this.nLastByte
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextChar() as Character
   */--------------------------------------------------------------------------   
      return This.Read( 1 )
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextWord() as Integer
   */--------------------------------------------------------------------------
      local s, n
      s = this.Read(2)
      * ?? cByte(Asc(m.s))+cByte(Asc(Right(m.s,1)))+ " (" + Ltrim(Str(Len(m.s),6,0)) + ") "
      n = CToBin( m.s, "2R" ) + 32768
      return n
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextShort() as Integer
   */--------------------------------------------------------------------------
      return CToBin( this.Read(2), "2RS" )   
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextTriple() as Number 
   */--------------------------------------------------------------------------   
      local cBuf
      local nLoWord
      local nHiByte
      cBuf = this.Read( 3 )
      nLoWord = Bitlshift( Asc(Substr(m.cBuf,2) ), 8 ) + Asc(m.cBuf)
      nHiByte = Asc(Substr(m.cBuf,3))
      return m.nHiByte * 0x10000 + m.nLoWord
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextUInt() as Number 
   */--------------------------------------------------------------------------
      return 0x80000000 + CToBin( this.Read( 4 ), "4R" )
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextInt() as Number
   */--------------------------------------------------------------------------
      return CToBin( this.Read(4), "4RS" )   
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextCString() as String
   */--------------------------------------------------------------------------   
      * Peut être optimisé si besoin est
      local cS
      local b
      
      cS = ""
      b = this.NextByte()
      do while m.b <> 0
         cS = m.cS + Chr( m.b )
         b = this.NextByte() 
      enddo
      return m.cS
   endfunc

   
   */--------------------------------------------------------------------------   
   function NextPString() as String
   */--------------------------------------------------------------------------   
      return this.Read( this.NextWord() )
   endfunc


   */--------------------------------------------------------------------------
   function NextDouble() as Double
   */--------------------------------------------------------------------------
      return CToBin( this.Read(8), "BRS" )   
   endfunc


enddefine && CStream


*/=============================================================================
define class CBinaryFile as CStream
*/=============================================================================
*  Stream based on a file

   cName = ""
   lOpened = .F.
   nHandle = -1

   */--------------------------------------------------------------------------   
   procedure Init( cName as String )
   */--------------------------------------------------------------------------   
      with this
         .cName = m.cName
         .nHandle = -1
         .nPosition = -1
         .Open( m.cName )
         .lOpened = .T.
      endwith
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Destroy
   */--------------------------------------------------------------------------   
      this.Close()
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Close()
   */--------------------------------------------------------------------------   
     if this.nHandle >= 0 then
        Fclose( this.nHandle )
        this.nHandle = -1
        this.nPosition = -1
        this.Length = 0
     endif
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Open( cName as String )
   */--------------------------------------------------------------------------   
*!*         try
*!*            if this.nHandle >= 0 then
*!*               this.Close()
*!*            endif
*!*            this.nHandle = Fopen( m.cName, 0 ) && Read-Only buffered
*!*            if this.nHandle = -1
*!*               this.Length = 0
*!*               error "unable to open " + m.cName
*!*            else
*!*               this.Length = Fseek( this.nHandle, 0, FROM_END_OF_FILE )
*!*               = Fseek( this.nHandle, 0, FROM_BEGINNING_OF_FILE )
*!*            endif
*!*            this.nPosition = 0
*!*         catch
*!*            Fclose( this.nHandle )
*!*            this.nHandle = -1
*!*            error "unable to open " + m.cName
*!*         endtry
      try
         if this.Nhandle>=0
            this.Close()
         endif
         this.Nhandle = fOpen(m.Cname)
         if this.nHandle >= 0
            this.Length = Fseek( this.nHandle, 0, FROM_END_OF_FILE )
            = Fseek( this.nHandle, 0, FROM_BEGINNING_OF_FILE )
         endif
         this.Nposition = 0
      catch
         this.Nhandle = -1
      endtry
   endproc
   
   */--------------------------------------------------------------------------   
   function Read( nByte as Integer ) as String
   */--------------------------------------------------------------------------   
      local cBuf
      local lnByte
      lnByte = m.nByte
      cBuf = ''
      if Len( this.Buffer ) > 0 then
         if m.lnByte <= Len( this.Buffer ) then
            cBuf = Left( this.Buffer, m.lnByte )
            this.Buffer = Right( this.Buffer, Len( this.Buffer ) - m.lnByte )
            return m.cBuf
         else
            cBuf = this.Buffer
            lnByte = m.lnByte - Len( this.Buffer )
            this.Buffer = ''
         endif
      endif
      if this.nHandle >= 0 then
          cBuf = cBuf + Fread( this.nHandle, m.lnByte )
          this.nPosition = this.nPosition + m.lnByte
      endif
      if Len( m.cBuf ) < m.nByte
         error "Stream underflow error"
      endif   
      return m.cBuf
   endfunc
   
   */--------------------------------------------------------------------------   
   procedure nPosition_Assign( nValue as Integer )
   */--------------------------------------------------------------------------   
      if this.nHandle >= 0 then
         this.nPosition = Fseek( this.nHandle, m.nValue, FROM_BEGINNING_OF_FILE )
      endif
   endproc
   
enddefine && CBinaryFile


*/=============================================================================
define class CMemory as CStream
*/=============================================================================
*  In memory input stream
*  Data stream is defined with a string which can be very large. The order of
*  magnitude of file size (1Mb to 100Mb) is OK. 

   cMem = ''

   */--------------------------------------------------------------------------   
   procedure Init( cStmt as String )
   */--------------------------------------------------------------------------   
      with this
         .cMem = Iif( Empty(m.cStmt), '', m.cStmt)
         .Length = Len( .cMem )
         .nPosition = 0
      endwith
   endproc
   
   */--------------------------------------------------------------------------   
   function cMem_assign( cMem )
   */--------------------------------------------------------------------------   
      this.cMem = m.cMem
      this.Length = Len( this.cMem )
   endproc
   
   */--------------------------------------------------------------------------   
   procedure DeleteFirst( nBytes )
   */--------------------------------------------------------------------------   
      if m.nBytes <= Len( this.cMem ) then
         this.cMem = Right( this.cMem, Len( this.cMem ) - m.nBytes )
         this.nPosition = this.nPosition - m.nBytes
      endif   
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Assign( oMemStream as CStream )
   */--------------------------------------------------------------------------   
      with oMemStream
         this.cMem      = .cMem
         this.Length    = .Length
         this.nPosition = .nPosition
         this.nLastByte = .nLastByte
         this.Buffer    = .Buffer
      endwith
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Destroy
   */--------------------------------------------------------------------------   
      this.Close()
   endproc
   
   */--------------------------------------------------------------------------   
   procedure Close()
   */--------------------------------------------------------------------------   
     this.nPosition = -1
   endproc
   
   */--------------------------------------------------------------------------   
   function Read( nByte as Integer ) as String
   */--------------------------------------------------------------------------   
      local cBuf
      cBuf = ''
      if Len( this.Buffer ) > 0 then
         if m.nByte <= Len( this.Buffer ) then
            cBuf = Left( this.Buffer, m.nByte )
            this.Buffer = Right( this.Buffer, Len( this.Buffer ) - m.nByte )
            return m.cBuf
         else
            cBuf = this.Buffer
            nByte = m.nByte - Len( this.Buffer )
            this.Buffer = ''
         endif
      endif
      if this.nPosition + m.nByte > this.Length
         error "Stream overflow error"
      endif
      nByte = Min( this.Length - this.nPosition, m.nByte )
      cBuf = cBuf + Substr( this.cMem, this.nPosition + 1, m.nByte )
      this.nPosition = this.nPosition + m.nByte
      return m.cBuf
   endfunc
   
   */--------------------------------------------------------------------------   
   procedure nPosition_Assign( nValue as Integer )
   */--------------------------------------------------------------------------   
      this.nPosition = m.nValue
   endproc
   
   */--------------------------------------------------------------------------   
   function PlainDump( nFrom, nTo ) as string
   */--------------------------------------------------------------------------
      lnParam = Parameters()   
      if Empty( nFrom )
         nFRom = 0
      endif
      if m.lnParam < 2 then
         nTo = this.Length - 1
      endif      
      return DoDefault( nFrom, nTo )
   endproc

enddefine && CMemory

