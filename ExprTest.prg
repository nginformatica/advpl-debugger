/**
 * Teste do analisador de expressões.
 * @author Marcelo Camargo
 */
Function ExprTest
  Debug( { { { |X| X * X }, "Lorem ipsum dolor sit amet consectetur", nil }, ;
           .T., .F., 1.39, { 12 }, Person:Create( "Bar", 10 ) } )
  Return