
#define IMAGE_DOS_SIGNATURE           0x5A4D   && MZ
#define IMAGE_PE_SIGNATURE            0x4550   && PE 00 00
#define IMAGE_FILE_HEADER_SIZE        0x14
#define IMAGE_SIZEOF_SECTION_HEADER   0x28
#define IMAGE_PE_ADDRESS              0x3C

#define FOXPROAPP 		0xF2FE
#define ENCRYPTED 		0xEE
#define NOCRYPTED 		0xFF
#define PARTENTRYSIZE   25

#define gpCODEFILE  0
#define gpTABLE     2
#define gpMEMOFILE  3
#define gpINDEXFILE 4
#define gpFILE      6
#define gpCLASSLIB  8
#define gpFORM      9
#define gpREPORT   10
#define gpLABEL    11

#define P_NULL          0
#define P_OPERATOR      1
#define P_VAR			2             
#define P_TERME         3
#define P_SELECT        4
#define P_FONCTION      5
#define P_MEMBER        6
#define P_ARG_LIST      7
#define P_PARENTHESES   8
#define P_CONST         9
#define P_REFERENCE    10
#define P_SQL_TAG      11

#define MAXCOMMANDE    0xBF
#define MAXSYMBOL      0x21C
#define MAXSET         0x92
#define MAXFOXVAR      0x55
#define MAXFOXCST      0x100
#define MAXFOXCSTEXT   0x08

#define S_macro        0x01
#define S_print        0x02
#define S_print2       0x03
#define S_arobas       0x04
#define S_accept       0x05
#define S_append       0x06
#define S_assist       0x07
#define S_average      0x08
#define S_browse       0x09
#define S_call         0x0A
#define S_cancel       0x0B
#define S_case         0x0C
#define S_change       0x0D
#define S_clear        0x0E
#define S_close        0x0F
#define S_continue     0x10
#define S_copy         0x11
#define S_count        0x12
#define S_create       0x13
#define S_delete       0x14
#define S_dimension    0x15
#define S_dir          0x16
#define S_display      0x17
#define S_do           0x18
#define S_edit         0x19
#define S_eject        0x1A
#define S_else         0x1B
#define S_endcase      0x1C
#define S_enddo        0x1D
#define S_endif        0x1E
#define S_endtext      0x1F
#define S_erase        0x20
#define S_exit         0x21
#define S_find         0x22
#define S_go           0x23
#define S_help         0x24
#define S_if           0x25
#define S_index        0x26
#define S_input        0x27
#define S_insert       0x28  && FOXPRO
#define S_join         0x29
#define S_label        0x2A
#define S_list         0x2B
#define S_load         0x2C
#define S_locate       0x2D
#define S_loop         0x2E
#define S_modify       0x2F
#define S_30           0x30
#define S_on           0x31  
#define S_otherwise    0x32
#define S_pack         0x33
#define S_parameter    0x34
#define S_private      0x35
#define S_36           0x36  &&  procedure 
#define S_public       0x37
#define S_quit         0x38
#define S_read         0x39
#define S_recall       0x3A
#define S_reindex      0x3B
#define S_release      0x3C
#define S_rename       0x3D
#define S_replace      0x3E
#define S_report       0x3F
#define S_restore      0x40
#define S_resume       0x41
#define S_return       0x42
#define S_exclamation  0x43
#define S_save         0x44
#define S_seek         0x45
#define S_select       0x46  && foxpro 
#define S_set          0x47
#define S_skip         0x48
#define S_sort         0x49
#define S_store        0x4A
#define S_sum          0x4B
#define S_suspend      0x4C
#define S_text         0x4D
#define S_total        0x4E
#define S_type         0x4F
#define S_update       0x50
#define S_use          0x51
#define S_wait         0x52
#define S_zap          0x53
#define S_assign       0x54
#define S_endproc      0x55
#define S_export       0x56
#define S_import       0x57
#define S_retry        0x58
#define S_logout       0x59
#define S_unlock       0x5A
#define S_flush        0x5B
#define S_keyboard     0x5C
#define S_menu         0x5D
#define S_scatter      0x5E
#define S_gather       0x5F
#define S_scroll       0x60
#define S_61           0x61
#define S_62           0x62
#define S_63           0x63
#define S_64           0x64
#define S_65           0x65
#define S_66           0x66
#define S_67           0x67
#define S_create_sql   0x68
#define S_alter        0x69
#define S_drop         0x6A
#define S_6B           0x6B
#define S_6C           0x6C
#define S_6D           0x6D
#define S_6E           0x6E
#define S_select_sql   0x6F
#define S_update_sql   0x70
#define S_delete_sql   0x71
#define S_insert_sql   0x72
#define S_define       0x73
#define S_activate     0x74
#define S_deactivate   0x75
#define S_printjob     0x76
#define S_endprintjob  0x77
#define S_78           0x78
#define S_print3       0x79
#define S_move         0x7A
#define S_on_key       0x7B
#define S_declare      0x7C
#define S_calculate    0x7D
#define S_scan         0x7E
#define S_endscan      0x7F
#define S_show         0x80
#define S_play         0x81
#define S_getexpr      0x82
#define S_compile      0x83
#define S_for          0x84
#define S_endfor       0x85
#define S_equal        0x86
#define S_hide         0x87
#define S_88           0x88
#define S_size         0x89
#define S_push         0x8A
#define S_pop          0x8B
#define S_zoom         0x8C
#define S_backslash    0x8D
#define S_backslash2   0x8E
#define S_build        0x8F
#define S_external     0x90
#define S_91           0x91
#define S_RunScript    0x92
#define S_blank        0x93
#define S_reset        0x94
#define S_open         0x95
#define S_add          0x96
#define S_remove       0x97
#define S_98           0x98
#define S_evalfunc     0x99
#define S_9A           0x9A
#define S_begin        0x9B
#define S_rollback     0x9C
#define S_end          0x9D
#define S_hidden_proc  0x9E
#define S_hidden       0x9F
#define S_validate     0xA0
#define S_protected    0xA1
#define S_Method       0xA2
#define S_protected_pr 0xA3
#define S_A4           0xA4
#define S_A5           0xA5
#define S_with         0xA6
#define S_endwith      0xA7
#define S_error        0xA8
#define S_assert       0xA9
#define S_debugout     0xAA
#define S_free         0xAB
#define S_nodefault    0xAC
#define S_mouse        0xAD
#define S_LOCAL        0xAE
#define S_LParameter   0xAF
#define S_cd           0xB0
#define S_mkdir        0xB1
#define S_rmdir        0xB2
#define S_debug        0xB3
#define S_B4           0xB4
#define S_for_each     0xB5
#define S_endfor_each  0xB6
#define S_DoEvents     0xB7
#define S_B8           0xB8
#define S_implements   0xB9
#define S_TRY          0xBA
#define S_CATCH        0xBB
#define S_FINALLY      0xBC
#define S_THROW        0xBD
#define S_ENDTRY       0xBE
#define S_DOCK         0xBF

#define ZERO           0x00
#define OPER_IN        0x01
#define OPER_VIRGULE   0x02
#define OPER_PAR       0x03
#define OPER_MULT      0x04
#define OPER_POWER     0x05
#define OPER_PLUS      0x06
#define OPER_07        0x07
#define OPER_MINUS_B   0x08
#define OPER_AND       0x09
#define OPER_NOT       0x0a
#define OPER_OR        0x0b
#define OPER_SLASH     0x0c
#define OPER_LT        0x0d
#define OPER_LE        0x0e
#define OPER_NE        0x0f
#define OPER_EQ        0x10
#define OPER_GT        0x11
#define OPER_GE        0x12
#define OPER_13        0x13
#define OPER_EQEQ      0x14
#define OPER_15        0x15
#define OPER_16        0x16
#define OPER_DOT       0x17
#define AROBAS         0x18
#define F_ABS          0x19
#define T_F_EXTEND2    0x1A
#define F_ALIAS        0x1b
#define F_ASC          0x1C
#define F_AT           0x1d
#define F_BOF          0x1e
#define F_CDOW         0x1f
#define F_CHR          0x20
#define F_CMONTH       0x21
#define F_COL          0x22
#define F_CTOD         0x23
#define F_DATE         0x24
#define F_DAY          0x25
#define F_DBF          0x26
#define F_DELETED      0x27
#define F_DISKSPACE    0x28
#define F_DOW          0x29
#define F_DTOC         0x2a
#define F_EOF          0x2b
#define F_ERROR        0x2c
#define C_FALSE        0x2d
#define F_COUNT        0x2e
#define F_FIELD        0x2f
#define F_FILE         0x30
#define F_FKLABEL      0x31
#define F_FKMAX        0x32
#define F_FLOCK        0x33
#define F_FOUND        0x34
#define F_GETENV       0x35
#define F_IIF          0x36
#define F_INKEY        0x37
#define F_INT          0x38
#define F_ISALPHA      0x39
#define F_ISCOLOR      0x3a
#define F_ISLOWER      0x3b
#define F_ISUPPER      0x3c
#define F_LEFT         0x3d
#define F_LEN          0x3e
#define F_LOCK         0x3f
#define F_LOWER        0x40
#define F_LTRIM        0x41
#define F_LUPDATE      0x42
#define T_ARG_LIST     0x43
#define F_MAX          0x44
#define F_MESSAGE      0x45
#define F_MIN          0x46
#define F_MOD          0x47
#define F_MONTH        0x48
#define F_NDX          0x49
#define F_OS           0x4a
#define F_PCOL         0x4b
#define F_PROW         0x4c
#define F_READKEY      0x4d
#define F_RECCOUNT     0x4e
#define F_RECNO        0x4f
#define F_RECSIZE      0x50
#define F_REPLICATE    0x51
#define F_RIGHT        0x52
#define F_RLOCK        0x53
#define F_ROUND        0x54
#define F_ROW          0x55
#define F_RTRIM        0x56
#define F_SELECT       0x57
#define F_SPACE        0x58
#define F_SQRT         0x59
#define F_STR          0x5a
#define F_STUFF        0x5b
#define F_SUBSTR       0x5c
#define F_Sys          0x5d
#define F_TIME         0x5e
#define F_TRANSFORM    0x5f
#define F_TRIM         0x60
#define C_TRUE         0x61
#define F_TYPE         0x62
#define OPER_MINUS_U   0x63
#define F_Updated      0x64
#define F_65           0x65
#define F_Upper        0x66
#define F_Val          0x67
#define F_VERSION      0x68
#define F_YEAR         0x69
#define F_DMY          0x6a
#define F_MDY          0x6b
#define F_BAR          0x6c
#define F_KEY          0x6d
#define F_6e           0x6e
#define F_MEMORY       0x6f
#define F_MENU         0x70
#define F_Network      0x71
#define F_PAD          0x72
#define F_POPUP        0x73
#define F_PROGRAM      0x74
#define F_PV           0x75
#define F_SET          0x76
#define F_CEILING      0x77
#define F_Fixed        0x78
#define F_Float        0x79
#define F_FLOOR        0x7A
#define F_FV           0x7B
#define F_LASTKEY      0x7C
#define F_LIKE         0x7D
#define F_LOOKUP       0x7E
#define F_CDX          0x7F
#define F_MEMLINES     0x80
#define F_MLINE        0x81
#define F_ORDER        0x82
#define F_PAYMENT      0x83
#define F_PRINTSTATUS  0x84
#define F_PROMPT       0x85
#define F_RAND         0x86
#define F_VARREAD      0x87
#define F_RollBack     0x88
#define F_RTOD         0x89
#define F_SEEK         0x8A
#define F_SIGN         0x8B
#define F_TAG          0x8C
#define F_DTOR         0x8D
#define F_DTOS         0x8E
#define F_SCHEME       0x8F
#define F_FOPEN        0x90
#define F_FCLOSE       0x91
#define F_FREAD        0x92
#define F_FWRITE       0x93
#define F_FERROR       0x94
#define F_FCREATE      0x95
#define F_FSEEK        0x96
#define F_FGETS        0x97
#define F_FFLUSH       0x98
#define F_FPUTS        0x99
#define F_9a           0x9a
#define F_ALLTRIM      0x9b
#define F_ATLINE       0x9c
#define F_CHRTRAN      0x9d
#define F_FILTER       0x9e
#define F_RELATION     0x9f
#define F_TARGET       0xa0
#define F_EMPTY        0xa1
#define F_FEOF         0xa2
#define F_HEADER       0xa3
#define F_Pack         0xa4
#define F_RAT          0xa5
#define F_RATLINE      0xa6
#define F_SECONDS      0xa7
#define F_STRTRAN      0xa8
#define F_UnPack       0xa9
#define F_USED         0xaa
#define F_BETWEEN      0xab
#define F_CHRSAW       0xac
#define F_INLIST       0xad
#define F_ISDIGIT      0xae
#define F_OCCURS       0xaf
#define F_PADC         0xB0
#define F_PADL         0xB1
#define F_PADR         0xB2
#define F_FSIZE        0xB3
#define F_SROWS        0xB4
#define F_SCOLS        0xb5
#define F_WCOLS        0xb6
#define F_WROWS        0xB7
#define F_ATC          0xB8
#define F_ATCLINE      0xb9
#define F_CURDIR       0xBA
#define F_FULLPATH     0xBB
#define F_PROPER       0xBC
#define F_WEXIST       0xBD
#define F_WONTOP       0xBE
#define F_WOUTPUT      0xBF
#define F_WVISIBLE     0xC0
#define F_GETFILE      0xC1
#define F_PUTFILE      0xC2
#define F_GOMONTH      0xC3
#define F_PARAMETERS   0xC4
#define F_MCOL         0xC5  &&
#define F_VALUES       0xC5  &&
#define F_MDOWN        0xC6
#define F_MROW         0xC7
#define F_WLCOL        0xC8
#define F_WLROW        0xC9
#define F_CA           0xCA
#define F_FCHSIZE      0xCB
#define F_CC           0xCC
#define F_ALEN         0xCD
#define F_EVALUATE     0xCE
#define F_CF           0xCF
#define F_D0           0xD0
#define F_ISNULL       0xD1
#define F_NVL          0xD2
#define F_D3           0xD3
#define F_D4           0xD4
#define F_SQL_IN       0xD5
#define F_d6           0xd6
#define F_D7           0xD7
#define F_D8           0xD8
#define C_STRING       0xD9
#define F_DA           0xDA
#define F_DB           0xDB
#define F_DC           0xDC
#define F_DD           0xDD
#define T_MONEY        0xDE
#define T_CLASSREF     0xDF
#define T_PROP         0xE0
#define T_FOXVAR_DOT   0xE1
#define T_DOT          0xE2
#define T_VAR_COLON    0xE3
#define C_NULL         0xE4
#define T_FCT_ARR_DOT  0xE5
#define T_DATETIME_    0xE6
#define T_NUMBER       0xE7
#define T_TRIPLE       0xE8
#define T_INT4         0xE9
#define T_F_EXTEND     0xEA
#define T_EB           0xEB
#define T_FOXCST       0xEC
#define T_FOXVAR       0xED
#define T_DATE_        0xEE
#define T_ef           0xEF
#define T_SKIPB1       0xf0
#define T_SKIPB2       0xf1
#define T_SKIPI1       0xf2
#define T_SKIPI2       0xf3
#define T_VAR_DOT      0xF4
#define T_LETTER_DOT   0xF5
#define T_FCT_ARR      0xF6
#define T_VAR          0xF7
#define T_BYTE         0xF8
#define T_INT2         0xF9
#define T_REAL8        0xFA
#define P_STRING       0xFB
#define T_EXPRESSION   0xFC
#define T_FD           0xFD
#define T_END_STMT     0xFE
#define T_SkipByte     0xFF


#define F_PrmPad         0x00
#define F_PrmBar         0x01
#define F_MrkPad         0x02
#define F_MrkBar         0x03
#define F_CntPad         0x04
#define F_BARCOUNT       0x05
#define F_GetPad         0x06
#define F_GetBar         0x07
#define F_MWINDOW        0x08
#define F_ObjNum         0x09
#define F_WParent        0x0A
#define F_WChild         0x0B
#define F_RdLevel        0x0C
#define F_ACopy          0x0D
#define F_AIns           0x0E
#define F_ADel           0x0F
#define F_ASort          0x10
#define F_AScan          0x11
#define F_AElement       0x12
#define F_ASubscript     0x13
#define F_AFields        0x14
#define F_ADir           0x15
#define F_LocFile        0x16
#define F_WBorder        0x17
#define F_On             0x18
#define F__19            0x19
#define F_WLast          0x1A
#define F_SkpBar         0x1B
#define F_SkpPad         0x1C
#define F_WMaximum       0x1D
#define F_WMinimum       0x1E
#define F_WRead          0x1F
#define F_WTitle         0x20
#define F_GETPEM         0x21
#define F__22            0x22
#define F_TxtWidth       0x23
#define F_FontMetric     0x24
#define F_SysMetric      0x25
#define F_WFont          0x26
#define F_GetFont        0x27
#define F_AFont          0x28
#define F_DDEAdvise      0x29
#define F_DDEEnabled     0x2A
#define F_DDEExecute     0x2B
#define F_DDEInitiate    0x2C
#define F_DDEPoke        0x2D
#define F_DDERequest     0x2E
#define F_DDESetService  0x2F
#define F_DDESetTopic    0x30
#define F_DDETerminate   0x31
#define F_DDELastError   0x32
#define F_GetDir         0x33
#define F_DDEAbortTrans  0x34
#define F_DDESetOption   0x35
#define F_OEMToAnsi      0x36
#define F_AnsiToOEM      0x37
#define F_RGBScheme      0x38
#define F_CPConvert      0x39
#define F_CPCurrent      0x3A
#define F_CPDBF          0x3B
#define F_IDXCOLLATE     0x3C
#define F_CpNoTrans      0x3D
#define F_CAPSLOCK       0x3E
#define F_NUMLOCK        0x3F
#define F_INSMODE        0x40
#define F_SOUNDEX        0x41
#define F_Difference     0x42
#define F_COS            0x43
#define F_SIN            0x44
#define F_TAN            0x45
#define F_acos           0x46
#define F_asin           0x47
#define F_atan           0x48
#define F_atn2           0x49
#define F_LOG            0x4A
#define F_LOG10          0x4B
#define F_EXP            0x4C
#define F_PI             0x4D
#define F_CreateObject   0x4E
#define F_BARPROMPT      0x4f
#define F_PadPrompt      0x50
#define F_HOME           0x51
#define F_ID             0x52
#define F_FOR            0x53
#define F_UNIQUE         0x54
#define F_DESCENDING     0x55
#define F_TAGCOUNT       0x56
#define F_TAGNO          0x57
#define F_FDATE          0x58
#define F_FTIME          0x59
#define F_ISBLANK        0x5a
#define F_ISMOUSE        0x5b
#define F_GETOBJECT      0x5c
#define F_OBJTOCLIENT    0x5d
#define F_RGB            0x5e
#define F_OLDVAL         0x5f
#define F_aSelObj        0x60
#define F_aClass         0x61
#define F_aMembers       0x62
#define F_CompObj        0x63
#define F_SQLCANCEL      0x64
#define F_SQLCOLUMNS     0x65
#define F_SQLCONNECT     0x66
#define F_SQLDISCONNECT  0x67
#define F_PEMSTATUS      0x68
#define F_SQLEXEC        0x69
#define F_SQLGETPROP     0x6a
#define F_SQLMORERESULTS 0x6b
#define F_SQLSETPROP     0x6c
#define F_SQLTABLES      0x6d
#define F_FLDLIST        0x6e
#define F_PRTINFO        0x6f
#define F_KEYMATCH       0x70
#define F_OBJVAR         0x71
#define F_NORMALIZE      0x72
#define F_ISREADONLY     0x73
#define F_PCOUNT         0x74
#define F_CHANGE         0x75
#define F_COMPLETED      0x76
#define F__77            0x77
#define F_MESSAGEBOX     0x78
#define F_aUsed          0x79
#define F_aError         0x7A
#define F_SQLCOMMIT      0x7B
#define F_SQLROLLBACK    0x7C
#define F_MTON           0x7D
#define F_NTOM           0x7E
#define F_DTOT           0x7F
#define F_TTOD           0x80
#define F_TTOC           0x81
#define F_CToT           0x82
#define F_HOUR           0x83
#define F_MINUTE         0x84
#define F_SEC            0x85
#define F_DateTime       0x86
#define F_REQUERY        0x87
#define F_CursorSetProp  0x88
#define F_CURSORGETPROP  0x89
#define F_DBSETPROP      0x8A
#define F_DBGETPROP      0x8B
#define F_GETCOLOR       0x8C
#define F_PRIMARY        0x8D
#define F_CANDIDATE      0x8E
#define F_CURVAL         0x8F
#define F_GETFLDSTATE    0x90
#define F_SETFLDSTATE    0x91
#define F_GETNEXTMODIFIED 0x92
#define F_TABLEUPDATE    0x93
#define F_TABLEREVERT    0x94
#define F_aDatabases     0x95
#define F_DBC            0x96
#define F_DbAlias        0x97
#define F_aDBObjects     0x98
#define F_aPrinters      0x99
#define F_GETPRINTER     0x9a
#define F_GETPICT        0x9b
#define F_Week           0x9c
#define F_REFRESH        0x9d
#define F_GETCP          0x9e
#define F_SQLSTRINGCONNECT 0x9f
#define F_CREATEBINARY   0xa0
#define F_DODEFAULT      0xa1
#define F_ISEXCLUSIVE    0xa2
#define F_TXNLEVEL       0xa3
#define F_DbUsed         0xa4
#define F_aInstance      0xa5
#define F_InDBC          0xa6
#define F_BitLShift      0xa7
#define F_BitRShift      0xa8
#define F_BitAnd         0xa9
#define F_BitOr          0xaa
#define F_BitNot         0xab
#define F_BitXOR         0xac
#define F_BitSet         0xad
#define F_BitTest        0xae
#define F_BitCLear       0xaf
#define F_AT_C           0xB0
#define F_ATCC           0xB1
#define F_RATC           0xB2
#define F_LEFTC          0xB3
#define F_RIGHTC         0xB4
#define F_SUBSTRC        0xb5
#define F_STUFFC         0xb6
#define F_LENC           0xB7
#define F_CHRTRANC       0xB8
#define F__b9            0xb9
#define F_LIKEC          0xBA
#define F__BB            0xBB
#define F_IMESTATUS      0xBC
#define F_ISLEADBYTE     0xBD
#define F_STRCONV        0xBE
#define F_BinToC         0xBF
#define F_CToBin         0xC0
#define F_ISFLOCKED      0xC1
#define F_ISRLOCKED      0xC2
#define F_LOADPICTURE    0xC3
#define F_SAVEPICTURE    0xC4
#define F_SQLPREPARE     0xC5
#define F_DIRECTORY      0xC6
#define F_CREATEOFFLINE  0xC7
#define F_DROPOFFLINE    0xC8
#define F_aGetClass      0xC9
#define F_aVcxClasses    0xCA
#define F_STRTOFILE      0xCB
#define F_FILETOSTR      0xCC
#define F_AddBS          0xCD
#define F_DEFAULTEXT     0xCE
#define F_DRIVETYPE      0xCF
#define F_FORCEEXT       0xD0
#define F_FORCEPATH      0xD1
#define F_JUSTDRIVE      0xD2
#define F_JUSTEXT        0xD3
#define F_JUSTFNAME      0xD4
#define F_JUSTPATH       0xD5
#define F_JUSTSTEM       0xd6
#define F_INDEXSEEK      0xD7
#define F_COMReturnError 0xD8
#define F_VarType        0xD9
#define F_aLines         0xDA
#define F_NEWOBJECT      0xDB
#define F_aMouseObj      0xDC
#define F_COMClassInfo   0xDD
#define F_GetHost        0xDE
#define F_IsHosted       0xDF
#define F_aNetResources  0xE0
#define F_aGetFileVersion 0xE1
#define F_CreateObjectEx 0xE2
#define F_COMARRAY       0xE3
#define F_EXECSCRIPT     0xE4
#define F_XmlUpdateGram  0xE5
#define F_Comprop        0xE6
#define F_aTagInfo       0xE7
#define F_aStackInfo     0xE8
#define F_EventHandler   0xE9
#define F_EDITSOURCE     0xEA
#define F_aDLLS          0xEB
#define F_QUARTER        0xEC
#define F_GETWORDCOUNT   0xED
#define F_GETWORDNUM     0xEE
#define F_aLanguage      0xEF
#define F_STREXTRACT     0xf0
#define F_INPUTBOX       0xf1
#define F_aProcInfo      0xf2
#define F_wDockable      0xf3
#define F_aSessions      0xF4
#define F_TEXTMERGE      0xF5
#define F__F6            0xF6
#define F__F7            0xF7
#define OPER_IN_SELECT   0xF8
#define F_EXISTS_SELECT  0xF9
#define F__Sum           0xFA
#define F__Avg           0xFB
#define F__Count         0xFC
#define F__Min           0xFD
#define F__Max           0xFE
#define TAG_DISTINCT     0xFF

#define F_DisplayPath    	0x00
#define F_CursorToXML    	0x01
#define F_XMLToCursor    	0x02
#define F_GetInterface   	0x03
#define F_BindEvent      	0x04
#define F_RaiseEvent     	0x05
#define F_aDockState     	0x06
#define F_GetCursorAdapter 	0x07
#define F_UnBindEvents   	0x08
#define F_aEvents        	0x09
#define F_AddProperty    	0x0A
#define F_RemoveProperty	0x0B
#define F_EVL            	0x0C
#define F___0D           	0x0D
#define F_ICase          	0x0E
#define F_Cast           	0x0F
#define F_aSQLHandles    	0x10
#define F_SetResultSet   	0x11
#define F_GetResultSet   	0x12
#define F_ClearResultSet 	0x13
#define F_SqlIdleDisconnect 0x14
#define F_IsMemoFetched  	0x15
#define F_GetAutoIncValue   0x16
#define F_MakeTransactable  0x17
#define F_IsTransactable 	0x18
#define F_IsPen  		 	0x19
#define F___1A 		 	 	0x1A
#define F___1B 		     	0x1B
#define F___1C 		     	0x1C

#define Set_alternate      0x01 
#define Set_bell           0x02 
#define Set_carry          0x03 
#define Set_century        0x05
#define Set_clear          0x06 
#define Set_color          0x07 
#define Set_confirm        0x09 
#define Set_console        0x0A 
#define Set_date           0x0B 
#define Set_debug          0x0C 
#define Set_decimals       0x0D 
#define Set_default        0x0E 
#define Set_deleted        0x0F 
#define Set_delimiters     0x10
#define Set_device         0x11 
#define Set_dohistory      0x12 
#define Set_echo           0x13 
#define Set_escape         0x15 
#define Set_exact          0x16 
#define Set_exclusive      0x17 
#define Set_fields         0x18 
#define Set_filter         0x1A 
#define Set_fixed          0x1B
#define Set_Format         0x1C 
#define Set_function       0x1D 
#define Set_headings       0x1E 
#define Set_help           0x1F
#define Set_history        0x20  
#define Set_index          0x21 
#define Set_intensity      0x22
#define Set_margin         0x23 
#define Set_memowidth      0x24 
#define Set_menu           0x25
#define Set_message        0x26 
#define Set_odometer       0x27 
#define Set_order          0x28 
#define Set_path           0x29 
#define Set_printer        0x2A 
#define Set_procedure      0x2B 
#define Set_relation       0x2D 
#define Set_safety         0x2E
#define Set_scoreboard     0x2F 
#define Set_status         0x30 
#define Set_step           0x31 
#define Set_talk           0x32 
#define Set_typeahead      0x35 
#define Set_unique         0x36 
#define Set_view           0x37 
#define Set_currency       0x38 
#define Set_hours          0x39 
#define Set_mark           0x3A 
#define Set_point          0x3B 
#define Set_separator      0x3C
#define Set_clock          0x3E 
#define Set_space          0x40 
#define Set_compatible     0x41 
#define Set_autosave       0x42 
#define Set_blocksize      0x43 
#define Set_development    0x45 
#define Set_near           0x46 
#define Set_refresh        0x48  
#define Set_lock           0x49 
#define Set_window         0x4C 
#define Set_reprocess      0x4D 
#define Set_skip           0x4E 
#define Set_skip           0x4E 
#define Set_display        0x4F 
#define Set_fullpath       0x51 
#define Set_resource       0x54 
#define Set_topic          0x55 
#define Set_topic          0x55 
#define Set_logerrors      0x57 
#define Set_sysmenu        0x59 
#define Set_notify         0x5A 
#define Set_mackey         0x5C 
#define Set_cursor         0x5D 
#define Set_udfparms       0x5E 
#define Set_multilocks     0x5F 
#define Set_textmerge      0x60 
#define Set_textmerge      0x60 
#define Set_optimize       0x61 
#define Set_library        0x62 
#define Set_ansi           0x64 
#define Set_trbetween      0x65 
#define Set_pdsetup        0x66 
#define Set_volume         0x67 
#define Set_keycomp        0x68 
#define Set_palette        0x69 
#define Set_readborder     0x6A 
#define Set_collate        0x6B 
#define Set_nocptrans      0x6D 
#define Set_null           0x77 
#define Set_key            0x79 
#define Set_cpdialog       0x7B 
#define Set_cpcompile      0x7C 
#define Set_seconds        0x7D 
#define Set_classlib       0x7E 
#define Set_database       0x7F 
#define Set_datasession    0x80 
#define Set_fdow           0x81 
#define Set_fweek          0x82 
#define Set_sysformats     0x83 
#define Set_oleobject      0x84 
#define Set_asserts        0x85 
#define Set_coverage       0x86 
#define Set_eventtracking  0x87
#define Set_nulldisplay    0x88 
#define Set_eventlist      0x89 
#define Set_debugout       0x8A 
#define Set_browseime      0x8D 
#define Set_strictdate     0x8E 
#define Set_autoincerror   0x8F 
#define Set_enginebehavior 0x90
#define Set_tablevalidate  0x91 
#define Set_sqlbuffering   0x92 

#define T_ADDITIVE        0x01
#define T_ALIAS           0x02
#define T_LEFTPAR         0x02
#define T_RIGHTPAR        0x03
#define T_ALL             0x03
#define T_ARRAY           0x04
#define T_AT              0x05
#define T_BAR             0x06
#define T_VIRGULE         0x07
#define T_BLANK           0x08
#define T_ENDMACRO        0x0A  &&
#define T_NOT             0x0A  &&
#define T_DATE_Token      0x0B  && T_DATE and T_DATE_ already exist
#define T_CLEAR           0x0C
#define T_COLOR           0x0D
#define T_DEFAULT         0x0E  &&
#define T_DOUBLE_         0x0F	&& T_DOUBLE already in FoxPro.h
#define T_ASSIGN          0x10  &&
#define T_ERROR           0x10  &&
#define T_FIELD           0x11
#define T_FIELDS          0x11
#define T_FILE            0x12
#define T_FILES           0x12
#define T_FOR             0x13
#define T_FORM            0x14  && 
#define T_FORMAT          0x14  && 
#define T_FROM            0x15
#define T_IN              0x16
#define T_KEY             0x17
#define T_LIKE            0x18  &&
#define T_AROBAS          0x18  && 
#define T_LOCK            0x19  
#define T_MACRO           0x1A
#define T_MACROS          0x1A
#define T_MEMO_           0x1B  && T_MEMO already in FoxPro.h
#define T_MEMORY          0x1B  &&
#define T_MENU            0x1C  &&
#define T_MENUS           0x1C  &&
#define T_MESSAGE         0x1D
#define T_NEXT            0x1E
#define T_OFF             0x1F 
#define T_ON              0x20
#define T_PRINT           0x21
#define T_PRINTER         0x21
#define T_PROMPT          0x22
#define T_RECORD          0x23
#define T_REST            0x24
#define T_SAVE            0x25
#define T_FORM_C          0x26
#define T_FORMSCREEN      0x26  &&
#define T_SCREEN_         0x26  && T_SCREEN already in FoxPro.h
#define T_TITLE           0x27  
#define T_TO              0x28
#define T_TOP             0x29
#define T_VALID           0x2A  &&
#define T_VALIDATE        0x2A  &&
#define T_WHILE           0x2B
#define T_WINDOW          0x2C  &&
#define T_WINDOWS         0x2C  &&
#define T_RELATION        0x2D
#define T_AFTER           0x2D
#define T_OBJECT_         0x2E  && T_OBJECT already in FoxPro.h
#define T_OBJECTS         0x2E
#define T_NOOPTIMIZE      0x30
#define T_DBF             0x31
#define T_TABLE           0x31  &&
#define T_TABLES          0x31  &&
#define T_LABEL           0x32
#define T_REPORT          0x33
#define T_EDIT            0x34
#define T_BOTTOM          0x36
#define T_BOX             0x37
#define T_BY              0x38
#define T_NOCONSOLE       0x39
#define T_NOWAIT          0x3A
#define T_PLAIN           0x3B
#define T_DESCENDING      0x3C
#define T_FONT            0x40
#define T_STYLE           0x41
#define T_RGB             0x42
#define T_PEN             0x43
#define T_PATTERN         0x44
#define T_CASE            0x48
#define T_NAME            0x4A
#define T_PROGRAM         0x4B
#define T_QUERY           0x4C
#define T_SCHEME          0x4E
#define T_CLASS           0x4F
#define T_NOLGRID         0x50
#define T_AS              0x51
#define T_CLASSLIB        0x52
#define T_LINKED          0x53
#define T_NEGOTIATE       0x54
#define T_MIDDLE          0x55
#define T_DLLS            0x56
#define T_SHORT           0x57
#define T_SHORTCUT        0x57
#define T_LEFT            0x58
#define T_RIGHT           0x59
#define T_RTLJUSTIFY      0x5B
#define T_LTRJUSTIFY      0x5C
#define T_NOPROJECTHOOK   0x5D
#define T_PICTRES         0x5F
#define T_MRU             0x60
#define T_INVERT          0x61
#define T_POSITION        0x64
#define T_NODIALOG        0x65
#define T_COLLATE         0x6B
#define T_SELECT          0x6F
#define T_CODEPAGE        0xBA  &&
#define T_XL8             0xBA  &&
#define T_XL5             0xBB
#define T_WITH_BUFF       0xBB
#define T_ACTIVATE        0xBC  &&
#define T_AGAIN           0xBC  &&
#define T_ALTER           0xBC  && 
#define T_ALTERNATE       0xBC  &&
#define T_AUTO            0xBC 
#define T_AUTOMATIC       0xBC
#define T_AVG             0xBC  &&
#define T_COLONV          0xBC
#define T_COMMAND         0xBC  &&
#define T_ENCRYPT         0xBC  &&
#define T_EXCEPT          0xBC  && 
#define T_EXCLUSIVE       0xBC  && 
#define T_INTO            0xBC  && 
#define T_MASTER          0xBC  && 
#define T_APP             0xBD 
#define T_PAD             0xBC  &&  
#define T_ASCENDING       0xBD  &&
#define T_CENTER          0xBD  &&
#define T_CNT             0xBD  &&
#define T_COLONW          0xBD
#define T_CURSOR          0xBD  &&
#define T_ENVIRONMENT     0xBD
#define T_ESCAPE          0xBD  &&
#define T_FOXPLUS         0xBD
#define T_MINIMIZE        0xBD  &&
#define T_NOCPTRANS       0xBD  &&
#define T_NOLINK          0xBD
#define T_TRANSACTION     0xBD  &&
#define T_EXE             0xBE
#define T_BEFORE          0xBE  &&
#define T_CLOSE           0xBE  &&
#define T_COLONE          0xBE
#define T_CYCLE           0xBE  &&
#define T_DELIMITED       0xBE  && 
#define T_DISTINCT        0xBE  &&
#define T_DOS             0xBE  &&
#define T_LINK            0xBE  &&
#define T_NOUPDATE        0xBE  &&
#define T_NOREAD          0xBE  &&
#define T_NUMBER_         0xBE
#define T_MAX             0xBE  && 
#define T_PAGE            0xBE  &&
#define T_PROCEDURE       0xBE  && 
#define T_PROCEDURES      0xBE  && 
#define T_SPINNER         0xBE  &&
#define T_CHARACTER_      0xBF  && FoxPro.h
#define T_COLONH          0xBF
#define T_COMPACT         0xBF  &&
#define T_DIF             0xBF  &&
#define T_DISABLE         0xBF  && 
#define T_FLOAT           0xBF  &&
#define T_GROUP_BY        0xBF  &&
#define T_HEADING         0xBF
#define T_LIBRARY         0xBF  &&
#define T_MIN             0xBF  &&
#define T_RENAME          0xBF  &&
#define T_ADD             0xC0  &&
#define T_DEACTIVATE      0xC0  && 
#define T_EXTENDED        0xC0  && 
#define T_FREE            0xC0  &&
#define T_FREEZE          0xC0
#define T_FOOTER          0xC0  &&
#define T_FUNCTION        0xC0  &&
#define T_HAVING          0xC0  &&
#define T_NPV             0xC0  &&
#define T_GET             0xC1  && 
#define T_GROW            0xC1  &&
#define T_INDEX           0xC1  && 
#define T_INDEXES         0xC1  && 
#define T_LINE            0xC1  &&
#define T_NOAPPEND        0xC1
#define T_PREVIEW         0xC1
#define T_STD             0xC1  &&
#define T_TRIGGER         0xC1
#define T_COLONP          0xC2
#define T_DATA            0xC2  &&
#define T_DATABASE        0xC2  && 
#define T_DATABASES       0xC2  && 
#define T_DROP            0xC2  &&
#define T_FOXOBJECT       0xC2  &&
#define T_GETS            0xC2  &&
#define T_HALFHEIGH       0xC2  && 
#define T_MEMVAR          0xC2  &&
#define T_NOINIT          0xC2  &&
#define T_PICTURE         0xC2  && 
#define T_RANDOM          0xC2
#define T_SHARE           0xC2  && 
#define T_SHARED          0xC2  && 
#define T_SUM             0xC2  &&
#define T_ASCII           0xC3
#define T_CLICK           0xC3
#define T_OF              0xC3  && 
#define T_ORDER_TAG       0xC3  &&
#define T_ORDER_BY        0xC3  &&
#define T_LEVEL           0xC3  &&
#define T_NOCLOSE         0xC3  &&
#define T_NOREFRESH       0xC3
#define T_REPLACE         0xC3
#define T_SYLK            0xC3  &&
#define T_VAR_            0xC3  &&
#define T_ICON            0xC4  &&
#define T_SAY             0xC4  &&
#define T_UNION           0xC4  &&
#define T_VIEW            0xC4  &&
#define T_VIEWS           0xC4  
#define T_RECYCLE         0xC4  &&
#define T_NODEBUG         0xC4  &&
#define T_NODELETE        0xC4
#define T_NOEJECT         0xC4
#define T_ONLY            0xC4  &&
#define T_REFRESH         0xC4  &&
#define T_MOD             0xC4  &&
#define T_TAB             0xC4  &&
#define T_DBLCLICK        0xC5
#define T_ISOMETRIC       0xC5  &&
#define T_PROJECT         0xC5  &&
#define T_NOEDIT          0xC5  &&
#define T_VALUES          0xC5  &&
#define T_WK1             0xC5  && 
#define T_OVERWRITE       0xC5  &&
#define T_NOMODIFY        0xC5  &&
#define T_COLONF          0xC6
#define T_DLL             0xC6 
#define T_EXCLUDE         0xC6
#define T_DRAG            0xC6
#define T_NOCAPTIONS      0xC6  &&
#define T_NOFLOAT         0xC6  &&
#define T_NOOVERWRITE     0xC6
#define T_POPUP           0xC6  &&
#define T_POPUPS          0xC6  &&
#define T_WHERE           0xC6  &&
#define T_WKS             0xC6  &&
#define T_ALT             0xC7
#define T_COLONB          0xC7
#define T_MARK            0xC7
#define T_MDI             0xC7  &&
#define T_STAR            0xC7  &&
#define T_STEP            0xC7  &&
#define T_RANGE           0xC7  &&
#define T_XLS             0xC7  &&
#define T_COLONR          0xC8
#define T_DATASOURCE      0xC8
#define T_MARGIN          0xC8
#define T_MTDLL           0xC8
#define T_NOGROW          0xC8  &&
#define T_PERCENT         0xC8  &&
#define T_READ            0xC8  &&
#define T_RECOVER         0xC8
#define T_RPD             0xC8  &&
#define T_SHIFT           0xC8
#define T_STRETCH         0xC8  &&
#define T_COLON           0xC9
#define T_CONTROL         0xC9
#define T_FW2             0xC9  &&
#define T_NOMDI           0xC9  &&
#define T_REFERENCES      0xC9  &&
#define T_SKIP            0xC9
#define T_DEBUG           0xCA  &&
#define T_DEBUGGER        0xCA  &&
#define T_FORCE           0XCA  &&
#define T_NOMENU          0xCA  &&
#define T_NOMINIMIZE      0xCA  &&
#define T_PASSWORD        0xCA
#define T_PIXELS          0xCA
#define T_SET             0xCA  &&
#define T_SHOW            0xCA  &&
#define T_TAG             0xCA  &&
#define T_WR1             0xCA  &&
#define T_BINARY          0xCB  &&
#define T_LPARTITION      0xCB
#define T_NOMOUSE         0xCB  &&
#define T_NONE            0xCB  &&
#define T_PRIMARY         0xCB  &&
#define T_RECOMPILE       0xCB
#define T_STATUS          0xCB
#define T_USERID          0xCB
#define T_WRK             0xCB  &&
#define T_FOREIGN         0xCC  &&
#define T_PROTECTED       0xCC  &&
#define T_QUESTIONMARK    0xCC
#define T_RELATIVE        0xCC 
#define T_RESOURCES       0xCC  &&
#define T_STRUCTURE       0xCC  &&
#define T_CHECK           0xCD  &&
#define T_DELETE          0xCD
#define T_DELETETABLES    0xCD  &&
#define T_NORGRID         0xCD
#define T_SHUTDOWN        0xCD  &&
#define T_WK3             0xCD  &&
#define T_NOSAVE          0xCD
#define T_FOX2X           0xCE
#define T_NOSHOW          0xCE  &&
#define T_SCROLL          0xCE  &&
#define T_SUMMARY         0xCE
#define T_TIME            0xCE
#define T_TIMEOUT         0xCE  &&
#define T_UPDATE          0xCE
#define T_SAME            0xCF  &&
#define T_LEDIT           0xCF
#define T_PDOX            0xCF  &&
#define T_SHADOW          0xCF  &&
#define T_CONNSTRING      0xD0
#define T_MODAL           0xD0  &&
#define T_NOCLEAR         0xD0  &&
#define T_PANEL           0xD0  &&
#define T_PDSETUP         0xD0
#define T_SDF             0xD0  &&
#define T_SELECTION       0xD0  &&
#define T_BITMAP          0xD1  && 
#define T_WITH            0xD1  &&
#define T_CONNECTION      0xD1  &&
#define T_CONNECTIONS     0xD1  &&
#define T_INTEGER_        0xD1  && FoxPro.h
#define T_OPEN            0xD1  &&
#define T_NOZOOM          0xD1  &&
#define T_PREFERENCE      0xD1  && 
#define T_JOIN            0xD2  &&
#define T_NOVALIDATE      0xD2  && 
#define T_PRODUCTION      0xD2  &&
#define T_REMOTE          0xD2
#define T_SINGLE          0xD2  &&
#define T_VERB            0xD2  &&
#define T_WHEN            0xD2  &&
#define T_SIZE            0xD3  && 
#define T_FULL            0xD3  &&
#define T_REDIT           0xD3
#define T_UNIQUE          0xD3  &&
#define T_CANDIDATE       0xD4  &&
#define T_INNER           0xD4  &&
#define T_LONG            0xD4  &&
#define T_NEXTVALUE       0xD4  &&
#define T_SYSTEM          0xD4  &&
#define T_TYPE            0xD4  &&
#define T_TYPEAHEAD       0xD4  &&
#define T_WIDTH           0xD4
#define T_COLUMN          0xD5  &&
#define T_CSV             0xD5  &&
#define T_EVENTS          0xD5  &&
#define T_GENERAL_        0xD5  && FoxPro.h
#define T_NOPAGEEJECT     0xD5
#define T_PARTITION       0xD5
#define T_WRAP            0xD5
#define T_ZOOM            0xD5  &&
#define T_ENABLE          0xD6  &&
#define T_FILL            0xD6  &&
#define T_INSERT          0xD6
#define T_NORESET         0xD6
#define T_NORM            0xD6
#define T_NORMAL          0xD6
#define T_NULL            0xD6  &&
#define T_SHEET           0xD6  &&
#define T_STRING          0xD6  &&
#define T_VIEW_C          0xD6  && for create, it's different for modify and list
#define T_AUTOINC         0xD8  
#define T_EXTRAINFO       0xF9

#define V_ALIGNMENT    0x00
#define V_BOX          0x01
#define V_INDENT       0x02
#define V_LMARGIN      0x03
#define V_PADVANCE     0x04
#define V_PAGENO       0x05
#define V_PBPAGE       0x06
#define V_PCOLNO       0x07
#define V_PCOPIES      0x08
#define V_PDRIVER      0x09
#define V_PECODE       0x0A
#define V_PEJECT       0x0B
#define V_PEPAGE       0x0C
#define V_PLENGTH      0x0E
#define V_PLINENO      0x0F
#define V_PLOFFSET     0x10
#define V_PPITCH       0x11
#define V_PQUALITY     0x12
#define V_PSCODE       0x13
#define V_PSPACING     0x14
#define V_PWAIT        0x15
#define V_RMARGIN      0x16
#define V_TABS         0x17
#define V_WRAP         0x18  
#define V_DBLCLICK     0x19
#define V_CALCVALUE    0x1A
#define V_CALCMEM      0x1B
#define V_DIARYDATE    0x1C
#define V_CLIPTEXT     0x1D
#define V_TEXT         0x1E
#define V_PRETEXT      0x1F
#define V_TALLY        0x20
#define V_CUROBJ       0x21
#define V_MLINE        0x22
#define V_THROTTLE     0x23
#define V_GENMENU      0x24
#define V_GENSCRN      0x25
#define V_GENGRAPH     0x26
#define V_GENPD        0x27
#define V_PDSETUP      0x28
#define V_GENXTAB      0x29
#define V_FOXDOC       0x2A
#define V_STARTUP      0x2F
#define V_TRANSPORT    0x30
#define V_BEAUTIFY     0x31  
#define V_DOS          0x32
#define V_MAC          0x33
#define V_UNIX         0x34
#define V_WINDOWS      0x35
#define V_SPELLCHK     0x36
#define V_SHELL        0x37
#define V_ASSIST       0x38
#define V_SCREEN       0x39 
#define V_BUILDER      0x3A
#define V_CONVERTER    0x3B
#define V_WIZARD       0x3C
#define V_TRIGGERLEVEL 0x3D
#define V_ASCIICOLS    0x3E
#define V_ASCIIROWS    0x3F
#define V_BROWSER      0x40
#define V_SCCTEXT      0x41
#define V_COVERAGE     0x42
#define V_VFP          0x43
#define V_GALLERY      0x44
#define V_GETEXPR      0x45
#define V_INCLUDE      0x46
#define V_GENHTML      0x47
#define V_SAMPLES      0x49
#define V_INCSEEK      0x50
#define V_PAGETOTAL    0x51
#define V_FOXREF       0x52
#define V_TOOLBOX      0x53
#define V_TASKPANE     0x54  
                            
#define m_mfirst                    0x00                         
#define m_mlast                     0x01
#define m_msysmenu                  0x02
#define m_msm_systm                 0x03
#define m_msm_file                  0x04
#define m_msm_edit                  0x05
#define m_msm_data                  0x06
#define m_msm_recrd                 0x07
#define m_msm_prog                  0x08
#define m_msm_windo                 0x09
#define m_msm_view                  0x0A
#define m_msm_tools                 0x0B
#define m_msm_format                0x0C
#define m_msystem                   0x0D
#define m_mst_office                0x0E
#define m_mst_help                  0x0F
#define m_mst_hpsch                 0x10
#define m_mst_hphow                 0x11
#define m_mst_macro                 0x12
#define m_mst_sp100                 0x13
#define m_mst_filer                 0x14
#define m_mst_calcu                 0x15
#define m_mst_diary                 0x16
#define m_mst_specl                 0x17
#define m_mst_ascii                 0x18
#define m_mst_captr                 0x19
#define m_mst_puzzl                 0x1A
#define m_mst_sp200                 0x1B
#define m_mst_dbase                 0x1C
#define m_mst_sp300                 0x1D
#define m_mst_techs                 0x1E
#define m_mst_about                 0x1F
#define m_mst_docum                 0x20
#define m_mst_samp                  0x21
#define m_mst_vfpweb                0x22
#define m_mfile                     0x23
#define m_mfi_new                   0x24
#define m_mfi_open                  0x25
#define m_mfi_close                 0x26
#define m_mfi_clall                 0x27
#define m_mfi_sp100                 0x28
#define m_mfi_save                  0x29
#define m_mfi_savas                 0x2A
#define m_mfi_revrt                 0x2B
#define m_mfi_sp200                 0x2C
#define m_mfi_setup                 0x2D
#define m_mfi_print                 0x2E
#define m_mfi_sysprint              0x2F
#define m_mfi_printonecopy          0x30
#define m_mfi_sp300                 0x31
#define m_mfi_quit                  0x32
#define m_mfi_prevu                 0x33
#define m_mfi_pgset                 0x34
#define m_mfi_import                0x35
#define m_mfi_export                0x36
#define m_mfi_sp400                 0x37
#define m_mfi_send                  0x38
#define m_medit                     0x39
#define m_med_undo                  0x3A
#define m_med_redo                  0x3B
#define m_med_sp100                 0x3C
#define m_med_cut                   0x3D
#define m_med_copy                  0x3E
#define m_med_paste                 0x3F
#define m_med_pstlk                 0x40
#define m_med_clear                 0x41
#define m_med_sp200                 0x42
#define m_med_insob                 0x43
#define m_med_obj                   0x44
#define m_med_link                  0x45
#define m_med_cvtst                 0x46
#define m_med_sp300                 0x47
#define m_med_slcta                 0x48
#define m_med_sp400                 0x49
#define m_med_goto                  0x4A
#define m_med_find                  0x4B
#define m_med_finda                 0x4C
#define m_med_repl                  0x4D
#define m_med_repla                 0x4E
#define m_med_sp500                 0x4F
#define m_med_beaut                 0x50
#define m_med_pref                  0x51
#define m_mdata                     0x52
#define m_mda_setup                 0x53
#define m_mda_brow                  0x54
#define m_mda_sp100                 0x55
#define m_mda_appnd                 0x56
#define m_mda_copy                  0x57
#define m_mda_sort                  0x58
#define m_mda_total                 0x59
#define m_mda_sp200                 0x5A
#define m_mda_avg                   0x5B
#define m_mda_count                 0x5C
#define m_mda_sum                   0x5D
#define m_mda_calc                  0x5E
#define m_mda_reprt                 0x5F
#define m_mda_label                 0x60
#define m_mda_sp300                 0x61
#define m_mda_pack                  0x62
#define m_mda_rindx                 0x63
#define m_mrecord                   0x64
#define m_mrc_appnd                 0x65
#define m_mrc_chnge                 0x66
#define m_mrc_sp100                 0x67
#define m_mrc_goto                  0x68
#define m_mrc_locat                 0x69
#define m_mrc_cont                  0x6A
#define m_mrc_seek                  0x6B
#define m_mrc_sp200                 0x6C
#define m_mrc_repl                  0x6D
#define m_mrc_delet                 0x6E
#define m_mrc_recal                 0x6F
#define m_mprog                     0x70
#define m_mpr_do                    0x71
#define m_mpr_sp100                 0x72
#define m_mpr_cancl                 0x73
#define m_mpr_resum                 0x74
#define m_mpr_sp200                 0x75
#define m_mpr_compl                 0x76
#define m_mpr_gener                 0x77
#define m_mpr_sp300                 0x78
#define m_mpr_beaut                 0x79
#define m_mpr_docum                 0x7A
#define m_mpr_graph                 0x7B
#define m_mpr_suspend               0x7C
#define m_mwindow                   0x7D
#define m_mwi_arran                 0x7E
#define m_mwi_hide                  0x7F
#define m_mwi_hidea                 0x80
#define m_mwi_showa                 0x81
#define m_mwi_clear                 0x82
#define m_mwi_sp100                 0x83
#define m_mwi_move                  0x84
#define m_mwi_size                  0x85
#define m_mwi_zoom                  0x86
#define m_mwi_min                   0x87
#define m_mwi_rotat                 0x88
#define m_mwi_color                 0x89
#define m_mwi_sp200                 0x8A
#define m_mwi_cmd                   0x8B
#define m_mwi_view                  0x8C
#define m_mvi_toolb                 0x8D
#define m_mvi_toolb                 0x8D
#define m_mview                     0x8E
#define m_mtools                    0x90
#define m_mtl_wzrds                 0x91
#define m_mtl_sp100                 0x92
#define m_mtl_sp200                 0x93
#define m_mtl_sp300                 0x94
#define m_mtl_sp400                 0x95
#define m_mtl_optns                 0x96
#define m_mtl_browser               0x97
#define m_mti_foxcode               0x98
#define m_mtl_debugger              0x99
#define m_mti_trace                 0x9A
#define m_mwi_trace                 0x9B
#define m_mti_watch                 0x9C
#define m_mwi_debug                 0x9D
#define m_mti_locals                0x9E
#define m_mti_dbgout                0x9F
#define m_mti_callstack             0xA0
#define m_mreport                   0xA1
#define m_mlabel                    0xA2
#define m_mbrowse                   0xA3
#define m_mbr_mode                  0xA4
#define m_mbr_grid                  0xA5
#define m_mbr_link                  0xA6
#define m_mbr_cpart                 0xA7
#define m_mbr_sp100                 0xA8
#define m_mbr_font                  0xA9
#define m_mbr_szfld                 0xAA
#define m_mbr_mvfld                 0xAB
#define m_mbr_mvprt                 0xAC
#define m_mbr_sp200                 0xAD
#define m_mbr_goto                  0xAE
#define m_mbr_seek                  0xAF
#define m_mbr_delet                 0xB0
#define m_mbr_appnd                 0xB1
#define m_mmacro                    0xB2
#define m_mdiary                    0xB3
#define m_mfiler                    0xB4
#define m_mscreen                   0xB5
#define m_mmbldr                    0xB6
#define m_mmb_gopts                 0xB7
#define m_mmb_mopts                 0xB8
#define m_mmb_sp100                 0xB9
#define m_mmb_prevu                 0xBA
#define m_mmb_sp200                 0xBB
#define m_mmb_insrt                 0xBC
#define m_mmb_insbr                 0xBD
#define m_mmb_delet                 0xBE
#define m_mmb_sp300                 0xBF
#define m_mmb_quick                 0xC0
#define m_mmb_gener                 0xC1
#define m_mproj                     0xC2
#define m_mrqbe                     0xC3
#define m_msm_text                  0xC4
#define m_mwizards                  0xC5
#define m_mwz_table                 0xC6
#define m_mwz_query                 0xC7
#define m_mwz_form                  0xC8
#define m_mwz_reprt                 0xC9
#define m_mwz_label                 0xCA
#define m_mwz_mail                  0xCB
#define m_mwz_pivot                 0xCC
#define m_mwz_import                0xCD
#define m_mwz_foxdoc                0xCE
#define m_mwz_upsizing              0xCF
#define m_mwz_all                   0xD0
#define m_mtable                    0xD1
#define m_mtb_props                 0xD2
#define m_mtb_sp100                 0xD3
#define m_mtb_goto                  0xD4
#define m_mtb_appnd                 0xD5
#define m_mtb_delrc                 0xD6
#define m_mtb_sp200                 0xD7
#define m_mtb_delet                 0xD8
#define m_mtb_recal                 0xD9
#define m_mtb_szfld                 0xDA
#define m_mtb_mvfld                 0xDB
#define m_mtb_mvprt                 0xDC
#define m_mtb_sp300                 0xDD
#define m_mtb_link                  0xDE
#define m_mtb_cpart                 0xDF
#define m_mtb_sp400                 0xE0
#define m_0xe1                      0xE1
#define m_mfi_saveashtml            0xE2
#define m_0xe3                      0xE3
#define m_mst_msdnc                 0xE4
#define m_mst_msdni                 0xE5
#define m_mst_msdns                 0xE6
#define m_0xe7                      0xE7
#define m_mwz_application           0xE8
#define m_mwz_database              0xE9
#define m_mwz_webpublishing         0xEA
#define m_mwz_webservices           0xEB
#define m_0xec                      0xEC
#define m_mtl_gallery               0xED
#define m_mtl_coverage              0xEE
#define m_mti_tasklist              0xEF
#define m_mti_objectbrowser         0xF0
#define m_mti_docview               0xF1
#define m_mti_breakpoint            0xF2
#define m_0xf3                      0xF3
#define m_med_listmembers           0xF4
#define m_med_quickinfo             0xF5
#define m_med_bkmks                 0xF6
#define m_0xf7                      0xF7
#define m_mbk_togtask               0xF8
#define m_mbk_togbkmk               0xF9
#define m_mbk_bkmknext              0xFA
#define m_mbk_bkmkprev              0xFB
#define m_0xfc                      0xFC
#define m_mwi_cascade               0xFD
#define m_mwi_dockable              0xFE
#define m_escape                    0xFF
                                 
#define m_mwi_propertiesfe   0x00
#define m_Ext_0x01           0x01
#define m_mmb_moveitmfe      0x02
#define m_Ext_0x03           0x03
#define m_Ext_0x04           0x04
#define m_mtl_taskpanefe     0x05
#define m_mtl_toolboxfe      0x06
#define m_mtl_references     0x07

              