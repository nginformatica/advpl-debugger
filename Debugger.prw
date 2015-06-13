#include "protheus.ch"
#define TOKEN ""
#xtranslate T_<name> <value> => Eval( <name>, <value> )

Function Debbuger( xVar, aTokens )
  Local cExprResult

  If Len( aTokens != 14 )
    Return "Err.: Numero invalido de analisadores de tokens"
  EndIf

  _KEYWORD    := aTokens[ 1 ]
  _NUMBER     := aTokens[ 2 ]
  _STRING     := aTokens[ 3 ]
  _WHITESPACE := aTokens[ 4 ]
  _SYMBOL     := aTokens[ 5 ]
  _NEWLINE    := aTokens[ 6 ]
  _DATE       := aTokens[ 7 ]
  _TRUE       := aTokens[ 8 ]
  _FALSE      := aTokens[ 9 ]
  _NIL        := aTokens[ 10 ]
  _BLOCK      := aTokens[ 11 ]
  _PROPERTY   := aTokens[ 12 ]
  _OBJECT     := aTokens[ 13 ]
  _UNKNOWN    := aTokens[ 14 ]

  cExprResult := ParseExpr( xVar )
  Context := 0
  ConOut( cExprResult )
  Return cExprResult

Function ParseExpr( xVar )
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
    Case cType == "O" // Object
      Return ParseObject( xVar )
    Case cType == "L" // Logic
      Return ParseLogic( xVar )
    Otherwise
      Return ParseUnknown( xVar )
  EndCase
  Return

Function ParseString( cData )
  Return T_KEYWORD "string"            ;
       + T_SYMBOL  "<"                 ;
       + T_NUMBER  Str( Len( cData ) ) ;
       + T_SYMBOL  ">"                 ;
       + T_SYMBOL  "("                 ;
       + T_STRING  cData               ;
       + T_SYMBOL  ")"                 ;
       + T_NEWLINE TOKEN

Function ParseNumber( nData )
  Return T_KEYWORD "number" ;
       + T_SYMBOL  "("      ;
       + T_SYMBOL  ")"      ;
       + T_NEWLINE TOKEN

Function ParseLogic( lData )
  Local bToken := IIf( lData, _TRUE, _FALSE ) ;
      , cView  := IIf( lData, ".T.", ".F." )
  Return T_bToken cView ;
       + T_NEWLINE TOKEN

Function ParseUnknown( xData )
  Return T_UNKNOWN ValType( xData ) ;
       + T_NEWLINE TOKEN

Function ParseNil
  Return T_NIL     TOKEN ;
       + T_NEWLINE TOKEN

Function ParseArray( aData )
  // Ah, I continue this later!