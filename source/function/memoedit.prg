#include "FiveMac.ch"

//----------------------------------------------------------------------------//

function FM_MemoEdit( cText, cTitle )

   local oDlg, lChanged := .F., cTemp := cText
   
   DEFINE DIALOG oDlg TITLE cTitle SIZE 600, 390 FLIPPED
   
   @ 15, 15 GET cText MEMO OF oDlg SIZE 570, 300
   
   @ 325, 200 BUTTON "Ok" OF oDlg ;
      ACTION ( lChanged := .T., cText := cTemp, oDlg:End() )

   @ 325, 320 BUTTON "Cancel" OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED
   
return lChanged

//----------------------------------------------------------------------------//

function SourceEdit( cSource, cTitle ) // @Source by reference

   local oDlg, oEditor, lChanged := .F., cTemp := cSource
   
   DEFINE DIALOG oDlg TITLE cTitle SIZE 950, 590 FLIPPED
   
   oEditor = TScintilla():New( 15, 15, 920, 500, oDlg )
   oEditor:SetText( cSource )

   @ 525, 200 BUTTON "Copy" OF oDlg ;
    ACTION ( oEditor:copy() )
    
    @ 525, 300 BUTTON "Paste" OF oDlg ;
    ACTION ( oeditor:Paste() )
    
    @ 525, 400 BUTTON "Save" OF oDlg ;
    ACTION ( SaveSource(oEditor:getText()) )
      
   @ 525, 500 BUTTON "Ok" OF oDlg ;
      ACTION ( lChanged := .T., cSource := cTemp, oDlg:End() )

   @ 525, 600 BUTTON "Cancel" OF oDlg ACTION oDlg:End()
   
   ACTIVATE DIALOG oDlg CENTERED
   
return lChanged

//----------------------------------------------------------------------------//

function SaveSource( cSource )
    
    local cFileName := SaveFile( "Save Source as : " )
    
    if ! Empty( cFileName )
        MemoWrit( cFileName,cSource )
    endif
    
return nil

//----------------------------------------------------------------------------//

function ArrayEdit( aValues, cTitle )

   local oDlg, oBrw, oBtn1, oBtn2, cValues := ArrayToText( aValues )
   local lChanged := .F.

   DEFAULT cTitle := "Array Editor"

   DEFINE DIALOG oDlg ;
      TITLE cTitle ;
      SIZE 391, 405

   @ 65, 17 GET cValues MEMO OF oDlg ;
      SIZE 355, 300

   @ 16, 88 BUTTON oBtn1 PROMPT "Ok" OF oDlg ;
      SIZE 90, 30 ;
      ACTION ( lChanged := .T., aValues := TextToArray( cValues ), oDlg:End() )

   @ 17, 209 BUTTON oBtn2 PROMPT "Cancel" OF oDlg ;
      SIZE 90, 30 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED 

return lChanged

//----------------------------------------------------------------------------//

function ArrayToText( aItems )

  local cText := ""
  
  AEval( aItems, { | u | cText += cValToChar( u ) + CRLF } )
  
return cText

//----------------------------------------------------------------------------//

function TextToArray( cText )

   local n, aResult := {}
   
   for n = 1 to MLCount( cText )
      AAdd( aResult, AllTrim( MemoLine( cText,, n ) ) )
   next
   
return aResult
      
//----------------------------------------------------------------------------// 

function InspectArray( aValues )

   local oDlg, oBrw, oBtn1, oBtn2

   DEFINE DIALOG oDlg ;
      TITLE "Array inspector" ;
      SIZE 391, 405

   @ 65, 17 BROWSE oBrw OF oDlg ;
      FIELDS "" ;
      HEADERS "Items" ;
      SIZE 355, 300

   oBrw:SetColor( CLR_BLACK, CLR_PANE )
   oBrw:SetArray( aValues )
   oBrw:SetColWidth( 1, 335 )
   oBrw:bLine = { | nRow | { aValues[ nRow ] } }
   oBrw:GoTop()
   oBrw:SetFocus()

   @ 16, 88 BUTTON oBtn1 PROMPT "Ok" OF oDlg ;
      SIZE 90, 30 ACTION oDlg:End()

   @ 17, 209 BUTTON oBtn2 PROMPT "Cancel" OF oDlg ;
      SIZE 90, 30 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED 

return nil

//----------------------------------------------------------------------------//  
