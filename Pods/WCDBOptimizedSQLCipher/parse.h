#define TK_SEMI                             1
#define TK_EXPLAIN                          2
#define TK_QUERY                            3
#define TK_PLAN                             4
#define TK_BEGIN                            5
#define TK_TRANSACTION                      6
#define TK_DEFERRED                         7
#define TK_IMMEDIATE                        8
#define TK_EXCLUSIVE                        9
#define TK_COMMIT                          10
#define TK_END                             11
#define TK_ROLLBACK                        12
#define TK_SAVEPOINT                       13
#define TK_RELEASE                         14
#define TK_TO                              15
#define TK_TABLE                           16
#define TK_CREATE                          17
#define TK_IF                              18
#define TK_NOT                             19
#define TK_EXISTS                          20
#define TK_TEMP                            21
#define TK_LP                              22
#define TK_RP                              23
#define TK_AS                              24
#define TK_WITHOUT                         25
#define TK_COMMA                           26
#define TK_ABORT                           27
#define TK_ACTION                          28
#define TK_AFTER                           29
#define TK_ANALYZE                         30
#define TK_ASC                             31
#define TK_ATTACH                          32
#define TK_BEFORE                          33
#define TK_BY                              34
#define TK_CASCADE                         35
#define TK_CAST                            36
#define TK_CONFLICT                        37
#define TK_DATABASE                        38
#define TK_DESC                            39
#define TK_DETACH                          40
#define TK_EACH                            41
#define TK_FAIL                            42
#define TK_OR                              43
#define TK_AND                             44
#define TK_IS                              45
#define TK_MATCH                           46
#define TK_LIKE_KW                         47
#define TK_BETWEEN                         48
#define TK_IN                              49
#define TK_ISNULL                          50
#define TK_NOTNULL                         51
#define TK_NE                              52
#define TK_EQ                              53
#define TK_GT                              54
#define TK_LE                              55
#define TK_LT                              56
#define TK_GE                              57
#define TK_ESCAPE                          58
#define TK_ID                              59
#define TK_COLUMNKW                        60
#define TK_DO                              61
#define TK_FOR                             62
#define TK_IGNORE                          63
#define TK_INITIALLY                       64
#define TK_INSTEAD                         65
#define TK_NO                              66
#define TK_KEY                             67
#define TK_OF                              68
#define TK_OFFSET                          69
#define TK_PRAGMA                          70
#define TK_RAISE                           71
#define TK_RECURSIVE                       72
#define TK_REPLACE                         73
#define TK_RESTRICT                        74
#define TK_ROW                             75
#define TK_ROWS                            76
#define TK_TRIGGER                         77
#define TK_VACUUM                          78
#define TK_VIEW                            79
#define TK_VIRTUAL                         80
#define TK_WITH                            81
#define TK_CURRENT                         82
#define TK_FOLLOWING                       83
#define TK_PARTITION                       84
#define TK_PRECEDING                       85
#define TK_RANGE                           86
#define TK_UNBOUNDED                       87
#define TK_REINDEX                         88
#define TK_RENAME                          89
#define TK_CTIME_KW                        90
#define TK_ANY                             91
#define TK_BITAND                          92
#define TK_BITOR                           93
#define TK_LSHIFT                          94
#define TK_RSHIFT                          95
#define TK_PLUS                            96
#define TK_MINUS                           97
#define TK_STAR                            98
#define TK_SLASH                           99
#define TK_REM                            100
#define TK_CONCAT                         101
#define TK_COLLATE                        102
#define TK_BITNOT                         103
#define TK_ON                             104
#define TK_INDEXED                        105
#define TK_STRING                         106
#define TK_JOIN_KW                        107
#define TK_CONSTRAINT                     108
#define TK_DEFAULT                        109
#define TK_NULL                           110
#define TK_PRIMARY                        111
#define TK_UNIQUE                         112
#define TK_CHECK                          113
#define TK_REFERENCES                     114
#define TK_AUTOINCR                       115
#define TK_INSERT                         116
#define TK_DELETE                         117
#define TK_UPDATE                         118
#define TK_SET                            119
#define TK_DEFERRABLE                     120
#define TK_FOREIGN                        121
#define TK_DROP                           122
#define TK_UNION                          123
#define TK_ALL                            124
#define TK_EXCEPT                         125
#define TK_INTERSECT                      126
#define TK_SELECT                         127
#define TK_VALUES                         128
#define TK_DISTINCT                       129
#define TK_DOT                            130
#define TK_FROM                           131
#define TK_JOIN                           132
#define TK_USING                          133
#define TK_ORDER                          134
#define TK_GROUP                          135
#define TK_HAVING                         136
#define TK_LIMIT                          137
#define TK_WHERE                          138
#define TK_INTO                           139
#define TK_NOTHING                        140
#define TK_FLOAT                          141
#define TK_BLOB                           142
#define TK_INTEGER                        143
#define TK_VARIABLE                       144
#define TK_CASE                           145
#define TK_WHEN                           146
#define TK_THEN                           147
#define TK_ELSE                           148
#define TK_INDEX                          149
#define TK_ALTER                          150
#define TK_ADD                            151
#define TK_WINDOW                         152
#define TK_OVER                           153
#define TK_FILTER                         154
#define TK_TRUEFALSE                      155
#define TK_ISNOT                          156
#define TK_FUNCTION                       157
#define TK_COLUMN                         158
#define TK_AGG_FUNCTION                   159
#define TK_AGG_COLUMN                     160
#define TK_UMINUS                         161
#define TK_UPLUS                          162
#define TK_TRUTH                          163
#define TK_REGISTER                       164
#define TK_VECTOR                         165
#define TK_SELECT_COLUMN                  166
#define TK_IF_NULL_ROW                    167
#define TK_ASTERISK                       168
#define TK_SPAN                           169
#define TK_END_OF_FILE                    170
#define TK_UNCLOSED_STRING                171
#define TK_SPACE                          172
#define TK_ILLEGAL                        173

/* The token codes above must all fit in 8 bits */
#define TKFLG_MASK           0xff  

/* Flags that can be added to a token code when it is not
** being stored in a u8: */
#define TKFLG_DONTFOLD       0x100  /* Omit constant folding optimizations */
