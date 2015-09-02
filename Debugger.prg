#include "protheus.ch"
#define TOKEN ""
#xtranslate @Token { <name> <value> } => Eval( T_<name>, <value> )
#xtranslate @Instance <name> <value> => T_<name> := <value>
#xtranslate @Next => Context++
#xtranslate @Previous => Context--

Function Debugger( xVar, aParser )
  Local cExprResult
  Static Context    := 0

  @Instance KEYWORD    aParser[ 1 ]
  @Instance NUMBER     aParser[ 2 ]
  @Instance STRING     aParser[ 3 ]
  @Instance INDENT     aParser[ 4 ]
  @Instance SYMBOL     aParser[ 5 ]
  @Instance NEWLINE    aParser[ 6 ]
  @Instance DATE       aParser[ 7 ]
  @Instance TRUE       aParser[ 8 ]
  @Instance FALSE      aParser[ 9 ]
  @Instance NIL        aParser[ 10 ]
  @Instance BLOCK      aParser[ 11 ]
  @Instance PROPERTY   aParser[ 12 ]
  @Instance OBJECT     aParser[ 13 ]
  @Instance UNKNOWN    aParser[ 14 ]
  @Instance NAME       aParser[ 15 ]
  @Instance DEDENT     aParser[ 16 ]
  @Instance FOLDER     aParser[ 17 ]
  @Instance BEGIN_CLOS aParser[ 18 ]
  @Instance END_CLOS   aParser[ 19 ]

  cExprResult := ParseExpr( xVar )
  ConOut( cExprResult )
  Return cExprResult

Static Function ParseExpr( xVar )
  Local cType := ValType( xVar )

  Do Case
    Case cType == "C" // String
      Return ParseString( xVar )
    Case cType == "N" // Number
      Return ParseNumber( xVar )
    Case cType == "A" // Array
      Return ParseArray( xVar )
    Case cType == "U" // Nil
      Return ParseNil( xVar )
    Case cType == "D" // Date
      Return ParseDate( xVar )
    Case cType == "B" // Block
      Return ParseBlock( xVar )
    Case cType == "O" // Object
      Return ParseObject( xVar )
    Case cType == "L" // Logic
      If xVar
        Return ParseTrue()
      Else
        Return ParseFalse()
      EndIf
    Otherwise
      Return ParseUnknown( xVar )
  EndCase
  Return

Static Function ParseString( cData )
  Return @Token { KEYWORD "string"                       } ;
       + @Token { SYMBOL  "<"                            } ;
       + @Token { NUMBER  AllTrim( Str( Len( cData ) ) ) } ;
       + @Token { SYMBOL  ">"                            } ;
       + @Token { SYMBOL  "("                            } ;
       + @Token { STRING  cData                          } ;
       + @Token { SYMBOL  ")"                            } ;
       + @Token { NEWLINE TOKEN                          }

Static Function ParseNumber( nData )
  Return @Token { KEYWORD "number"                } ;
       + @Token { SYMBOL  "("                     } ;
       + @Token { NUMBER  AllTrim( Str( nData ) ) } ;
       + @Token { SYMBOL  ")"                     } ;
       + @Token { NEWLINE TOKEN                   }

Static Function ParseTrue
  Return @Token { KEYWORD "logic" } ;
       + @Token { SYMBOL  "("     } ;
       + @Token { TRUE    ".T."   } ;
       + @Token { SYMBOL  ")"     } ;
       + @Token { NEWLINE TOKEN   }

Static Function ParseFalse
  Return @Token { KEYWORD "logic" } ;
       + @Token { SYMBOL  "("     } ;
       + @Token { FALSE    ".F."  } ;
       + @Token { SYMBOL  ")"     } ;
       + @Token { NEWLINE TOKEN   }

Static Function ParseUnknown( xData )
  Return @Token { KEYWORD "unknown"        } ;
       + @Token { SYMBOL  "("              } ;
       + @Token { UNKNOWN ValType( xData ) } ;
       + @Token { SYMBOL  ")"              } ;
       + @Token { NEWLINE TOKEN            }

Static Function ParseNil
  Return @Token { NIL     "nil" } ;
       + @Token { NEWLINE TOKEN }

Static Function ParseBlock( bData )
  Return @Token { KEYWORD "block"              } ;
       + @Token { SYMBOL  "("                  } ;
       + @Token { BLOCK   GetCBSource( bData ) } ;
       + @Token { SYMBOL  ")"                  } ;
       + @Token { NEWLINE TOKEN                }

Static Function ParseDate( dData )
  Return @Token { KEYWORD "date"     } ;
       + @Token { SYMBOL  "("        } ;
       + @Token { DATE DtoC( dData ) } ;
       + @Token { SYMBOL  ")"        } ;
       + @Token { NEWLINE TOKEN      }

Static Function ParseObject( oData )
  Local cTemplate := ""
  Local aChildren := ClassDataArr( oData )
  Local nContext  := 0
  @Next
    nContext  := Context
    cTemplate += @Token { KEYWORD "object"              } ;
               + @Token { SYMBOL  "<"                   } ;
               + @Token { NAME    GetClassName( oData ) } ;
               + @Token { SYMBOL  ">"                   } ;
               + @Token { SYMBOL  "("                   }

    If Len( aChildren ) > 0
      cTemplate += @Token { FOLDER     TOKEN } ;
                 + @Token { BEGIN_CLOS TOKEN } ;
                 + @Token { NEWLINE    TOKEN }
    Else
      cTemplate += @Token { SYMBOL  ")"    } ;
                 + @Token { NEWLINE TOKEN  }
      @Previous
      Return cTemplate
    EndIf

    cTemplate += ParseProperty( aChildren )                ;
               + @Token { DEDENT   nContext              } ;
               + @Token { SYMBOL   ")"                   } ;
               + @Token { END_CLOS TOKEN                 } ;
               + @Token { NEWLINE  TOKEN                 }

  @Previous
  Return cTemplate

Static Function ParseProperty( aProp )
  Local nI
  Local cTemplate := ""
  For nI := 1 To Len( aProp )
    cTemplate += @Token { INDENT  Context           } ;
               + @Token { KEYWORD "Property"        } ;
               + @Token { SYMBOL  "<"               } ;
               + @Token { PROPERTY aProp[ nI ][ 1 ] } ;
               + @Token { SYMBOL  ">"               } ;
               + @Token { SYMBOL  ": "              } ;
               + ParseExpr( aProp[ nI ][ 2 ] )
  Next nI
  Return cTemplate

Static Function ParseArray( aData )
  Local nI
  Local cTemplate := ""
  Local nContext
  @Next
    nContext  := Context
    cTemplate += @Token { KEYWORD    "array"                        } ;
               + @Token { SYMBOL     "<"                            } ;
               + @Token { NUMBER     AllTrim( Str( Len( aData ) ) ) } ;
               + @Token { SYMBOL     ">"                            } ;
               + @Token { SYMBOL     "("                            } ;
               + @Token { FOLDER     TOKEN                          } ;
               + @Token { BEGIN_CLOS TOKEN                          } ;
               + @Token { NEWLINE    TOKEN                          }

    For nI := 1 To Len( aData )
      cTemplate += @Token { INDENT Context              } ;
                 + @Token { SYMBOL "["                  } ;
                 + @Token { NUMBER AllTrim( Str( nI ) ) } ;
                 + @Token { SYMBOL "]"                  } ;
                 + @Token { SYMBOL " => "               } ;
                 + ParseExpr( aData[ nI ] )
    Next nI

    cTemplate += @Token { DEDENT   nContext } ;
               + @Token { SYMBOL   ")"      } ;
               + @Token { END_CLOS TOKEN    } ;
               + @Token { NEWLINE  TOKEN    }
  @Previous
  Return cTemplate
