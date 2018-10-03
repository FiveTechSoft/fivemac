
#include "FiveMac.ch"

*a test program for printing multiple pages 
*made by René Koot

FUNCTION Main()

   LOCAL oDlg
   
   DEFINE DIALOG oDlg TITLE "Dialog"
   
   @ 40, 40 BUTTON "print" OF oDlg ACTION RK_PrintTest()
   
   DEFINE MSGBAR OF oDlg
   
   ACTIVATE DIALOG oDlg
   
RETURN NIL   

*************************************************

FUNCTION RK_PrintTest()


LOCAL nCol := 28
LOCAL nRow := 0
LOCAL nRowHeight := 0
LOCAL n
LOCAL oSay, oImg

LOCAL aPrintArray[0][5]

AADD(aPrintArray, {'Line 1_1', 'Line2_1', 'Line3_1', 'Line4_1', 'Line5_1'})
AADD(aPrintArray, {'Line 1_2', 'Line2_2', 'Line3_2', 'Line4_2', 'Line5_2'})
AADD(aPrintArray, {'Line 1_3', 'Line2_3', 'Line3_3', 'Line4_3', 'Line5_3'})
AADD(aPrintArray, {'Line 1_4', 'Line2_4', 'Line3_4', 'Line4_4', 'Line5_4'})
AADD(aPrintArray, {'Line 1_5', 'Line2_5', 'Line3_5', 'Line4_5', 'Line5_5'})
AADD(aPrintArray, {'Line 1_6', 'Line2_6', 'Line3_6', 'Line4_6', 'Line5_6'})
AADD(aPrintArray, {'Line 1_7', 'Line2_7', 'Line3_1', 'Line4_1', 'Line5_1'})
AADD(aPrintArray, {'Line 1_8', 'Line2_8', 'Line3_2', 'Line4_2', 'Line5_2'})
AADD(aPrintArray, {'Line 1_9', 'Line2_9', 'Line3_3', 'Line4_3', 'Line5_3'})
AADD(aPrintArray, {'Line 1_10', 'Line2_10', 'Line3_4', 'Line4_4', 'Line5_4'})
AADD(aPrintArray, {'Line 1_11', 'Line2_11', 'Line3_5', 'Line4_5', 'Line5_5'})
AADD(aPrintArray, {'Line 1_12', 'Line2_12', 'Line3_6', 'Line4_6', 'Line5_6'})
AADD(aPrintArray, {'Line 1_13', 'Line2_13', 'Line3_1', 'Line4_1', 'Line5_1'})
AADD(aPrintArray, {'Line 1_14', 'Line2_14', 'Line3_2', 'Line4_2', 'Line5_2'})
AADD(aPrintArray, {'Line 1_15', 'Line2_15', 'Line3_3', 'Line4_3', 'Line5_3'})
AADD(aPrintArray, {'Line 1_16', 'Line2_16', 'Line3_4', 'Line4_4', 'Line5_4'})
AADD(aPrintArray, {'Line 1_17', 'Line2_17', 'Line3_5', 'Line4_5', 'Line5_5'})
AADD(aPrintArray, {'Line 1_18', 'Line2_18', 'Line3_6', 'Line4_6', 'Line5_6'})

PUBLIC nPage
PUBLIC nPagePx := 813

PUBLIC oPrn:=TPrinter():new(0,0,0,0)

oPrn:SetLeftMargin(0)
oPrn:SetRightMargin(0)
oPrn:SetTopMargin(0)
oPrn:SetbottomMargin(0)
oPrn:SetPaperName("A4")
oPrn:AutoPage(.T.)

nHeight := oPrn:GetPrintableHeight()
nWidth  := oPrn:GetPrintableWidth()

nPagePx := nHeight

oPrn:SetSize( nWidth, nHeight * LEN(aPrintArray) )

//oPrn:SetSize( oPrn:pageWidth()-56 , (oPrn:pageHeight()-28) * LEN(aPrintArray))

FOR nPage = 1 TO LEN(aPrintArray)
    cFoto := "write.png"
    nRow := (nPage-1)* nPagePx
    @ nRow, nCol SAY oSay PROMPT aPrintArray[nPage,1] OF oPrn SIZE 480, 40
        oSay:Setfont("Arial",20 )
        oSay:setTextColor(0,51,0,100)
    @ nRow+30, 285 IMAGE oImg OF oPrn SIZE 250, 250 FILENAME cFoto
        oImg:SetFrame()
    nRow := nRow + 300
    
    @ nRow, nCol SAY oSay PROMPT aPrintArray[nPage,2] OF oPrn SIZE 240, 18
        oSay:Setfont("Arial",12 )
    nRow := nRow + 30
    @ nRow, nCol SAY oSay PROMPT aPrintArray[nPage,3] OF oPrn SIZE 240, 18
        oSay:Setfont("Arial",12 )
    nRow := nRow + 30
    @ nRow, nCol SAY oSay PROMPT aPrintArray[nPage,4] OF oPrn SIZE 240, 18
        oSay:Setfont("Arial",12 )
    nRow := nRow + 30
    @ nRow, nCol SAY oSay PROMPT aPrintArray[nPage,5] OF oPrn SIZE 240, 18
        oSay:Setfont("Arial",12 )
    nRow := nRow + 30
    
    RK_PrintFooter()
NEXT

oPrn:run()

RETURN NIL

*************************************************

FUNCTION RK_PrintFooter()

local nWidth  := oPrn:GetPrintableWidth()

    @ 780 + ((nPage-1)*nPagePx), 28 SAY oSay PROMPT CHR(0169) + ' Copyright: Plantenkennis versie ' OF oPrn SIZE nWidth- 112, 20
            oSay:Setfont("Arial",12 )
    @ 780 + ((nPage-1)*nPagePx), 450 SAY oSay PROMPT 'page ' + ALLTRIM(STR(nPage)) OF oPrn SIZE nWidth - 112, 20
            oSay:Setfont("Arial",12 )

RETURN NIL

*************************************************

function PrinterPaint()
*somehow this function is needed for printing
return nil 
