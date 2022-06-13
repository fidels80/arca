*/* Statements

#include dfox.h

procedure Accept_stmt
   = isExpressionGen()
   = isTo() and isVariable()
endproc

procedure Activate_stmt
   do case
      case isWindow()
         = isBottom() or isTop() or isSame()
         = isNoShow()
         = isIn() and isVariable()
         = isExpressionGenList()
      case isScreen()
      case isPopup() and isExpressionGen()
         = isBar() and isExpressionGen()
         = isNoWait()
         = isAt() and isExpressionGen() and isVirgule() and isExpressionGen()
         = isRest()  
      case isMenu() and isExpressionGen()
         = isPad() and isExpressionGen()
         = isNoWait()
   endcase
endproc

procedure Add_stmt
   do case
      case isTable()
         = isExpressionGen()
         = isName() and isExpressionGen()
      case isClass()
         = isExpressionGen() and isOf() and isExpressionGen()
         = isTo() and isExpressionGen()
         = isOverwrite()
      case isObject()
         = isObject()
         = isProtected()
         = isExpressionGen()
         = isAs() and isExpressionGen()
         = isNoInit()
         = isWith() and isList('isVariable() and isAssign() and isExpressionGen()')
   endcase
endproc

procedure AlterSQL_stmt
   = isTable() and isExpressionGen()
   do case
      case isAdd()
         = isColumn()
         = isFieldDef()
      case isAlter()
         = isColumn()
         = isFieldDef()
      case isDrop()
         = isForeign() and isKey() and isTag() and isVariable()
         = isColumn() and isFieldDef()
      case isRename()
         = isVariable() and isTo() and isVariable()
   endcase
endproc

procedure Append_stmt
   do case
      case isFrom()
         do case
            case isArray() and isExpressionGen()
               = isFor() and isExpressionGen()
               if isFields()
                  = ( (isLike() or isExcept()) and isExpressionGen() ) or isExpressionGenList()
               endif
            case isExpressionGen()
               = isFor() and isExpressionGen()
               = isOverwrite()
               if isFields()
                  = ( (isLike() or isExcept()) and isExpressionGen() ) or isExpressionGenList()
               endif
               = isType()
               if isDelimited()
                  = isWith() and isCharacter() and ( isTab() or IsBlank_() or isExpressionGen() ) 
               endif
               = isDif() or isFw2() or isMod() or isPdox() or isRpd() or isSdf() or isSylk() or;
                 isWk1() or isWk3() or isWks() or isWr1() or isWrk() or isCsv() or isXls() or;
                 ( ( isXl5() or isXl8() ) and isSheet() and isExpressionGen() ) 
               = isAs() and isExpressionGen()
         endcase
      case isGeneral() and isExpressionGen()
         = isFrom() and isExpressionGen()
         = isLink()
         = isClass() and isExpressionGen()
         = isData() and isExpressionGen()
      case isMemo_() and isExpressionGen() and isFrom() and isExpressionGen()
         = isOverwrite()
         = isAs() and isExpressionGen()
      case isProcedures() and isFrom() and isExpressionGen() 
         = isOverwrite()
         = isAs() and isExpressionGen()
      otherwise
         = isIn() and isExpressionGen()
         = IsBlank_()
         = isNoMenu()      
   endcase
endproc

function isColorStuf
   if IsColor_()
      do case
         case isScheme() and isExpressionGen()
            = isVirgule() and isExpressionGen()
         case isRgbRgb() or isExpressionGen()
            do while isVirGule()
               = isRgbRgb() or isExpressionGen()
            enddo
         case isVirgule()
            = isRgbRgb() or isExpressionGen()   
            do while isVirGule()
               = isRgbRgb() or isExpressionGen()
            enddo
      endcase   
      return .T.
   else
      return .F.   
   endif
endfunc

function isRgbRgb
   local ln
   if isRgb()
      goMemo.write( '(' )
      = isExpressionGen()
      for ln = 1 to 5
         = isVirgule()
         = isExpressionGen()
      endfor
      goMemo.write( ' )' )
      return .T.
   else    
      return .F.
   endif   
endfunc

procedure Arobas_stmt
   local lc1, lc2, lc3
   store '' to lc1, lc2, lc3
   = isExpressionGen() and isVirgule() and isExpressionGen()
   = isEdit() and isExpressionGen()
   = isDefault() and isExpressionGen()
   lc1 = goMemo.Harvest()
   = isColorStuf()
   lc2 = goMemo.Harvest()
   = isSay() and isExpression()
   if isGet() and isVariable() then
      = isDefault() and isExpressionGen()
   endif
   do case
      case isClear() or isFill()
         = isTo()
         = isExpressionGen() and isVirgule() and isExpressionGen()
      case isTo() and isExpressionGen() and isVirgule() and isExpressionGen()
         = isStyle() and isExpressionGen()
         = isPattern() and isExpressionGen()
         = isPen_() and isExpressionGen() and isVirgule() and isExpressionGen()
         = isDouble()
      case isVirgule() and isExpressionGen() and isVirgule() and isExpressionGen()
         = isBox() and isExpressionGen()
      case isPrompt() and isExpressionGen()
      case isMenu() and isExpressionGen()
         = isVirgule() and isExpressionGen() and isVirgule() and isExpressionGen()
         = isTitle() and isExpressionGen()
         = isShadow()
   endcase
   = ( isFont() and isExpressionGen() and isVirgule() and isExpressionGen() ) or isBitMap()
   = isStyle() and isExpressionGen()
   = isSize() and isExpressionGen() and isVirgule() and isExpressionGen() and isVirgule() and isExpressionGen()
   = isFrom() and isExpressionGen()
   = isPopup() and isExpressionGen()
   = isRange() and isExpressionGen() and isVirgule() and isExpressionGen()
   = isIsometric() or isStretch()
   = isCenter()
   = isVerb() and isExpressionGen() 
   = isFunction() and isExpressionGen()
   = isPicture() and isExpressionGen() 
   = isEnable() or isDisable()
   = isSpinner() and isExpressionGen() and isVirgule() and isExpressionGen() and isVirgule() and isExpressionGen() 
   = isScroll()
   = isTab()
   = isNomodify()
   = isValid() and isExpressionGen()
   = isWhen() and isExpressionGen()
   = isMessage() and isExpressionGen()
   = isError() and isExpressionGen()
   = isOpen()
   = isWindow() and isExpressionGen()
   lc3 = goMemo.Harvest()
   goMemo.cTxt = m.lc1 + m.lc3 + m.lc2
endproc

procedure Assert_stmt
   = isExpressionGen() and isMessage() and isExpressionGen()
endproc

procedure Assign_stmt
   = isLValue() and isAssign() and isExpressionGen()
endproc

procedure Blank_stmt
   = isIn() and isExpressionGen()
   = isFields() and isExpressionGenList()
   = isNoOptimize()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
   = isDefault()
   = isAutoInc()
endproc

procedure Browse_stmt
   = isPreference() and isExpressionGen()
   = isNoCaptions()
   = isNoInit()
   = isNoOptimize()
   = isRest()
   = isFor() and isExpressionGen()
   = isFields() and isFieldList()  
   = isFont() and isExpressionGenList()
   = isStyle() and isExpressionGen()
   = isLock() and isExpressionGen()
   = isFreeze() and isExpressionGen()
   = isNoMenu()
   = isNoAppend()
   = isWidth() and isExpressionGen()
   = isNoModify()
   = isNoDelete()
   = isFormat()
   = isWindow() and isExpressionGen()
   = isNoWait()
   = isSave()
   if IsColor_()
      = isScheme()
      = isExpressionGen()
   endif
   = isNormal()
   = isKey() and isExpressionGenList()
   = isTitle() and isExpressionGen()   
   = isTimeOut() and isExpressionGen()
   = isIn() and isExpressionGen()
   = isNoLink()
   = isNoLGrid()
   = isNoRGrid()
   = isLEdit()
   = isREdit()
   = isPartition() and isExpressionGen()
   = isLPartition()
   = isWhen() and isExpressionGen()
   if isValid() then
      = isColonF()
      = isExpressionGen()
      = isError() and isExpressionGen()
   endif   
   = isNoRefresh()
   = isName() and isExpressionGen()
endproc

procedure Build_stmt
   do case
      case isApp() or isDll() or isExe() or isMtdll()
         = isExpressionGen() and isFrom() and isExpressionGen()
      case isProject()
         = isExpressionGen() 
         = isRecompile()
         = isFrom() and isExpressionGenList()
   endcase
endproc

procedure Calculate_stmt
   local lc1, lc2,lc3
   store '' to lc1, lc2, lc3
   = isIn() and isExpressionGen()
   lc1 = goMemo.Harvest()
   = isNoOptimize()
   lc2 = goMemo.Harvest()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
   = isTo() and ( ( isArray() and isVariable() ) or isVariableList() )
   = isCalculateFctList()
   lc3 = goMemo.Harvest()
   goMemo.cTxt = m.lc1 + m.lc3 + m.lc2
endproc

procedure Call_stmt
   = isExpressionGen()
   = isSave() or isNoSAve()
   = isWith() and isExpressionGen()
endproc

function isCalculateFct
   local llRet
   llRet = .T.
   do case
      case isAvg() or isMin() or isMax() or isCnt() or isSum() or isStD() or isVAR()
         llRet = isLeftPar() and isExpressionGen() and isRightPar()
      case isNPV()
         llRet = isLeftPar() and isExpressionGen() and isVirgule() and ;
                 isExpressionGen()
         if isVirgule()
            = isExpressionGen()
         endif
         = isRightPar()          
      otherwise
         llRet = .F. 
   endcase
   return m.llRet
endfunc

function isCalculateFctList
   return isList( 'isCalculateFct()' )
endfunc

procedure Catch_stmt
   =isTo() and isVariable()
   =isWhen() and isExpressionGen()
   =reste(.F.)
endproc

procedure Clear_stmt
   do case
      case isAll()
      case isClass() and isExpressionGen()
      case isClassLib() and isLiteral()
      case isDebug()
      case isDlls() and isExpressionGenList()
      case isEvents()
      case isFields()
      case isGets()
      case isMacros()
      case isMemory()
      case isMenus()
      case isPopups()
      case isProgram()
      case isPrompt()
      case IsRead_() and isAll()
      case isResources() and isLiteral()
      case isTypeahead()
      case isWindows() 
   endcase
endproc

procedure Close_Stmt
   do case
      case isAll()
      case isAlternate()
      case isDatabases() and isAll()
      case isDebugger()
      case isFormat()
      case isIndexes()
      case isProcedures()
      case isTables() and isAll()
   endcase
endproc

procedure CodeExpression_stmt( lStick as Boolean )
   = isExpressionGen( m.lStick ) and Reste(.F.)
endproc

procedure Compile_stmt
   = isDatabase() or isForm() or isClassLib() or isLabel() or isReport() 
   = isExpressionGen()
   = isAll()
   = isEncrypt() 
   = isNoDebug()
   = isAs() and isExpressionGen()
endproc

procedure Copy_stmt
   do case
      case isFile() and isExpressionGen() and isTo() and isExpressionGen()
      case isIndexes() and (isExpressionGenList() or isAll()) and isTo() and isExpressionGen()
      case IsMemo_() and isExpressionGen() and isTo() and isExpressionGen()
         = isAs() and isExpressionGen()
         = isAdditive()
      case isProcedures() and isTo() and isExpressionGen() 
         = isAs() and isExpressionGen()
         = isAdditive()
      case isTo()
         do case
            case isArray() and isVariable()
               if isFields()
                  = ( (isLike() or isExcept()) and isExpressionGen() ) or isExpressionGenList()
               endif
            case isExpressionGen()
               = isProduction()
               do case
                  case isStructure() and isExtended()
                  otherwise
                     if isFields()
                        = ( (isLike() or isExcept()) and isExpressionGen() ) or isExpressionGenList()
                     endif
               endcase
               = isDatabase() and isExpressionGen()
               = isName() and isExpressionGen()
         endcase
         = isType()
         do case
            case isFoxPLus()
            case isFox2x()
            case isFoxPLus()
            case isDif()
            case isMod()
            case isSdf()
            case isSylk()
            case isWk1()
            case isWks()
            case isWr1()
            case isWrk()
            case isCsv()
            case isXls()
            case isXL5()
            case isDelimited()
               if isWith() then
                  do case
                     case isCharacter() 
                        =isBlank_()
                        =isTab()
                        =isLiteralOrExpression()
                     
                     case IsLiteralOrExpression()
                  endcase
               endif
         endcase
         = isAs() and isExpression()     
         = isNoOptimize()
         = isScope()
         = (isFor() or isWhile()) and isExpressionGen()
      case isTag() and isExpressionGen()
         = isOf() and isExpressionGen()
         = isTo() and isExpressionGen()      
   endcase
endproc

procedure Count_stmt
   = isNoOptimize()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
   = isTo() and isVariable()
endproc

procedure Create_stmt
  do case
     case isView_C() and isExpressionGen()
     case isTrigger() and isOn() and isExpressionGen() and ;
          isfor() and ( isInsert() or isDelete() or isUpdate()) and ;
          isAs() and isExpressionGen()
     case isClass()
        = isQuestionMark() or isExpressionGen()
        = isOf() and ( isQuestionMark() or isExpressionGen())
        = isAs() and isExpressionGen()
        = isFrom() and isExpressionGen() and isFrom() 
        = isNowait()
     case isColor_() and isSet() and isExpressionGen()
     case isConnection()
        = isQuestionMark() or isExpressionGen()
        = isDatasource() and isExpressionGen()
        = isUserID() and isExpressionGen()
        = isPassword() and isExpressionGen()
        = isDatabase() and isExpressionGen()
        = isConnString() and isExpressionGen()
     case isDatabase() and isExpressionGen()
     case isFormC() 
        = isQuestionMark() or isExpressionGen()
        = isNowait()
        = isWindow() and isExpressionGen() 
        = isIn() and isExpressionGen()
        = isDefault()
        = isAs() and ( isQuestionMark() or isExpressionGen() ) and isFrom() and isExpressionGen() 
     case isMenu() or isLabel()
        = isQuestionMark() or isExpressionGen()
        = isNowait()
        = isSave()
        = isWindow() and isExpressionGen() 
        = isIn() and isExpressionGen()
     case isProject()
        = isQuestionMark() or isExpressionGen()
        = isNowait()
        = isSave()
        = isWindow() and isExpressionGen() 
        = isIn() and isExpressionGen()
        = isNoShow()
        = isNoProjectHook()
     case isQuery()
        = isQuestionMark() or isExpressionGen()
        = isNowait()
     case isReport() 
        = isQuestionMark() or isExpressionGen()
        if isFrom() then
           = isExpressionGen()
           = isForm() or isColumn()
           = isAlias()
           = isNoOverwrite()
           = isWidth() and isExpression()
           = isFields() and isFieldList()
        else
           = isNowait()
           = isSave()
           = isWindow() and isExpressionGen() 
           = isIn() and isExpressionGen()
           = isProtected()
        endif
     case isSql_View() and isExpressionGen()
        = isConnection() and isExpressionGen() and isShare()
        = isAs() and isExpressionGen()
     case isExpressionGen()
  endcase
endproc

procedure CreateSQL_stmt()
   if isTable() or isCursor()
      = isExpressionGen()
      = (isName() and isExpressionGen()) or isFree()
      = isCodePage() and isExpressionGen()
      do case
         case isFrom() and isArray() and isExpressionGen()
         case isLeftPar() and isFieldDefList() and isRightPar()
      endcase   
   endif   
endproc

function isFieldDef()
   if isExpressionGen() and isExpressionGen()
      if isLeftPar()
         = isExpressionGen()
         = isVirgule() and isExpressionGen()
         = isRightpar()
      endif    
      = isPrimary() and isKey()
      = isNot()
      = isNull_()
      = isDefault() and isExpressionGen() 
      = isCheck() and isExpressionGen() 
      = isError() and isExpressionGen() 
      if isAutoinc()
         = isNextvalue() and isExpressionGen()
         = isStep() and isExpressionGen()
      endif
      = isUnique()
      = isPrimary() and isKey()
      = isCollate() and isExpressionGen()
      = isReferences() and isExpressionGen() and ( isTag() and isExpressionGen() )
      = isNoCpTrans() 
      return .T.
   else
      return .F.
   endif   
endfunc

function isFieldDefList()
   return isList( 'isFieldDef()', .T. )
endfunc

procedure Backslash_stmt
   = isNextText()
endproc

procedure set_window
   = isName() and isExpressionGen()
   = ( isFrom() or isAt() ) and isExpressionGen() and isVirgule() and isExpressionGen() and;
     ( isTo() or isSize() ) and isExpressionGen() and isVirgule() and isExpressionGen()
   = isFont() and isExpressionGen() and isVirgule() and isExpressionGen()
   = isStyle() and isExpressionGen()
   = isColorStuf()
   = isGrow() or isNoGrow()
   = isFloat() or isNoFloat()
   = isClose() or isNoClose()
   = isZoom() or isNoZoom()
   = isShadow()
   = isTitle() and isExpressionGen()
   = isIn() and isExpressionGen()
   = isFill() and isExpressionGen()
   = isFooter() and isExpressionGen()
   = isMinimize() or isNoMiniMize()
   = isHalfHeigh()
   = isIcon() and isFile() and isExpressionGen()
   = isMdi() or isNoMdi()
   = isDouble() or isPanel() or isNone() or isSystem() or isExpressionGen()   
endproc

procedure Define_stmt()
   do case
      case isWindow() and isExpressionGen()
         do set_window
      case isPad() and isExpressionGen() and isOf() and isExpressionGen() and isPrompt() and isExpressionGen()
         = isAt() and isExpressionGenList()
         = ( isBefore() or isAfter() ) and isExpressionGen()
         if isFont() and isExpressionGenList() then
            =isStyle() and isExpressionGen()
         endif 
         = isMessage() and isExpressionGen()
         = isSkip() and isFor() and isExpressionGen()
         if IsColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isMark() and isExpressionGen()
         = isKey() and isExpressionGenList()
         = isNegotiate() and IsNegotiateList()
      case isBar() and isExpressionGen() and isOf() and isExpressionGen()
         = isMRU()
         = isPrompt() and isExpressionGen()
         if isBefore() or isAfter() then
             goStmt.NextByte()
             = isExpressionGen()
         endif
         if isFont() and isExpressionGenList() then
            =isStyle() and isExpressionGen()
         endif 
         = isMessage() and isExpressionGen()
         = isSkip() and isFor() and isExpressionGen()
         if IsColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isMark() and isExpressionGen()
         = isKey() and isExpressionGenList()
         = isPictRes() and isExpressionGen()
         = isPicture() and isExpressionGen()
         = isInvert()
      case isPopup() and isExpressionGen()
         = isFrom() and isExpressionGen() and isVirgule() and isExpressionGen() and;
           isTo()   and isExpressionGen() and isVirgule() and isExpressionGen()
         if isPrompt() then
            = isFiles() and isLike() and isExpressionGen() or;
              isField() and isExpressionGen() or;
              isStructure()   
         endif   
         if isFont() and isExpressionGenList() then
            =isStyle() and isExpressionGen()
         endif
         = isRTLJustify()
         = isTitle() and isExpressionGen()
         if IsColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isShadow()
         = isKey() and isExpressionGenList()
         = isMargin()
         = isIn() and isExpressionGen()
         = isRelative()
         = isFooter() and isExpressionGen()
         = isScroll()
         = isShortcut()
      otherwise
         * to terminate
   endcase
endproc

procedure Deactivate_Stmt
   = isMenu() or isPopup() or isWindow()
   = isAll() or isExpressionGenList()
endproc

procedure Declare_Stmt
   = isShort() or isInteger() or isSingle() or isDouble() or isLong() or isString() or isObject()
   = isStringLiteral() and isIn() and isStringLiteral() 
   = isAs() and isStringLiteral()
   = isBasicTypeList()
endproc

function isBasicType
   if isInteger() or isString() or isLong() && to continue
      = isArobas()
      return .T.
   else
      return .F.
   endif  
endfunc

function isBasicTypeList()
   return isList( 'isBasicType()', .T. )
endfunc   

procedure DeleteSQL_stmt
   = isExpressionGen()
   if isFrom() then
      = isForce()
      = isExpressionGen()
      = isJoinClauseList()
   endif 
   = isWhere() and isExpressionGen()
endproc

procedure Delete_stmt
   do case
      case isFile() and isExpressionGen() and isRecycle()
      case isDatabase() and isExpressionGen()
         = isDeleteTables()
         = isRecycle()
      case isConnection() and isExpressionGen()
      case isTag() and isTagExpList()
      case isView() and isLiteralOrExpression()
      otherwise
         = isIn() and isExpressionGen()
         = isNoOptimize()
         = isScope()
         = isFor() and isExpressionGen()
         = isWhile() and isExpressionGen()   
   endcase
endproc

function isTagExp
   if isExpressionGen() 
      = isOf() and isExpressionGen()
      return .T.
   else
      return .F.   
   endif   
endfunc

function isTagExpList()
   return isList( 'isTagExp()' )
endfunc

procedure Dir_stmt
   =isOn() and isExpressionGen()
   =isToDevice()
   =isLike() and isExpressionGen()
endproc

procedure Dock_stmt
   = (isWindow() and isExpressionGen()) or (isName() and isExpressionGen())
   = isPosition() and isExpressionGen()
   = (isWindow() and isExpressionGen()) or (isName() and isExpressionGen())
endproc

procedure Do_stmt
   do case
      case isForm()
         = isExpressionGen()
         = isName() and isExpressionGen()
         = isTo() and isVariable() 
         = isWith() and isExpressionGenList()
         = isLinked()
         = isNoRead()
         = isNoShow()
      case isWhile() and isExpression() and reste(.F.)
         goText.PostIndent(+1)
      case isCase() and reste(.F.)
         goText.PostIndent(+2)
      otherwise
         = isExpressionGen()
         = isIn() and isExpressionGen()
         = isWith() and isExpressionGenList()
   endcase
endproc

procedure Drop_stmt
   = isTable() or isView()
   = isExpressionGen()
   = isRecycle()
endproc

procedure Erase_stmt
   = isExpressionGen()
   = isRecycle()
endproc

procedure ExpressionFin
   ExpressionGenerale( goStmt.NextByte() )
   do Reste with goStmt.NextByte() <> T_END_STMT
endproc

procedure External_stmt
   do case
      case isArray() and isVariableList()
      otherwise
         = ( isFile() or isClass() or isForm() or isLabel() or isLibrary() or;
             isMenu() or isProcedure() or isQuery() or isReport() or isScreen() or;
             isTable() ) and isExpressionGenList()
   endcase
endproc

procedure For_stmt
   goMemo.Write( ' ' )
   = isLValue() and isAssign() and isExpression() and isTo() and isExpression() and ;
     isStep() and isExpression()
   = Reste(.F.)
   goText.PostIndent(+1)
endproc

procedure For_each_stmt
   goMemo.Write( ' ' )
   = isLValue()
   if isAs() and isExpressionGen()
      = isOf() and isExpressionGen()
   endif
   = isIn() and isExpressionGen()
   = isFoxObject() 
   = Reste(.F.)    
   goText.PostIndent(+1)
endproc

procedure Gather_stmt
   = IsMemo_()
   do case
      case isMemVar()
      case (isFrom() or isName()) and isVariable()
   endcase
   if isFields()
      = ( (isLike() or isExcept()) and isExpressionGenList() ) or isExpressionGenList()
   endif
endproc

procedure GetExpr_stmt
   = isExpressionGen()
   = isTo() and isExpressionGen()
   = isType() and isExpressionGen()
   = isDefault() and isExpressionGen()
endproc

procedure Go_stmt
   local lcTxt1, lcTxt2, lcTxt3
   lcTxt1 = goMemo.Harvest()
   = isIn() and isExpressionGen()
   lcTxt2 = goMemo.Harvest()
   = isTop() or isBottom() or isExpressionGen()
   lcTxt3 = goMemo.Harvest()
   goMemo.cTxt = m.lcTxt1 + m.lcTxt3 + m.lcTxt2
endproc

procedure Implements_stmt
   = isStringLiteral() and isExclude()
   = isIn()
   = isStringLiteral()
endproc

procedure Import_stmt
   = isFrom() and isExpressionGen()
   = isType()
   = isDif() or isFw2() or isMod() or isPdox() or isRpd() or isSdf() or isSylk() or;
     isWk1() or isWk3() or isWks() or isWr1() or isWrk() or isCsv() or isXls() or;
     isXl5() or isXl8()
   = isAs() and isExpressionGen()
   = isDatabase() and isExpressionGen()
   = isName() and isExpressionGen()
   = isSheet() and isExpressionGen()
endproc

procedure Index_stmt
   = isOn() and isExpressionGen() and ( isTo() or isTag() ) and isExpressionGen()
   = isBinary_()
   = isOf() and isExpressionGen()
   = isCollate() and isExpressionGen()
   = isUnique() or isCandidate()
   = isCompact()
   = isAscending() or isDescending()
   = isAdditive()
   = isFor() and isExpressionGen()
endproc

procedure Insert_stmt
   = isBlank_()
   = isBefore()
endproc

procedure InsertSQL_stmt
   = isInto() and isExpressionGen()
   if isLeftPar() then
      = isExpressionGenList() and isRightPar()
   endif
   do case
      case isValues() and isLeftPar() and isExpressionGenList() and isRightPar()
      case isFrom() and ( (isArray() and isVariable()) or isMemVar() or (isName() and isExpressionGen()) )
      case isSelect()
         goStmt.DeleteFirst( goStmt.Position() - 3 )
         selectSQL_Stmt()
   endcase    
endproc

procedure Hide_stmt
   do case
      case isMenu() or isPopup()
         = isSave()
         = isAll() or isExpressionGenList()
      case isWindow()
         = isSame() or isBottom() or isTop()
         if isIn() then
            = isExpressionGen()
         endif
         =isExpressionGen() && window reference
   endcase
endproc

procedure if_stmt
   = isExpressionGen()
   = goStmt.NextByte()
   = goStmt.NextShort()
   = reste(.F.)
endproc

procedure Join_stmt
   = isWith() and isExpressionGen()
   = isTo() and isExpressionGen()
   = isFor() and isExpressionGen()
   = isFields() and isExpressionGenList()
endproc
   
procedure keyboard_stmt
   = isExpressionGen()
   = isPlain()
   = isClear()
endproc

procedure List_stmt
   do case
      case isFiles()
         = isOn() and isExpressionGen()
         = isToDevice()
         = isLike() and isExpressionGen()
         = isNoConsole()
      case isMemory() or isObjects()
         = isToDevice()
         = isLike() and isExpressionGen()
         = isNoConsole()
      case isStatus() or isConnections() or isDatabases() or isDLLS() or isProcedures() or isTables() or isViews()
         = isToDevice()
         = isNoConsole()
      case isStructure()
         = isIn() and isExpressionGen()
         = isToDevice()
         = isNoConsole()
      otherwise
         = isNoOptimize()
         = isScope()
         = isFor() and isExpressionGen()
         = isWhile() and isExPressionGen()
         = isToDevice()
         = isOff()
         = isNoConsole()
         = isFields()
         if goStmt.LastByte() = 0xF8 then && number of arguments follows
            if goStmt.NextWord() > 0 then
               goStmt.NextByte()
               = isExpressionGenList()
            endif
         endif
   endcase
endproc
   
procedure Local_stmt
   isList( 'isVariable() and isAs() and isLiteral() and isOf() and isLiteral()' )
endproc

procedure Locate_stmt
   = isNoOPtimize()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
endproc

procedure Macro_stmt
* As soon as an '&' is detected as a macro in a statement, Foxpro stores the whole
* ascii statement. We then have an indent problem if the statement is an 'if' a 'for'
* or a 'do while' statement. I have heuristicaly based the indentation on the extra
* information (0xF9) which exists only for that kind of statement.
   local b
   b = goStmt.LastByte()
   do while m.b <> T_ENDMACRO and m.b <> T_EXTRAINFO 
      goMemo.Write( chr(m.b) ) 
      b = goStmt.NextByte()
   enddo
   if m.b = T_EXTRAINFO then
      goText.PostIndent(+1)
      do Reste with .F.
   endif
endproc

procedure Menu_stmt
   do case
      case isTo() and isExpressionGen()
      case isBar() and isExpressionGenList()
      case isExpressionGenList()
   endcase
endproc

procedure Modify_stmt
   do case
      case isCommand() and isLiteralOrExpression()
         = isNoEdit()
         = isNoMenu()
         = isNoWait()
         = isRange() and isExpression() and isVirgule() and isExpression()
         = isWindow() and isVariable()
         = isIn() and isVariable()
         = isAs() and isLiteralOrExpression()
         = isSame()
         = isSave()    
      case isProcedure()
      case isClass()      and isVariable()
      case isProject()    and isLiteralOrExpression()
      case isConnection() and isLiteralOrExpression()
      case isDatabase()   and isLiteralOrExpression()
      case isFile()       and isLiteralOrExpression()
      case isFormScreen() and isLiteralOrExpression()
      case isGeneral()    and isVariable()
      case isLabel()      and isLiteralOrExpression()
      case IsMemo_()      and isVariable()
      case isMenu()       and isLiteralOrExpression()
      case isQuery()      and isLiteralOrExpression()
      case isReport()     and isLiteralOrExpression()
      case isStructure()
      case isView()       and isLiteralOrExpression()
      case isWindow()     and isExpressionGen()
         do set_window
      otherwise
   endcase
endproc

procedure Mouse_stmt
   = isWIndow() and isExpressionGen()
   = isPixels()
   do case
      case isClick() or isDblClick()
         = isAt() and isExpressionGenList()
         = isLeft() or isMiddle() or isRight()
         = isAlt()
         = isControl()
         = isShift()
      case isDrag() and isTo() and isExpressionGenList()
   endcase
endproc

procedure Move_stmt
   = ( isWindow() or isPopup() ) and isExpressionGen()
   = isCenter()
   = ( isTo() or isBy() ) and isExpressionGen() and isVirgule() and isExpressionGen()
endproc

procedure pack_stmt
   if not isDatabase() then
      = isIn() and isExpressionGen()
      = (IsMemo_() or isDbf()) and isExpressionGen()
   endif
endproc

procedure pop_stmt
  = isKey() and isAll()
  if isMenu() then
     = isTo() and isMaster()
     = isExpressionGen()
  endif
  = isPopup() and isExpressionGen()   
endproc

procedure Print_stmt
   if goStmt.LastByte() = 0xF8 then && skip number of arguments
      goStmt.NextWord()
   endif
   goStmt.NextByte()
   = isExpressionGenList()
endproc

procedure private_stmt
   if isAll() and ( isLike() or isExcept() ) and isMask()
   else
      isVariableList()
   endif
endproc

procedure push_stmt
   = isKey() and isClear()
   = isMenu() and isExpressionGen()
   = isPopup() and isExpressionGen()
endproc

procedure Read_stmt
   do case
      case isEvents()
      case isMenu() and isBar() and isTo() and isExpressionGenList() and isSave()
      otherwise
         = isValid() and isExpressionGen()
         = isColorStuf()
         = isSave()
         = isTimeOut() and isExpressionGen()
         = isNoMouse()
         = isCycle()
         = isObject() and isExpressionGen()
         = isShow() and isExpressionGen()
         = isActivate() and isExpressionGen()
         = isDeactivate() and isExpressionGen()
         = isWhen() and isExpressionGen()
         = isModal()
         = isWith() and isExpressionGenList()
         = isLock()
   endcase 
endproc

procedure ReadTags
   local b
   b = goStmt.NextByte()
   if m.b <> T_END_STMT then
      do case
         case m.b = 0x03
            goMemo.Write( ' all' )
         case m.b = 0x11
            goMemo.Write( ' fields' )
         case m.b = 0x14
            goMemo.Write( ' format' )
         case m.b = 0x1A
            goMemo.Write( ' macros' )
         case m.b = 0x1B
            goMemo.Write( ' memory' )
         case m.b = 0x1C
            goMemo.Write( ' menus' )
         case m.b = 0x22
            goMemo.Write( ' prompt' )
         case m.b = 0x2C
            goMemo.Write( ' windows' )
         case m.b = 0xC9
            goMemo.Write( ' alternate' )
         case m.b = 0xCB
            goMemo.Write( ' procedure' )
         case m.b = 0xCE
            goMemo.Write( ' indexes' )
         case m.b = 0xCF
            goMemo.Write( ' databases' )
         case m.b = 0xD0
            goMemo.Write( ' program' )
         case m.b = 0xD3
            goMemo.Write( ' popups' )
         case m.b = 0xD5 
            goMemo.Write( ' read' )
            b = goStmt.NextByte()
            if m.b = 0x03 then
               goMemo.Write( ' all' )
            endif
         case m.b = 0xE1
            goMemo.Write( ' typeahead' )
         otherwise
            do Reste with .T.
      endcase
      do Reste with .F.
   endif
endproc

procedure Remove_stmt
   do case
      case isClass()
         = isExpressionGen()
      case isTable()
         = isExpressionGen()
         = isDelete()
         = isRecycle()
   endcase      
endproc

procedure Rename_stmt
   do case
      case isClass()
         = isExpressionGen() and isOf() and isExpressionGen() and isTo() and isExpressionGen()
      case isTable() or isConnection() or isView()
         = isExpressionGen() and isTo() and isExpressionGen()
      otherwise
         = isExpressionGen() and isTo() and isExpressionGen()
   endcase   
endproc

procedure With_stmt
   = isExpression() and reste(.F.)
endproc

procedure zoom_stmt
   = isWindow() and isExpressionGen()
   = isMin() or isMax() or isNorm()
   = ( isFrom() or isAt() ) and isExpressionGen() and isVirgule() and isExpressionGen() and;
     ( isTo() or isSize() ) and isExpressionGen() and isVirgule() and isExpressionGen()
endproc


function N_Expression( b as byte ) as byte
   local fini

   fini = .F.
   do while not m.fini
      ExpressionGenerale( m.b )
      b = goStmt.NextByte()
      fini = m.b <> 0x07
      if not m.fini then
         goMemo.Write( ',' )
         b = goStmt.NextByte()
      endif
   enddo
   return m.b

endfunc


function opt_color() as byte
   goMemo.Write( ' color' )
   return fGetColor( goStmt.NextByte() )
endfunc


function fGetColor( b as byte ) as byte
   do case
      case m.b = 0x42
         goMemo.Write( ' rgb(' )
         b = goStmt.NextByte()
         do while InList( m.b, 0x07, 0xFC )
            do case
               case m.b = 0x07
                  goMemo.Write( ',' )
               case m.b = 0xFC
                  Expression( m.b )
            endcase
            b = goStmt.NextByte()
         enddo
         goMemo.Write( ')' )
      case m.b = 0xF8
         if ExpressionGenerale( b ) then
            b = goStmt.NextByte()
         endif
   endcase
   return m.b
endfunc

procedure On_stmt
   do case
      case isError() or isEscape() or isShutdown()
         = isExpressionGen()
      case isSelection()
         do case
            case ( isPopup() or isMenu() ) and ( isAll() or isExpressionGen() )
            case ( isPad() or isBar() ) and isExpressionGen() and isOf() and isExpressionGen()
         endcase
         = isExpressionGen()
      case isPage() and isAt() and isLine() and isExpressionGen()
      case isPad() and isExpressionGen() and isOf() and isExpressionGen() and isActivate() and;
         ( isPopup() or isMenu() ) and isExpressionGen()
      case isKey()
         = isLabel() and isExpressionGen() and isExpressionGen()
         = isExpressionGen()
      case isBar() and isExpressionGen() and isOf() and isExpressionGen()
         = isActivate() and ( isPopup() or isMenu() ) and isExpressionGen() or;
           isExpressionGen()
   endcase
endproc

procedure Open_stmt
   if isDatabase() and isExpressionGen()
      = IsExclusive_() or isShared()
      = isNoupdate()
      = isValidate()
   endif 
endproc

procedure OnOff( b as byte )
   if m.b = 0x20 then
      goMemo.Write( ' ON' )
   else
      if m.b = 0x1F then
         goMemo.Write( ' OFF' )
      else 
         goMemo.Write( ' ' + cByte( b ) )
      endif
   endif
   do Reste with goStmt.NextByte() <> T_ENS_STMT
endproc


procedure Release_stmt
   do case
      case isAll()       and (((( isLike() or isExcept() ) and isMask()) or isExtended()))
      case isBar()       and ( isExpressionGen() or isAll() ) and isOf() and isExpressionGen() 
      case isClasslib()  and ( isStringInStringList() or ( isAlias() and isVariable() ) )
      case isLibrary()   and isExpressionStr() and isIn() and isExpressionGen()
      case isMenus()
         isExtended()
         isVariable()
      case isPad()       and isVariable() and isOf() and isVariable()
      case isPopups()
         isExtended()
         isVariable()
      case isProcedure() and isExpressionStrList()
      case isWindows()   and isVariableList()
      case isExpressionGenList() 
   endcase
endproc

procedure Replace_stmt
   local lcTxt1, lcTxt2, lcTxt3
   if isFrom() and isArray() then
      = isVariable()
      if isFields()
         = ( (isLike() or isExcept()) and isExpressionGen() ) or isExpressionGenList()
      endif
      = isNoOptimize()
      = isScope()
      = (isFor() or isWhile()) and isExpressionGen()
   else
      = isIn() and isVariable()
      lcTxt1 = goMemo.Harvest()
      = isReplaceFieldList()
      lcTxt2 = goMemo.Harvest()
      = isNoOptimize()
      = isScope()
      = (isFor() or isWhile()) and isExpressionGen()
      lcTxt3 = goMemo.Harvest()
      goMemo.cTxt = m.lcTxt1 + m.lcTxt3 + m.lcTxt2
   endif   
endproc

function isToDevice()
   if isTo() then
      do case
         case isPrinter()
            = isPrompt()
         case isFile()
            = isExpressionGen()
            = isAdditive()
      endcase
      return .T.
   endif
   return .F.
endfunc

procedure Report_stmt
   local lc1, lc2, lc3, lc4
   = isForm() and isExpressionGen()
   lc1 = goMemo.Harvest()
   = isPreview()
   lc2 = goMemo.Harvest()
   = isName() and isExpressionGen()
   = isEnvironment()
   = isPdsetup()
   = isHeading() and isExpressionGen()
   = isNoReset()
   = isSummary()
   = isPlain()
   = isNoEject()
   = isNoPageEject()
   = isASCII()
   = isToDevice()   
   = isOff()
   = isNoConsole()
   = isNoDialog()
   lc3 = goMemo.Harvest()
   = isIn() and isVariable()
   = isNoWait()
   = isWindow() and isExpressionGen()
   = isRange() and isExpressionGen() and isVirgule() and isExpressionGen()
   if isObject()
      = isType()
      = isExpressionGen()
   endif
   = isScope()
   = (isFor() or isWhile()) and isExpressionGen()
   lc4 = goMemo.Harvest()
   goMemo.cTxt = m.lc1 + m.lc3 + m.lc2 + m.lc4
endproc

function isScope()
   return isRest() or ;
          isAll() or ;
        ( ( isNext() or isRecord() ) and isExpressionGen() )
endfunc

procedure Restore_stmt
   = isMacros() or isScreen() or isWindows()
   = isFrom() and IsMemo_()
   = isExpressionGen()
   = isAll() or isAdditive() or isExpressionGenList()
endproc

procedure Return_stmt
   = isExpression() or ;
     isTo() and ( isMaster() or isExpressionGen() )
endproc

procedure Save_stmt
   do case
      case isTo() 
         = IsMemo_()
         = isExpressionGen()
         = isAll() and (isLike() or isExcept()) and isExpressionGen()
      case isScreen() or isMacros()
         = isTo()
         = IsMemo_()
         = isExpressionGen()
      case isWindows()
         = isTo() and isMemo_()
         = isExpressionGen()   
         = isAll() or isExpressionGenList()
   endcase
endproc

procedure Scan_stmt
   = isNoOptimize()
   = isScope()
   = (isFor() or isWhile()) and isExpressionGen()
   reste(.F.)
endproc

procedure Show_stmt
   do case
      case isGet() and isExpressionGenList()
         = isLevel() and isExpressionGen()
         if isColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isEnable() or isDisable()
         = isPrompt() and isExpressionGen()
      case isGets()
         = isLevel() and isExpressionGen()
         if isColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isEnable() or isDisable()
         = isOnly()
         = isOff()
         = isWindow() and isExpressionGen()
         = isLock()
      case isMenu()
         = isSave()
         = isPad() and isExpressionGen()
         = isAll() or isExpressionGenList()
      case isObject() and isExpressionGen()
         = isLevel() and isExpressionGen()
         if isColor_()
            = isScheme()
            = isExpressionGen()
         endif
         = isEnable() or isDisable()
         = isPrompt() and isExpressionGen()
      case isPopup()
         = isSave()
         = isAll() or isExpressionGenList()
      case isWindow()
         = isSave()
         = isTop() or isBottom() or isSame()
         = isIn() and isExpressionGen()
         = isRefresh()
         = isExpressionGenList()
   endcase
endproc

procedure Scatter_stmt
   = IsBlank_()
   = IsMemo_()
   do case
      case isMemvar()
      case (isTo() or isName()) and isVariable()
   endcase
   = isAdditive()   
   if isFields()
      = ( (isLike() or isExcept()) and isExpressionGenList() ) or isExpressionGenList()
   endif
endproc

procedure Seek_stmt
   = isIn() and isExpressionGen()
   if isOrder_tag() then
      = isExpressionGen()
      = isOf() and isExpressionGen()
      = isAscending() or isDescending()
   endif
   = isExpression()
endproc

procedure SelectSQL_stmt
   local llAll
   local llUnion
   local lnLong
   local loSelect

   llUnion = goStmt.LastByte() = T_UNION
   if  m.llUnion then
      goMemo.cTxt = "" && forget the '<Ln>select' of WriteCode 
      create cursor Pile ( isunion L, isAll L, cTxt M )
      loSelect = CreateObject( "CMemory", goStmt.cMem )
      loSelect.Positionne(1)
      loSelect.NextByte()
      do while m.llUnion 
         llUnion = loSelect.LastByte() = T_UNION
         if m.llUnion then
            loSelect.NextByte()
            llAll = loSelect.LastByte() = T_ALL
            if m.llAll then
               loSelect.NextByte()
            endif
            if loSelect.LastByte() = T_TRIPLE
               lnLong = loSelect.NextTriple()-1
            else
               error "T_TRIPLE was expected in union select"   
            endif   
         else
            loSelect.Back(1)
            lnLong = Len( loSelect.cMem ) - (loSelect.Position() + 1)
         endif   
         goStmt = CreateObject( "CMemory", loSelect.Read( m.lnLong ) + Chr( T_END_STMT ) )
         loSelect.NextByte()
         * \[<<goStmt.cDump(0,goStmt.Length-1)>>]
         goStmt.NextByte()
         SimpleSQL_Stmt()
         insert into Pile values ( m.llUnion, m.llAll, goMemo.Harvest() )
      enddo
      
      locate for not Pile.isUnion
      goMemo.LnWrite( "select " )
      goMemo.Write( Pile.cTxt )
      scan for isUnion
         goMemo.Writeln( " ;" )
         goMemo.Write( "union " )
         if Pile.isAll then
            goMemo.Write( "all " )
         endif
         goMemo.WriteLn( " ;" )
         goMemo.Write( "select" )
         goMemo.Write( Pile.cTxt )
      endscan
      use
   
   else
      SimpleSQL_stmt()
   endif
      
endproc

function SimpleSQL_stmt
   local lcTxt1, lcTxt2, lcTxt3, lcTxt4
   store '' to lcTxt1, lcTxt2, lcTxt3, lcTxt4
   = isAll() or isDistinct()
   lcTxt1 = goMemo.Harvest()
   = isTop() and isExpression() and isPercent()
   if isFrom() then
      = isForce()
      = isTableItemList()
      = isJoinClauseList()
      if isWithBuffering()
         =isExpression()
         goMemo.write( ' )' )
      endif
      lcTxt2 = goMemo.Harvest()
      = isSelectItemList()
      lcTxt3 = goMemo.Harvest()
      = isWhere() and isExpressionGen()
      = isGroup_By() and isExpressionGenList()
      = isHaving() and isExpressionGen()
      = isOrder_By() and isOrderList()
      = isInto() and ( ( isTable() and isLiteralOrExpression() ) or;
                       ( isArray() and isVariable() ) or;
                       ( isCursor() and isLiteralOrExpression() ) )
   endif
   = isNoWait()
   = isPlain()
   = isNoConsole()   
   = isPreference() and isExpressionGen()
   lcTxt4 = goMemo.Harvest()
   if At( ";*", Chrtran( m.lcTxt3, " "+Chr(13)+Chr(10), "") ) > 0 then
      * No line can begin with a '*'
      lcTxt3 = " " + Substr( m.lcTxt3, At("*", m.lcTxt3) )
   endif
   goMemo.cTxt = m.lcTxt1 + m.lcTxt3 + m.lcTxt2 + m.lcTxt4
endproc

*!*   procedure SimpleSQL_stmt
*!*      local lcTxt1, lcTx2
*!*      = isAll() or isDistinct()
*!*      lcTxt1 = goMemo.Harvest()
*!*      lcTx2 = SimpleSQL()
*!*      goMemo.cTxt = m.lcTxt1 + m.lcTx2
*!*   endproc

procedure isOrder
   if isExpressionGen()
      = isDescending() or isAscending()
      return .T.
   else
      return .F.   
   endif   
endproc

procedure isOrderList()
   return isList( 'isOrder()' )
endproc


procedure Set_stmt
   local b
   
   b = goStmt.LastByte()
   if Between( m.b, 1, Alen( gaSet ) ) then
      goMemo.Write( ' ' + gaSet( m.b ) )
   else
      goMemo.Write( ' ' + cByte( m.b ) )
   endif
   goStmt.NextByte()
   
   do case
      case m.b = T_RELATION
         = isAdditive()
         do case
            case isTo() and isExpressionGen() and isInto() and isExpressionGen()
               do while isVirgule()
                  = isExpressionGen() and isInto() and isExpressionGen()
               enddo
            case isOff() and isInto() and isExpressionGen() 
         endcase
      case m.b = T_DATE_Token
         = isExpressionGen()
      case m.b = 0x28 && ORDER
         = isIn() and isExpressionGen()
         = isTo() and isExpressionGen()
         = isAscending() or isDescending()   
      otherwise
         = isBar()
         do case
            case isOn() or isOff() or isAutomatic() or isStatus()
            case isTo()
               do case
                  case isRTLJustify()
                  case isLTRJustify()
                  case isDefault()
                  case isPrint() or isScreen() or isAll()
                  case isLiteralOrExpression()
                     do while isVirgule()
                        = isLiteralOrExpression()
                     enddo
                     = isAdditive()
                  case isDos() or isWindows()    
               endcase
            case isSave() or isNoSave()
         endcase
         do case
            case isShow()
            case isNoShow()
         endcase
   endcase
   reste( .T. )
endproc
   
procedure Skip_stmt
   local lcTxt1, lcTxt2, lcTxt3
   lcTxt1 = goMemo.Harvest()
   = isIn() and isExpressionGen()
   lcTxt2 = goMemo.Harvest()
   = isExpressionGen()
   lcTxt3 = goMemo.Harvest()
   goMemo.cTxt = m.lcTxt1 + m.lcTxt3 + m.lcTxt2
endproc

procedure Sort_stmt
   = isFields() and isVariableList()
   = isAscending() or isDescending()
   = isOn() and isSortFieldList()
   = isTo() and isExpressionGen()
   = isNoOptimize()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
endproc

function isSortField
   if isVariable()
      = isExpressionGen()
      return .T.
   else
      return .F.
   endif      
endfunc

function isSortFieldList
   return isList( 'isSortField()' )
endfunc


function isVarList
   return isSortFieldList()  && VarList is a subset of SortFieldList
endfunc

procedure Store_stmt
   = isExpressionGen() and isTo() and isVariableList()
endproc

procedure Sum_stmt
   = isNoOptimize()
   = isScope()
   = isFor() and isExpressionGen()
   = isWhile() and isExpressionGen()
   if isTo() then
      = isArray()
      = isVarList()
   endif
   = isExpressionGenList()
endproc

procedure Total_stmt
   = isOn() and isExpression() and isTo() and isExpressionGen()
   = isNoOptimize()
   = isScope()
   = (isFor() or isWhile()) and isExpressionGen()
   = isFields() and isFieldList()
endproc

procedure Type_stmt
   = isNumber_()
   = isWrap()
   = isAuto()
   if isTo() then
      = isPrinter() and isPrompt()
      = isFile() and isExpressionGen()
   endif
   = isExpressionGen()
endproc

procedure Unlock_stmt
   = isAll()
   = isIn() and isExpressionGen()
   = isRecord() and isExpressionGen()
endproc

procedure UpdateSQL_stmt
   = isExpressionGen()
   if isFrom() then
      = isForce()
      = isExpressionGen()
      = isJoinClauseList()
   endif 
   = isSet() and isSetFieldList()
   = isWhere() and isExpressionGen()
endproc

procedure Update_stmt
   = isOn() and isExpressionGen()
   = isFrom() and isExpressionGen()
   = isReplace() and isReplaceFieldList()
   = isRandom()
endproc

procedure Use_stmt
   = isIn() and isExpressionGen()
   = isExclusive_() or isShared()
   = isNoUpdate() 
   = isLiteralOrExpression()
   = isAgain()
   = isAlias() and isExpressionGen()
   = ( isOrder_Tag() or isIndex() ) and isLiteralOrExpression() and ( isAscending() or isDescending() )
endproc

procedure Validate_stmt
   = isDatabase()
   = isRecover()
   = isToDevice()
   = isNoConsole()
endproc

procedure Wait_stmt
   = isTo() and isVariable()
   = isClear() or isNoClear()
   = isWindow() and isAt() and isExpression() and isVirgule() and isExpression()
   = isNoWait()
   = isTimeout() and isExpression()
   = isExpressionGen()
endproc

******************************

function isSelectItem()
   if isExpressionGen() then
      = isAs() and isVariable()
      return .T.
   else
      return .F.
   endif      
endfunc

function isSelectItemList()
   return isList( 'isSelectItem()', .T. )
endfunc

function isJoinClause()
   if ( isInner() or isLeft() or isRight() or isFull() ) and isJoin() and isLiteralOrExpression() then
      = isAs() and isVariable()
      = isOn() and isExpression()
      return .T.
   else
      return .F.
   endif
endfunc

function isJoinClauseList()
   do while isJoinClause()
   enddo
endfunc

procedure isPString()
   goMemo.Write( goStmt.NextPString() )
endproc


function isTableItem()
   if isLiteralOrExpression() then
      = isAs() and isVariable()
      return .T.
   else
      return .F.
   endif
endfunc

function isTableItemList()
   return isList( 'isTableItem()' )         
endfunc

function isReplaceField()
   if isExpressionGen() and isWith() and isExpressionGen() then
      = isAdditive()
      return .T.
   else
      return .F.
   endif
endfunc         
      
function isReplaceFieldList()
   return isList( "isRePlaceField()", .t. )
endfunc

function isSetField()
   if isExpressionGen() and isAssign() and isExpressionGen() then
      return .T.
   else
      return .F.
   endif
endfunc         
      
function isSetFieldList()
   return isList( "isSetField()", .t. )
endfunc

