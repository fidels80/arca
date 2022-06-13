*/* IsProcs

#include dfox.h

function isA( b, cText )
   if goStmt.LastByte() = m.b then
      if Empty( m.cText )
         goMemo.write( ' ' + cByte(m.b) )
      else
         goMemo.write( ' ' + m.cText )      
      endif   
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif
endfunc

function isActivate
   return isA( T_ACTIVATE, 'activate' )
endfunc

function isAdd
   return isA( T_ADD, 'add' )
endfunc

function isAdditive
   return isA( T_ADDITIVE, 'additive' )
endfunc

function isAfter
   return isA( T_AFTER, 'after' )
endfunc

function isAgain
   return isA( T_AGAIN, 'again' )
endfunc

function isAlias
   return isA( T_ALIAS, 'alias' )
endfunc

function isAll
   return isA( T_ALL, 'all' )
endfunc

function isAlt
   return isA( T_ALT, 'alt' )
endfunc

function isAlter
   return isA( T_ALTER, 'alter' )
endfunc

function isAlternate
   return isA( T_ALTERNATE, 'alternate' )
endfunc

function isApp
   return isA( T_APP, 'app' )
endfunc

function isArobas
   return isA( T_AROBAS, '@' )
endfunc

function isArray
   return isA( T_ARRAY, 'array' )
endfunc

function isAs
   return isA( T_AS, 'as' )
endfunc

function isAscending
   return isA( T_ASCENDING, 'ascending' )
endfunc

function isAscii
   return isA( T_ASCII, 'ascii' )
endfunc

function isAssign
   return isA( T_ASSIGN, '=' )
endfunc

function isAt
   return isA( T_AT, 'at' )
endfunc

function isAutoinc
   return isA( T_AUTOINC, 'autoinc' )
endfunc

function isAuto
   return isA( T_AUTO, 'auto' )
endfunc

function isAutomatic
   return isA( T_AUTOMATIC, 'automatic' )
endfunc

function isAvg
   return isA( T_AVG, 'avg' )
endfunc

function isBar
   return isA( T_BAR, 'bar' )
endfunc

function isBefore
   return isA( T_BEFORE, 'before' )
endfunc

function isBinary_
   return isA( T_BINARY, 'binary' )
endfunc

function isBitmap
   return isA( T_BITMAP, 'bitmap' )
endfunc

function isBlank_
   return isA( T_BLANK, 'blank' )
endfunc

function isBottom
   return isA( T_BOTTOM, 'bottom' )
endfunc

function isBrowseField()
   * Must be enhenced
   if isVariable()
      do while InList( goStmt.LastByte(), T_Colon, T_ColonB, T_ColonE, T_ColonF, T_ColonH, T_ColonP, T_ColonR, T_ColonW ) 
         = isColonR()
         = isColonP() and isAssign() and isExpressionGen()
         = isColonH() and isAssign() and isExpressionGen()
         = isColon()  and isExpressionGen()
         = isColonV() and isAssign() and isExpressionGen()
         = isColonF()
         = isColonE() and isAssign() and isExpressionGen()
         = isColonB() and isAssign() and isExpressionGen() and isVirgule() and isExpressionGen() and isColonF()
         = isColonW() and isAssign() and isExpressionGen()
      enddo
      return .T.
   else
      return .F.
   endif
endproc

function isBy
   return isA( T_BY, 'by' )
endfunc
   
function isCandidate
   return isA( T_CANDIDATE, 'candidate' )
endfunc
   
function isBox
   return isA( T_BOX, 'box' )
endfunc

function isCase
   return isA( T_CASE, 'case' )
endfunc

function isCenter
   return isA( T_CENTER, 'center' )
endfunc

function isCharacter
   return isA( T_CHARACTER_, 'character' )
endfunc

function isCheck
   return isA( T_CHECK, 'check' )
endfunc

function isClass
   return isA( T_CLASS, 'class' )
endfunc

function isClear
   return isA( T_CLEAR, 'clear' )
endfunc

function isClick
   return isA( T_CLICK, 'click' )
endfunc

function isClose
   return isA( T_CLOSE, 'close' )
endfunc
   
function isClasslib
   return isA( T_CLASSLIB, 'classlib' )
endfunc

function isCnt
   return isA( T_CNT, 'cnt' )
endfunc

function isCodepage
   return isA( T_CODEPAGE, 'codepage =' )
endfunc

function isCollate
   return isA( T_COLLATE, 'collate' )
endfunc

function isColon
   return isA( T_COLON, ':' )
endfunc

function isColonB
   return isA( T_COLONB, ':B' )
endfunc

function isColonE
   return isA( T_COLONE, ':E' )
endfunc

function isColonF
   return isA( T_COLONF, ':F' )
endfunc

function isColonH
   return isA( T_COLONH, ':H' )
endfunc

function isColonP
   return isA( T_COLONP, ':P' )
endfunc

function isColonR
   return isA( T_COLONR, ':R' )
endfunc

function isColonV
   return isA( T_COLONV, ':V' )
endfunc

function isColonW
   return isA( T_COLONW, ':W' )
endfunc

function isColor_
   return isA( T_COLOR, 'color' )
endfunc

function isColumn
   return isA( T_COLUMN, 'column' )
endfunc

function isCommand
   return isA( T_COMMAND, 'command' )
endfunc

function isCompact
   return isA( T_COMPACT, 'compact' )
endfunc

function isConnection
   return isA( T_CONNECTION, 'connection' )
endfunc

function isConnections
   return isA( T_CONNECTIONS, 'connections' )
endfunc

function isConnString
   return isA( T_CONNSTRING, 'ConnString' )
endfunc

function isControl
   return isA( T_CONTROL, 'control' )
endfunc

function isCursor
   return isA( T_CURSOR, 'cursor' )
endfunc

function isCsv
   return isA( T_CSV, 'csv' )
endfunc
   
function isCycle
   return isA( T_CYCLE, 'cycle' )
endfunc

function isData
   return isA( T_DATA, 'data' )
endfunc

function isDatabase
   return isA( T_DATABASE, 'database' )
endfunc

function isDatabases
   return isA( T_DATABASES, 'databases' )
endfunc

function isDatasource
   return isA( T_DATASOURCE, 'datasource' )
endfunc

function isDBF
   return isA( T_DBF, 'dbf' )
endfunc

function isDeactivate
   return isA( T_DEACTIVATE, 'deactivate' )
endfunc

function isDblClick
   return isA( T_DBLClick, 'dblClick' )
endfunc
   
function isDebug
   return isA( T_DEBUG, 'debug' )
endfunc

function isDebugger
   return isA( T_DEBUGGER, 'debugger' )
endfunc

function isDefault
   return isA( T_DEFAULT, 'default' )
endfunc
   
function isDelete
   return isA( T_DELETE, 'delete' )
endfunc
   
function isDeleteTables
   return isA( T_DELETETABLES, 'deleteTables' )
endfunc
   
function isDelimited
   return isA( T_DELIMITED, 'delimited' )
endfunc
   
function isDescending
   return isA( T_DESCENDING, 'descending' )
endfunc

function isDif
   return isA( T_DIF, 'dif' )
endfunc
   
function isDisable
   return isA( T_DISABLE, 'disable' )
endfunc
   
function isDistinct
   return isA( T_DISTINCT, 'distinct' )
endfunc
   
function isDll
   return isA( T_DLL, 'dll' )
endfunc

function isDlls
   return isA( T_DLLS, 'dlls' ) and goStmt.LastByte()=0x02 and goStmt.NextByte()<>0
endfunc

function isDouble
   return isA( T_DOUBLE_, 'double' )
endfunc
   
function isDos
   return isA( T_DOS, 'dos' )
endfunc
   
function isDrag
   return isA( T_DRAG, 'drag' )
endfunc
   
function isDrop
   return isA( T_DROP, 'drop' )
endfunc
   
function isEdit
   return isA( T_EDIT, 'edit' )
endfunc
   
function isEnable
   return isA( T_ENABLE, 'enable' )
endfunc
   
function isEncrypt
   return isA( T_ENCRYPT, 'encrypt' )
endfunc
   
function isEnvironment
   return isA( T_ENVIRONMENT, 'environment' )
endfunc
   
function isError
   return isA( T_ERROR, 'error' )
endfunc
   
function isEscape
   return isA( T_ESCAPE, 'escape' )
endfunc
   
function isEvents
   return isA( T_EVENTS, 'events' )
endfunc

function isExcept
   return isA( T_EXCEPT, 'except' )
endfunc

function isExe
   return isA( T_EXE, 'exe' )
endfunc

function isExclude
   return isA( T_EXCLUDE , 'exclude' )
endfunc

function isExclusive_
   return isA( T_EXCLUSIVE , 'exclusive' )
endfunc

function isExpression( llStick )
   if Expression( goStmt.LastByte(), m.llstick ) then
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isExpressionGen( llStick )
   if ExpressionGenerale( goStmt.LastByte(), m.llStick ) then
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isLiteralOrExpression( llStick )
   if LiteralOrExpression( goStmt.LastByte() ) then
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isExpressionGenList
   return isList( 'isExpressionGen()' )
endfunc

function isExpressionStr
   if ExpressionGenerale( goStmt.LastByte() )
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif
endfunc

function isExpressionStrList
   return isList( 'isExpressionStr()' )
endfunc

function isExtended
   return isA( T_EXTENDED, 'extended' )
endfunc

function isFieldList
   return isList( 'isBrowseField()', .T.)
endfunc

function isField
   return isA( T_FIELD, 'field' )
endfunc

function isFields
   return isA( T_FIELDS, 'fields' )
endfunc

function isFile
   return isA( T_FILE, 'file' )
endfunc

function isFiles
   return isA( T_FILES, 'files' )
endfunc

function isFill
   return isA( T_FILL, 'fill' )
endfunc

function isFloat
   return isA( T_FLOAT, 'float' )
endfunc

function isFont
   return isA( T_FONT, 'font' )
endfunc

function isFooter
   return isA( T_FOOTER, 'footer' )
endfunc
   
function isFor
   return isA( T_FOR, 'for' )
endfunc
   
function isForce
   return isA( T_FORCE, 'force' )
endfunc
   
function isForeign
   return isA( T_FOREIGN, 'foreign' )
endfunc
   
function isForm
   return isA( T_FORM, 'form' )
endfunc
   
function isFormC
   return isA( T_FORM_C, 'form' )
endfunc
   
function isFormScreen
   return isA( T_FORMSCREEN, 'form' )
endfunc
   
function isFormat
   return isA( T_FORMAT, 'format' )
endfunc
   
function isFox2x
   return isA( T_FOX2X, 'fox2x' )
endfunc
   
function isFoxObject
   return isA( T_FOXOBJECT, 'FoxObject' )
endfunc

function isFoxPlus
   return isA( T_FOXPLUS, 'foxplus' )
endfunc
   
function isFree
   return isA( T_FREE, 'free' )
endfunc
   
function isFreeze
   return isA( T_FREEZE, 'freeze' )
endfunc
   
function isFrom
   return isA( T_FROM, 'from' )
endfunc
   
function isFull
   return isA( T_FULL, 'full' )
endfunc

function isFunction
   return isA( T_FUNCTION, 'function' )
endfunc
   
function isFw2
   return isA( T_FW2, 'fw2' )
endfunc
   
function isGeneral
   return isA( T_GENERAL_, 'general' )
endfunc
   
function isGet
   return isA( T_GET, 'get' )
endfunc
   
function isGets
   return isA( T_GETS, 'gets' )
endfunc
   
function isGroup_by
   return isA( T_GROUP_BY, 'group by' )
endfunc
   
function isGrow
   return isA( T_GROW, 'grow' )
endfunc

function isHalfHeigh
   return isA( T_HALFHEIGH, 'halfheigh' )
endfunc
   
function isHaving
   return isA( T_HAVING, 'having' )
endfunc
   
function isHeading
   return isA( T_HEADING, 'heading' )
endfunc
   
function isIcon
   return isA( T_ICON, 'icon' )
endfunc

function isIn
   return isA( T_IN, 'in' )
endfunc

function isKey
   return isA( T_KEY, 'key' )
endfunc

function isIndex
   return isA( T_INDEX, 'index' )
endfunc

function isIndexes
   return isA( T_INDEXES, 'indexes' )
endfunc

function isInner
   return isA( T_INNER, 'inner' )
endfunc

function isInsert
   return isA( T_INSERT, 'insert' )
endfunc

function isInteger
   return isA( T_INTEGER_, 'integer' )
endfunc

function isInto
   return isA( T_INTO, 'into' )
endfunc

function isInvert
   return isA( T_INVERT, 'invert' )
endfunc

function isIsometric
   return isA( T_ISOMETRIC, 'isometric' )
endfunc

function isJoin
   return isA( T_JOIN, 'join' )
endfunc

function isLabel
   return isA( T_LABEL, 'label' )
endfunc

function isLEdit
   return isA( T_LEDIT, 'LEdit' )
endfunc

function isLeft
   return isA( T_LEFT, 'left' )
endfunc

function isLeftPar
   return isA( T_LEFTPAR, '(' )
endfunc

function isLevel
   return isA( T_LEVEL, 'level' )
endfunc

function isLibrary
   return isA( T_LIBRARY, 'library' )
endfunc

function isLike
   return isA( T_LIKE, 'like' )
endfunc

function isLine
   return isA( T_LINE, 'line' )
endfunc

function isLink
   return isA( T_LINK, 'link' )
endfunc

function isLinked
   return isA( T_LINKED, 'linked' )
endfunc

function isList( cBoolExpr, lNewline )
   local ret
   goMemo.Indent(+2)
   NewlineIf( m.lNewline )
   if Evaluate( m.cBoolExpr )
      do while isVirgule()
         NewlineIf( m.lNewline )
         Evaluate( m.cBoolExpr )
      enddo
      ret = .T.
   else
      ret = .F.
   endif
   goMemo.Indent(-2)
   return m.ret   
endfunc

function isLiteral
   if LiteralOrExpression( goStmt.LastByte() ) then
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isLiteralOrExpression
   return isLiteral()
endfunc

function isLock
   return isA( T_LOCK, 'lock' )
endfunc

function isLong
   return isA( T_LONG, 'long' )
endfunc

function isLPartition
   return isA( T_LPartition, 'LPartition' )
endfunc

function isLTRJustify
   return isA( T_LTRJUSTIFY, "LTRJustify" )
endfunc

function isLValue()
   if NextVar( goStmt.LastByte() ) then
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isMacro
   return isA( T_MACRO, 'macro' )
endfunc
   
function isMacros
   return isA( T_MACROS, 'macros' )
endfunc
   
function isMargin
   return isA( T_MARGIN, 'margin' )
endfunc

function isMark
   return isA( T_MARK, 'mark' )
endfunc

function isMask
   return isExpressionGen()
endfunc

function isMaster
   return isA( T_MASTER , 'master' )
endfunc

function isMax
   return isA( T_MAX, 'max' )
endfunc

function isMDI
   return isA( T_MDI, 'mdi' )
endfunc

function isMemo_
   return isA( T_MEMO_, 'memo' )
endfunc
   
function isMemory
   return isA( T_MEMORY, 'memory' )
endfunc
   
function isMemvar
   return isA( T_MEMVAR, 'memvar' )
endfunc
   
function isMenu
   return isA( T_MENU, 'menu' )
endfunc

function isMenus
   return isA( T_MENUS, 'menus' )
endfunc

function isMessage
   return isA( T_MESSAGE, 'message' )
endfunc
   
function isMin
   return isA( T_MIN, 'min' )
endfunc

function isMiddle
   return isA( T_MIDDLE, 'middle' )
endfunc

function isMinimize
   return isA( T_MINIMIZE, 'minimize' )
endfunc

function isMod
   return isA( T_MOD, 'mod' )
endfunc
   
function isModal
   return isA( T_MODAL, 'modal' )
endfunc
   
function isMRU
   return isA( T_MRU, 'MRU' )
endfunc
   
function isMtDll
   return isA( T_MTDLL, 'mtdll' )
endfunc
   
function isName
   return isA( T_NAME, 'name' )
endfunc
   
function isNegotiate
   return isA( T_NEGOTIATE, 'negotiate' )
endfunc
   
function isNegotiateList
   return isList( 'isNegoValue()' )
endfunc
   
function isNegoValue
   if isLeft() or isRight() or isNone() or isMiddle() then
      return .T.
   else
      return .F.
   endif
endfunc
   
function isNext
   return isA( T_NEXT, 'next' )
endfunc
   
function isNextText
   if goStmt.LastByte() = 0xFB then
      goMemo.Write( goStmt.NextPString() )
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif    
endfunc

function isNextvalue
   return isA( T_NEXTVALUE, 'nextvalue' )
endfunc

function isNoAppend
   return isA( T_NOAPPEND, 'noAppend' )
endfunc

function isNoCaptions
   return isA( T_NOCAPTIONS, 'noCaptions' )
endfunc

function isNoClear
   return isA( T_NOCLEAR, 'noClear' )
endfunc

function isNoClose
   return isA( T_NOCLOSE, 'noClose' )
endfunc

function isNoConsole
   return isA( T_NOCONSOLE, 'noconsole' )
endfunc

function isNoCpTrans
   return isA( T_NOCPTRANS, 'noCpTrans' )
endfunc

function isNoDebug
   return isA( T_NODEBUG, 'noDebug' )
endfunc

function isNoDelete
   return isA( T_NODELETE, 'noDelete' )
endfunc

function isNoDialog
   return isA( T_NODIALOG, 'noDialog' )
endfunc

function isNoEdit
   return isA( T_NOEDIT, 'noEdit' )
endfunc

function isNoEject
   return isA( T_NOEJECT, 'noEject' )
endfunc

function isNoFloat
   return isA( T_NOFLOAT, 'noFloat' )
endfunc

function isNoGrow
   return isA( T_NOGROW, 'noGrow' )
endfunc

function isNoInit
   return isA( T_NOINIT, 'noInit' )
endfunc

function isNoLGrid
   return isA( T_NOLGRID, 'noLGrid' )
endfunc

function isNoLink
   return isA( T_NOLINK, 'noLink' )
endfunc

function isNoMDI
   return isA( T_NOMDI, 'noMdi' )
endfunc

function isNoMinimize
   return isA( T_NOMINIMIZE, 'noMinimize' )
endfunc

function isNoMenu
   return isA( T_NOMENU, 'noMenu' )
endfunc

function isNomodify
   return isA( T_NOMODIFY, 'noModify' )
endfunc

function isNomouse
   return isA( T_NOMOUSE, 'noMouse' )
endfunc

function isNoReset
   return isA( T_NORESET, 'noReset' )
endfunc

function isNone
   return isA( T_NONE, 'none' )
endfunc

function isNoOptimize
   return isA( T_NOOPTIMIZE, 'noOptimize' )
endfunc

function isNoPageEject
   return isA( T_NOPAGEEJECT, 'noPageEject' )
endfunc

function isNoProjectHook
   return isA( T_NOPROJECTHOOK, 'noProjectHook' )
endfunc

function isNoOverwrite
   return isA( T_NOOVERWRITE, 'noOverwrite' )
endfunc

function isNoRead
   return isA( T_NOREAD, 'noRead' )
endfunc

function isNoRefresh
   return isA( T_NOREFRESH, 'noRefresh' )
endfunc

function isNoRGrid
   return isA( T_NORGRID, 'noRGrid' )
endfunc

function isNorm
   return isA( T_NORM, 'norm' )
endfunc

function isNormal
   return isA( T_NORMAL, 'normal' )
endfunc

function isNoSave
   return isA( T_NOSAVE, 'noSave' )
endfunc

function isNoShow
   return isA( T_NOSHOW, 'noShow' )
endfunc

function isNot
   return isA( T_NOT, 'not' )
endfunc

function isNoUpdate
   return isA( T_NOUPDATE , 'noUpdate' )
endfunc

function isNoWait
   return isA( T_NOWAIT, 'noWait' )
endfunc

function isNozoom
   return isA( T_NOZOOM, 'noZoom' )
endfunc
   
function isNPV
   return isA( T_NPV, 'NPV' )
endfunc

function isNull_
   return isA( T_NULL, 'null' )
endfunc

function isNumber_
   return isA( T_NUMBER_, 'number' )
endfunc

function isObject
   return isA( T_OBJECT_, 'object' )
endfunc

function isObjects
   return isA( T_OBJECTS, 'objects' )
endfunc

function isOf
   return isA( T_OF, 'of' )
endfunc

function isOff
   return isA( T_OFF, 'off' )
endfunc

function isOn
   return isA( T_ON, 'on' )
endfunc

function isOnly
   return isA( T_ONLY, 'only' )
endfunc

function isOpen
   return isA( T_OPEN, 'open' )
endfunc
   
function isOrder_By
   return isA( T_ORDER_BY, 'order by' )
endfunc
   
function isOrder_Tag
   return isA( T_ORDER_TAG, 'order' )
endfunc

function isOverwrite
   return isA( T_OVERWRITE, 'overwrite' )
endfunc

function isPad
   return isA( T_PAD , 'pad' )
endfunc

function isPage
   return isA( T_PAGE , 'page' )
endfunc

function isPanel
   return isA( T_PANEL, 'panel' )
endfunc

function isPartition
   return isA( T_PARTITION, 'partition' )
endfunc
   
function isPassword
   return isA( T_PASSWORD, 'password' )
endfunc
   
function isPattern
   return isA( T_PATTERN, 'pattern' )
endfunc
   
function isPdox
   return isA( T_PDOX, 'pdox' )
endfunc
   
function isPdsetup
   return isA( T_PDSETUP, 'pdsetup' )
endfunc
   
function isPen_ && isPen is a foxpro function
   return isA( T_PEN, 'pen' )
endfunc

function isPercent
   return isA( T_PERCENT, 'percent' )
endfunc
   
function isPictRes
   return isA( T_PICTRES, 'PictRes' )
endfunc
   
function isPicture
   return isA( T_PICTURE, 'picture' )
endfunc
   
function isPixels
   return isA( T_PIXELS, 'pixels' )
endfunc
   
function isPlain
   return isA( T_PLAIN, 'plain' )
endfunc

function isPopup
   return isA( T_POPUP, 'popup' )
endfunc
   
function isPopups
   return isA( T_POPUPS, 'popups' )
endfunc

function isPosition
   return isA( T_POSITION, 'position' )
endfunc

function isPreference
   return isA( T_PREFERENCE, 'preference' )
endfunc
   
function isPreview
   return isA( T_PREVIEW, 'preview' )
endfunc
   
function isPrimary
   return isA( T_PRIMARY, 'primary' )
endfunc

function isPrint
   return isA( T_PRINT, 'print' )
endfunc

function isPrinter
   return isA( T_PRINTER, 'printer' )
endfunc

function isProcedure
   return isA( T_PROCEDURE, 'procedure' )
endfunc

function isProcedures
   return isA( T_PROCEDURES, 'procedures' )
endfunc

function isProduction
   return isA( T_PRODUCTION, 'with production' )
endfunc
   
function isProgram
   return isA( T_PROGRAM, 'program' )
endfunc
   
function isProject
   return isA( T_PROJECT, 'project' )
endfunc
   
function isPrompt
   return isA( T_PROMPT, 'prompt' )
endfunc
   
function isProtected
   return isA( T_PROTECTED, 'protected' )
endfunc
   
function isQuery
   return isA( T_QUERY, 'query' )
endfunc

function isQuestionMark
   return isA( T_QUESTIONMARK, '?' )
endfunc

function isRandom
   return isA( T_RANDOM, 'random' )
endfunc

function isRange
   return isA( T_RANGE, 'range' )
endfunc

function isRead_
   return isA( T_READ, 'read' )
endfunc
   
function isRecompile
   return isA( T_RECOMPILE, 'recompile' )
endfunc
   
function isRecover
   return isA( T_RECOVER, 'recover' )
endfunc
   
function isRecord
   return isA( T_RECORD, 'record' )
endfunc
   
function isREdit
   return isA( T_REDIT, 'REdit' )
endfunc

function isRecycle
   return isA( T_RECYCLE, 'recycle' )
endfunc
   
function isReferences
   return isA( T_REFERENCES, 'references' )
endfunc
   
function isRefresh
   return isA( T_REFRESH, 'refresh' )
endfunc
   
function isRelation
   return isA( T_RELATION, 'relation' )
endfunc
   
function isRelative
   return isA( T_RELATIVE, 'relative' )
endfunc
   
function isRemote
   return isA( T_REMOTE, 'remote' )
endfunc

function isRename
   return isA( T_RENAME, 'rename' )
endfunc

function isReplace
   return isA( T_REPLACE, 'replace' )
endfunc

function isReport
   return isA( T_REPORT, 'report' )
endfunc

function isResources
   return isA( T_RESOURCES, 'resources' )
endfunc
   
function isRest
   return isA( T_REST, 'rest' )
endfunc

function isRgb
   return isA( T_RGB, 'rgb' )
endfunc

function isRight
   return isA( T_RIGHT, 'right' )
endfunc

function isRightPar
   return isA( T_RIGHTPAR, ')' )
endfunc

function isRTLJustify
   return isA( T_RTLJUSTIFY, "RTLJustify" )
endfunc

function isRpd
   return isA( T_RPD, 'rpd' )
endfunc
   
function isSame
   return isA( T_SAME, 'same' )
endfunc

function isSave
   return isA( T_SAVE, 'save' )
endfunc

function isSay
   return isA( T_SAY, 'say' )
endfunc
   
function isSelect
   return isA( T_SELECT, 'select' )
endfunc

function isSelection
   return isA( T_SELECTION, 'selection' )
endfunc

function isScroll
   return isA( T_SCROLL, 'scroll' )
endfunc

function isScheme
   return isA( T_SCHEME, 'scheme' )
endfunc

function isScreen
   return isA( T_SCREEN_, 'screen' )
endfunc

function isSdf
   return isA( T_SDF, 'sdf' )
endfunc
   
function isSet
   return isA( T_SET, 'set' )
endfunc
   
function isShadow
   return isA( T_SHADOW, 'shadow' )
endfunc
   
function isShare
   return isA( T_SHARE, 'share' )
endfunc
   
function isShared
   return isA( T_SHARED, 'shared' )
endfunc
   
function isSheet
   return isA( T_SHEET, 'sheet' )
endfunc
   
function isShift
   return isA( T_SHIFT, 'shift' )
endfunc
   
function isShort
   return isA( T_SHORT, 'short' )
endfunc
   
function isShortcut
   return isA( T_SHORTCUT, 'shortcut' )
endfunc
   
function isShow
   return isA( T_SHOW, 'show' )
endfunc
   
function isShutdown
   return isA( T_SHUTDOWN, 'shutdown' )
endfunc
   
function isSingle
   return isA( T_SINGLE, 'single' )
endfunc
   
function isSize
   return isA( T_SIZE, 'size' )
endfunc
   
function isSkip
   return isA( T_SKIP, 'skip' )
endfunc
   
function isSpinner
   return isA( T_SPINNER, 'spinner' )
endfunc
   
function isSql_View
   return isA( T_VIEW, 'sql view' )
endfunc
   
function isStar
   return isA( T_STAR, '*' )
endfunc
   
function isStatus
   return isA( T_STATUS, 'status' )
endfunc
   
function isStd
   return isA( T_STD, 'StD' )
endfunc

function isStep
   return isA( T_STEP, 'step' )
endfunc
   
function isStretch
   return isA( T_STRETCH, 'stretch' )
endfunc

function isString
   
   return isA( T_STRING, 'string' )
endfunc

function isStringLiteral
   goMemo.write( ' ' + goStmt.NextPString() )
   goStmt.NextByte()
endfunc

function isStringInStringList
   return isList( 'isExpressionStr() and isIn() and isExpressionGen()' ) 
endfunc

function isStructure
   return isA( T_STRUCTURE, 'structure' )
endfunc
   
function isStyle
   return isA( T_STYLE, 'style' )
endfunc
   
function isSum
   return isA( T_SUM, 'Sum' )
endfunc

function isSummary
   return isA( T_SUMMARY, 'Summary' )
endfunc

function isSylk
   return isA( T_SYLK, 'sylk' )
endfunc
   
function isSystem
   return isA( T_SYSTEM, 'system' )
endfunc

function isTable
   return isA( T_TABLE, 'table' )
endfunc

function isTables
   return isA( T_TABLES, 'tables' )
endfunc

function isTab
   return isA( T_TAB, 'tab' )
endfunc

function isTag
   return isA( T_TAG, 'tag' )
endfunc

function isTime
   return isA( T_TIME, 'time' )
endfunc

function isTimeout
   return isA( T_TIMEOUT, 'timeout' )
endfunc

function isTo
   return isA( T_TO, 'to' )
endfunc
   
function isTitle
   return isA( T_TITLE, 'title' )
endfunc
   
function isTop
   return isA( T_TOP, 'top' )
endfunc
   
function isTransaction
   return isA( T_TRANSACTION, 'transaction' )
endfunc
   
function isType
   return isA( T_TYPE, 'type' )
endfunc
   
function isTrigger
   return isA( T_TRIGGER, 'trigger' )
endfunc
   
function isTypeahead
   return isA( T_TYPEAHEAD, 'typeahead' )
endfunc
   
function isUnique
   return isA( T_UNIQUE, 'unique' )
endfunc
   
function isUnion
   return isA( T_UNION, 'union' )
endfunc
   
function isUpdate
   return isA( T_UPDATE, 'update' )
endfunc
   
function isUserID
   return isA( T_USERID, 'userid' )
endfunc
   
function isValid
   return isA( T_VALID, 'valid' )
endfunc
   
function isValidate
   return isA( T_VALIDATE, 'validate' )
endfunc
   
function isValues
   return isA( T_VALUES, 'values' )
endfunc
   
function isVAR
   return isA( T_VAR_, 'VAR' )
endfunc

function isVariable
   local w
   if NextVar( goStmt.LastByte(), .T. )
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif   
endfunc

function isVariableDeclaration
   if isVariable()
      = isAs() and isLiteral()
      return .T.
   else
      return .F.
   endif   
endfunc

function isVariableDeclarationList
   return isList( 'isVariableDeclaration()' )
endfunc

function isVariableList
   return isList( 'isVariable()' )
endfunc

function isVerb
   return isA( T_VERB, 'verb' )
endfunc

function isView
   return isA( T_VIEW, 'view' )
endfunc
   
function isViews
   return isA( T_VIEWS, 'views' )
endfunc
   
function isView_C
   return isA( T_VIEW_C, 'view' )
endfunc
   
function isVirgule
   * Like IsA but without leading space
   if goStmt.LastByte() = T_VIRGULE then
      goMemo.write( ',' )
      goStmt.NextByte()
      return .T.
   else
      return .F.
   endif
endfunc

function isWhere
   return isA( T_WHERE, 'where' )
endfunc

function isWidth
   return isA( T_WIDTH, 'width' )
endfunc

function isWindow
   return isA( T_WINDOW, 'window' )
endfunc

function isWindows
   return isA( T_WINDOWS, 'windows' )
endfunc

function isWhen
   return isA( T_WHEN, 'when' )
endfunc
   
function isWhile
   return isA( T_WHILE, 'while' )
endfunc
   
function isWith
   return isA( T_WITH, 'with' )
endfunc

function isWithBuffering
   return isA( T_WITH_BUFF, 'with ( buffering = ' )
endfunc
   
function isWk1
   return isA( T_WK1, 'wk1' )
endfunc
   
function isWk3
   return isA( T_WK3, 'wk3' )
endfunc
   
function isWks
   return isA( T_WKS, 'wks' )
endfunc
   
function isWr1
   return isA( T_WR1, 'wr1' )
endfunc
   
function isWrap
   return isA( T_WRAP, 'wrap' )
endfunc
   
function isWrk
   return isA( T_WRK, 'wrk' )
endfunc
   
function isXl5
   return isA( T_XL5, 'xl5' )
endfunc
   
function isXl8
   return isA( T_XL8, 'xl8' )
endfunc
   
function isXls
   return isA( T_XLS, 'xls' )
endfunc
   
function isZoom
   return isA( T_ZOOM, 'zoom' )
endfunc
   
procedure NewlineIf( lNewline as Boolean )
   if m.lNewline then
      goMemo.Write(' ;')
      goMemo.Ln()
   endif
endproc




