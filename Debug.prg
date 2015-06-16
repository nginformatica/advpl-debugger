#include "protheus.ch"

Function Console( xVar )
  Local aParser := { ;
  /* Keyword    */ { |Keyword| Keyword                             }, ;
  /* Number     */ { |Number | Number                              }, ;
  /* String     */ { |String | '"' + String + '"'                  }, ;
  /* Indent     */ { |Scope  | Replicate( " ", Scope * 2 )         }, ;
  /* Symbol     */ { |Symbol | Symbol                              }, ;
  /* Newline    */ { |       | Chr( 13 ) + Chr( 10 )               }, ;
  /* Date       */ { |D      | D                                   }, ;
  /* True       */ { |T      | T                                   }, ;
  /* False      */ { |F      | F                                   }, ;
  /* Nil        */ { |N      | N                                   }, ;
  /* Block      */ { |B      | B                                   }, ;
  /* Propert    */ { |P      | P                                   }, ;
  /* Object     */ { |O      | O                                   }, ;
  /* Unknown    */ { |U      | U                                   }, ;
  /* Name       */ { |Nm     | Nm                                  }, ;
  /* Dedent     */ { |Scope  | Replicate( " ", ( Scope * 2 ) - 2 ) }, ;
  /* Folder     */ { |       | ""                                  }, ;
  /* BeginClos  */ { |       | ""                                  }, ;
  /* EndClos    */ { |       | ""                                  }  }
  Return Debugger( xVar, aParser )

Function Debug( xVar )
  Local aParser := { ;
  /* Keyword    */ { |Keyword| '<span class="keyword">' + Keyword + "</span>" }, ;
  /* Number     */ { |Number | '<span class="number">' + Number + "</span>"   }, ;
  /* String     */ { |String | '<span class="string">"' + String + '"</span>' }, ;
  /* Indent     */ { |Scope  | Replicate( "&nbsp;", Scope * 2 )               }, ;
  /* Symbol     */ { |Symbol | '<span class="symbol">' + Symbol + "</span>"   }, ;
  /* Newline    */ { |       | "<br />"                                       }, ;
  /* Date       */ { |D      | '<span class="date">' + D + "</span>"          }, ;
  /* True       */ { |T      | '<span class="true">' + T + "</span>"          }, ;
  /* False      */ { |F      | '<span class="false">' + F + "</span>"         }, ;
  /* Nil        */ { |N      | '<span class="nil">' + N + "</span>"           }, ;
  /* Block      */ { |B      | '<span class="block">' + B + "</span>"         }, ;
  /* Property   */ { |P      | '<span class="property">' + P + "</span>"      }, ;
  /* Object     */ { |O      | '<span class="object">' + O + "</span>"        }, ;
  /* Unknown    */ { |U      | '<span class="Unknown">' + U + "</span>"       }, ;
  /* Name       */ { |Nm     | '<span class="name">' + Nm + "</span>"         }, ;
  /* Dedent     */ { |Scope  | Replicate( "&nbsp;", ( Scope * 2 ) - 2 )       }, ;
  /* Folder     */ { |       | '<span class="folder"></span>'                 }, ;
  /* BeginClos  */ { |       | '<span class="sub">'                           }, ;
  /* EndClos    */ { |       | '</span>'                                      }  }
  Local cHTML   := Debugger( xVar, aParser )
  RegisterHTML( cHTML )
  DEFINE DIALOG oDlg TITLE "NG - Debugger de Expressoes" FROM 180, 180 TO 550, 700 PIXEL
  TIBrowser():New( 0, 0, 260, 180, "C:\totvs\var_dump.html", oDlg )
  ACTIVATE MSDIALOG oDlg CENTERED
  Return Console( xVar )

Static Function RegisterHTML( cHTML )
  Local nHandle := fCreate( "C:\totvs\var_dump.html" )
  fWrite( nHandle, MountPage( cHTML ) )
  fClose( nHandle )
  Return

Static Function MountPage( cHTML )
  Return '<html><head><link rel="stylesheet" type="text/css" ' ;
       + 'href="syntax.css"></head><body><div id="codegen">'   ;
       + cHTML + '</div></body><script type="text/javascript"' ;
       + ' src="folding.js"></script></html>'
