// FiveMac.ch - (c) FiveTech Software 2006-2015

#ifndef __FiveMac
#define __FiveMac

#include "hbclass.ch"
#include "anclas.ch"
#include "colors.ch"

#define CRLF hb_OsNewLine()

#define bSETGET(x) { | u | If( PCount()==0, x, x := u ) }

#define CLR_PANE RGB( 150, 150, 150 )

REQUEST HB_GT_NUL_DEFAULT, ErrorLink, MsgBeep

#xcommand ? <x,...> => AEval( \{ <x> \}, { | u | MsgInfo( u ) } )

//----------------------------------------------------------------------------//

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
                [ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]
		
#xcommand DATABASE <oDbf> => <oDbf> := TDataBase():New()	

//----------------------------------------------------------------------------//

#xcommand DEFINE TIMER [ <oTimer> ] ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lRepeat: REPEAT >  ] ;
             [ <lDeActivate: DEACTIVATE >  ] ;
       => ;
          [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}], <oWnd> , <.lRepeat.> ,<.lDeActivate.> )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

//----------------------------------------------------------------------------//

#xcommand DEFINE WINDOW <oWnd> ;
              [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
          => ;
              <oWnd> := TWindow():Define( <cResName> )
		
#xcommand DEFINE WINDOW <oWnd> ;
             [ TITLE <cTitle> ] ;
		         [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		         [ <textured: TEXTURED> ] ; 
		         [ <paneled: PANELED> ] ;
		         [ <noborder: NOBORDER> ] ;
             [ <round: ROUNDED> ] ;
		         [ <full: FULL> ] ;
             [ <flipped: FLIPPED>  ] ;
          => ;
	           <oWnd> := TWindow():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
	              [<cTitle>], [<.textured.>],;
		            [<.paneled.>], [<.noborder.>], [<.full.>],;
		            [<.round.>], [<nWidth>], [<nHeight>], [<.flipped.>], [<(oWnd)>] )

#xcommand ACTIVATE WINDOW <oWnd> ;
             [ ON [ LEFT ] CLICK <uLClicked> ] ;
             [ ON RIGHT CLICK <uRClicked> ] ;
             [ VALID <uValid> ] ; 
             [ <max: MAXIMIZED> ] ;
             [ ON INIT <uInit> ] ;
             [ ON PAINT <uPainted> ] ;
             [ <center: CENTER, CENTERED> ] ;
             [ ON RESIZE <uResized> ] ;
          => ;
             <oWnd>:Activate( [\{| nRow, nCol |(<uLClicked>)\}],;
                              [\{||(<uValid>)\}], <.max.>,;
                              [\{| self |(<uPainted>)\}], <.center.>,;
                              [\{||(<uInit>)\}],;
                              [\{| nRow, nCol | (<uRClicked>) \}],;
                              [\{|| (<uResized>) \}] )	

//----------------------------------------------------------------------------//

#xcommand DEFINE MSGBAR [<oBar>] ;
             [ OF <oWnd> ] ;
             [ SIZE  <nHeight> ] ;  
             [ PROMPT <cPrompt> ] ;
          => ;
             [ <oBar> := ] <oWnd>:SetMsgBar( [<nHeight>] , [<cPrompt>] )

//----------------------------------------------------------------------------//

#xcommand DEFINE DIALOG <oDlg> ;
             [ TITLE <cTitle> ] ;
		         [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <textured: TEXTURED> ] ; 
		         [ <paneled: PANELED> ] ;  
             [ <flipped: FLIPPED> ] ; 
          => ;
	           <oDlg> := TDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
             <cTitle>, [<.textured.>], [<.paneled.>], [<nWidth>], [<nHeight>],;
             [<.flipped.>] )

#xcommand ACTIVATE DIALOG <oDlg> ;
             [ ON [ LEFT ] CLICK <uLClicked> ] ;
             [ ON RIGHT CLICK <uRClicked> ] ;
		         [ VALID <uValid> ] ;
		         [ <nomodal: NONMODAL, NOWAIT> ] ;
		         [ <center: CENTER, CENTERED> ] ;
		         [ ON INIT <uInit> ] ;
		         [ ON RESIZE <uResized> ] ;
          => ;
	          <oDlg>:Activate( [\{| nRow, nCol |(<uLClicked>)\}],;
		                         [\{||(<uValid>)\}], [<.nomodal.>],;
		                         [<.center.>], [\{||(<uInit>)\}],;
		                         [\{| nRow, nCol |(<uRClicked>)\}],;
		                         [\{|| (<uResized>)\}] )

//----------------------------------------------------------------------------//

#xcommand DEFINE MULTIVIEW <oMulti> ;
          [ OF <oWnd> ] ; 
          [ <resized: RESIZED> ] ;
       => ;
	        <oMulti> := TMultiView():New( <oWnd>,[<.resized.>] )
	     
#xcommand @ <nTop>, <nLeft> MVIEW [ <oView> ] ;
             [ PROMPT <cPrompt>];
             [ SIZE <nWidth>, <nHeight> ] ;
             [ TITLE <cTitle> ] ;
             [ OF <oMulti> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ IMAGE <cImage> ] ;  
		      => ;
             [ <oView>:= ] MultiAddview(<oMulti>, <nTop>, <nLeft>, <nWidth>,;
             <nHeight>, <cTitle>, <cPrompt>, <cToolTip>, <cImage> ) 
	        
//----------------------------------------------------------------------------//
		  
#xcommand MENU [<oMenu>] => [<oMenu> :=] MenuBegin()

#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
             [ ACTION <uAction,...> ] ;
             [ ACCELERATOR <cKey> ] ;	 
             [ IMAGE <cImage> ] ;     
	        => ;
	           [ <oMenuItem> := ] MenuAddItem( <cPrompt>, [\{|oMenuItem|(<uAction>)\}], [<cKey>], [<cImage>] )

#xcommand SEPARATOR => MenuAddSeparator()	     
	     
#xcommand ENDMENU => MenuEnd()

#xcommand MENU [<oMenu>] POPUP => [<oMenu> :=] MenuBegin( .T. )

#xcommand ACTIVATE POPUP <oMenu> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ AT <nRow>, <nCol> ] ;
       => ;
          ShowPopupMenu( <oMenu>, <oWnd>, <nRow>, <nCol> )

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cPrompt> ;
             [ OF <oWnd> ] ;
             [ ACTION <uAction,...> ] ;
		   [ SIZE <nWidth>, <nHeight> ] ;
		   [ STYLE <nStyle> ] ;
		   [ TYPE <nType> ] ;
		   [ FILENAME <cBmp> ] ;
             [ AUTORESIZE <nAutoResize> ] ;	
             [ TOOLTIP <cToolTip> ] ;
             [ PIXEL ] ;
          => ;
		   [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		   <cPrompt>, <oWnd>, [\{| self |(<uAction>)\}], <nStyle>, <nType>, <cBmp>,;
		   [<nAutoResize>], [<cToolTip>], [<(oBtn)>] )

#xcommand REDEFINE BUTTON <oBtn> ;
             [ ID <nId> ] ;
             [ <of: OF, PARENT, WINDOW, DIALOG> <oWnd> ] ;
             [ VIEW <hView> ] ;
             [ ACTION <uAction,...> ] ;
          => ;
             <oBtn> := TButton():Redefine( <nId>, <oWnd>,;
             [\{||(<uAction>)\}], <hView> )    		                                      

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> BTNBMP [ <oBtn> ] ;
             [ FILENAME <cFileName> ] ; 
             [ OF <oWnd> ] ;
		     [ ACTION <uAction,...> ] ;
		     [ SIZE <nWidth>, <nHeight> ] ;
             [ STYLE <nStyle> ] ;
             [ TOOLTIP <cToolTip> ] ;  
             [ AUTORESIZE <nAutoResize> ] ;	    
		      => ;
		         [ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>,;
             <nHeight>, <oWnd>, [\{||(<uAction>)\}], [<cFileName>],;
             <nStyle>, [<cToolTip>],[<nAutoResize>] , [<(oBtn)>], [ <(uAction)> ] )

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> COLORWELL [ <oClrWell> ] ;
		         [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ON CHANGE <uChange> ] ; 
          => ;
             [ <oClrWell> := ] TColorWell():New( <nRow>, <nCol>, [<nWidth>],;
             [<nHeight>], [<oWnd>], [\{||(<uChange>)\}] )			       

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> DATEPICKER [ <oDPick> ] ;
			       [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
          => ;
             [ <oDPick> := ] TDatePicker():New( <nRow>, <nCol>, [<nWidth>],;
             [<nHeight>], [<oWnd>] )			       

//----------------------------------------------------------------------------//
								
#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
			       [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
			       [ <memo: MULTILINE, MEMO, TEXT> ] ;
			       [ <update: UPDATE> ] ;
			       [ PIXEL ] ;
          => ;
             [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, [<nWidth>], [<nHeight>],;
			                                      [<oWnd>], bSETGET( <uVar> ), <.update.> )			       
        
//----------------------------------------------------------------------------//
#xcommand @ <nRow>, <nCol> TEXTBOX [ <oGet> VAR ] <uVar> ;
[ OF <oWnd> ] ;
[ SIZE <nWidth>, <nHeight> ] ;
[ VALID <uValid> ] ;
[ <update: UPDATE> ] ;
[ <password: PASSWORD> ] ;
[ <lsearch: SEARCH> ] ;
[ <lrounded: ROUNDED> ] ;
[ ON CHANGE <uChange> ] ;
[ TOOLTIP <cToolTip> ] ;
[ AUTORESIZE <nAutoResize> ] ;
[ PICTURE <cPicture> ] ;
[ PIXEL ] ;
=> ;
[ <oGet> := ] TTextBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
<oWnd>, bSETGET(<uVar>), [\{||(<uValid>)\}],;
<.update.>, <.password.> ,<.lsearch.>, [{|Self|<uChange>}],;
<.lrounded.>, [<cToolTip>], [<nAutoResize>], [<(oGet)>], [<cPicture>] )



#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
           [ OF <oWnd> ] ;
           [ SIZE <nWidth>, <nHeight> ] ;
		       [ VALID <uValid> ] ;
           [ <update: UPDATE> ] ;
		       [ <password: PASSWORD> ] ;  
           [ <lsearch: SEARCH> ] ;  
           [ <lrounded: ROUNDED> ] ; 
           [ ON CHANGE <uChange> ] ; 
           [ TOOLTIP <cToolTip> ] ;
           [ AUTORESIZE <nAutoResize> ] ;
           [ PICTURE <cPicture> ] ;
           [ PIXEL ] ;
		    => ;
		       [ <oGet> := ] TGet():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		       <oWnd>, bSETGET(<uVar>), [\{||(<uValid>)\}],;
		       <.update.>, <.password.> ,<.lsearch.>, [{|Self|<uChange>}],;
		       <.lrounded.>, [<cToolTip>], [<nAutoResize>], [<(oGet)>], [<cPicture>] )
		                                   
#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> ;
             [ ID <nId> ] ;
             [ <of: OF, PARENT, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
             [ <password: PASSWORD> ] ; 
             [ <lsearch: SEARCH> ] ;  
             [ PICTURE <cPicture> ] ;
          => ;
             [ <oGet> := ] TGet():Redefine( <nId>, <oWnd>, bSETGET( <uVar> ),;
             <.update.>, <.password.>, <.lsearch.>, [<cPicture>] )     		                                   

//----------------------------------------------------------------------------//		 								   

#xcommand @ <nTop>, <nLeft> GROUP [<oGroup>] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <label: LABEL, PROMPT> <cLabel> ] ;
             [ OF <oWnd> ] ;
             [ STYLE <nStyle> ] ;  
             [ AUTORESIZE <nAutoResize> ] ;	
             [ <flipped: FLIPPED> ] ;
         => ;
             [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nWidth>, <nHeight>,;
             <oWnd>, <cLabel>, <nStyle>, [<nAutoResize>], [<(oGroup)>],[<.flipped.>] )
 
 #xcommand @ <nTop>, <nLeft> LINE HORIZONTAL[ <oGroup> ] ;
             [ SIZE <nWidth> ] ;
             [ OF <oWnd> ] ;
             [ AUTORESIZE <nAutoResize> ] ;	
         => ;
             [ <oGroup> := ] TGroup():LineH( <nTop>, <nLeft>, <nWidth>,;
             <oWnd>, [<nAutoResize>] )                        
             
 #xcommand @ <nTop>, <nLeft> LINE VERTICAL[ <oGroup> ] ;
             [ SIZE <nWidth> ] ;
             [ OF <oWnd> ] ;
             [ AUTORESIZE <nAutoResize> ] ;	
         => ;
             [ <oGroup> := ] TGroup():LineV( <nTop>, <nLeft>, <nWidth>,;
             <oWnd> ,[<nAutoResize>] )              
             
//----------------------------------------------------------------------------//		 								   

#xcommand REDEFINE SAY [ <oSay> ] ;
 				     [ ID <nId> ] ;
             [ OF  <oWnd> ] ;
		      => ;
		         [ <oSay> := ] TSay():Redefine( <nId>, <oWnd> )

#xcommand @ <nRow>, <nCol> SAY [ <oSay> PROMPT ] <cText> ;
            [ OF  <oWnd> ] ;
		        [ SIZE <nWidth>, <nHeight> ] ;
		        [ <raised: RAISED> ] ;
            [ <cPostext: TEXTLEFT, TEXTRIGHT, TEXTCENTER> ] ; 
            [ AUTORESIZE <nAutoResize> ] ;	
            [ TOOLTIP <cToolTip> ] ; 
            [ <lutf8: UTF8 > ] ;
            [ PIXEL ] ;
         => ;
            [ <oSay> := ] TSay():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
            <oWnd>, <cText>, <.raised.>, [ Upper(<(cPostext)>) ],;
            [<nAutoResize>], [<cToolTip>], [<(oSay)>] )	
    
                
 #xcommand @ <nRow>, <nCol> HIPERLINK [ <oSay> PROMPT ] <cText> ;
            [ OF  <oWnd> ] ;
		        [ SIZE <nWidth>, <nHeight> ] ;
		        [ <raised: RAISED> ] ;
            [ <cPostext: TEXTLEFT, TEXTRIGHT, TEXTCENTER> ] ; 
            [ AUTORESIZE <nAutoResize> ] ;	
            [ TOOLTIP <cToolTip> ] ; 
            [ URL <cUrl> ] ;
            [ PIXEL ] ;
         => ;
             [ <oSay> := ] TSay():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
            <oWnd>, <cText>, <.raised.>, [ Upper(<(cPostext)>) ],;
            [<nAutoResize>], [<cToolTip>], [<(oSay)>] , ,[ <cUrl> ] )	
            
 
//----------------------------------------------------------------------------//		 								   
	     
#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ <it: PROMPTS, ITEMS> <aItems> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ OF <oWnd> ] ;
             [ ON CHANGE <uChange> ] ;
             [ AUTORESIZE <nAutoResize> ] ;	
             [ PIXEL ] ;
         => ;
             [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,;
	           bSETGET(<cVar>), <aItems>, [{|Self|<uChange>}], [<nAutoResize>],;
	           [<(oCbx)>] )

#xcommand REDEFINE COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ ID <nId> ] ;
             [ <of: OF, PARENT, WINDOW, DIALOG> <oWnd> ] ;
             [ <it: PROMPTS, ITEMS> <aItems> ] ;
             [ ON CHANGE <uChange> ] ;
          => ;
             [ <oCbx> := ] TComboBox():Redefine( <nId>, <oWnd>, bSETGET(<cVar>),;
             <aItems>, [{|Self|<uChange>}] )   

//----------------------------------------------------------------------------//		 								   

#xcommand @ <nRow>, <nCol> BROWSE <oBrw> ;
             [ FIELDS <fields,...> ] ;
             [ HEADERS <headers,...> ] ;
             [ COLSIZES <sizes, ...> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ OF <oWnd> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ALIAS <cAlias> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
             [ COLOR <nClrText> [,<nClrBack>] ] ;
             [ PIXEL ] ;
           => ;
             [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,;
	           [\{|| \{ <fields> \} \}], [\{ <headers> \}], [{|Self|<uChange>}],;
	           [<cAlias>], [<nAutoResize>],[\{ <sizes> \}], <nClrText>, <nClrBack>,;
	           [<(oBrw)>] ) 
 
#xcommand  REDEFINE BROWSE <oBrw> ;
             [ ID <nId> ] ;
             [ FIELDS <fields,...> ] ;
             [ HEADERS <headers,...> ] ;
             [ COLSIZES <sizes, ...> ] ;
             [ OF <oWnd> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ALIAS <cAlias> ] ;
          => ;
             [ <oBrw> := ] TWBrowse():Redefine( <nId>, <oWnd>,[\{|| \{ <fields> \} \}],;
             [\{ <headers> \}], [{|Self|<uChange>}], [<cAlias>], [\{ <sizes> \}] )
  
//----------------------------------------------------------------------------//		 								   
                                    
#xcommand @ <nRow>, <nCol> LISTBOX <oBrw> ;
             [ FIELDS <fields,...> ] ;
             [ HEADERS <headers,...> ] ;
             [ COLSIZES <sizes, ...> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ OF <oWnd> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ALIAS <cAlias> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
          => ;
             [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,;
	           [\{|| \{ <fields> \} \}], [\{ <headers> \}], [{|Self|<uChange>}],;
	           [<cAlias>], [<nAutoResize>], [\{ <sizes> \}], <(oBrw)> )

//----------------------------------------------------------------------------//		 								   
 
#xcommand @ <nRow>, <nCol> CHECKBOX [ <oChk> VAR ] <lVar> ;
             [ PROMPT <cPrompt> ] ;  
             [ OF <oWnd> ] ;
		     [ <change: ON CLICK, ON CHANGE> <uAction,...> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		         [ <update: UPDATE> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
             [ PIXEL ] ;
            => ;
		         [ <oChk> := ] TCheckBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		         [<oWnd>], bSETGET(<lVar>), [<cPrompt>],;
		         [\{| lChecked, Self | <uAction> \}],;
		         <.update.>, <nAutoResize>, [<(oChk)>], [<(uAction)>] )
		           
#xcommand REDEFINE CHECKBOX [ <oChk> VAR ] <lVar> ;
             [ ID <nId> ] ;
             [ <of: OF, PARENT, DIALOG, WINDOW> <oWnd> ] ;
             [ <change: ON CLICK, ON CHANGE> <uAction,...> ] ;
             [ <update: UPDATE> ] ;
          => ;
             [ <oChk> := ] TCheckBox():Redefine( <nId>, <oWnd>, bSETGET(<lVar>),;
             [\{||(<uAction>)\}], <.update.> )   		            

//----------------------------------------------------------------------------//		 								   

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
			       [ <items: PROMPT, PROMPTS, ITEMS> <acItems> ] ;
			       [ SIZE <nWidth>, <nHeight> ] ;
			       [ <update: UPDATE> ] ;
		      => ;
             [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>,;
			       [<oWnd>], bSETGET( <nVar> ), <acItems>, <nWidth>,;
			       <nHeight>, <.update.> )

//----------------------------------------------------------------------------//

//#xcommand @ <nRow>, <nCol> FOLDER [ <oFld> ] ;
//             [ OF <oWnd> ] ;
//		         [ SIZE <nWidth>, <nHeight> ] ;
//		         [ PAGES <pages,...> ] ;
//             [ <lFlipped: FLIPPED> ] ;
//             [ PIXEL ] ;
//		          => ;
//		         [ <oFld> := ] TFolder():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
//		         [<oWnd>], [\{<pages>\}], [<(oFld)>], [<.lFlipped.>]  )

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> IMAGE [ <oImg> ] ;
             [ OF <oWnd> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		         [ FILENAME <cFileName> ] ;
		         [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
		         [ TOOLTIP <cToolTip> ] ; 
		      => ;
		         [ <oImg> := ] TImage():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		         [<oWnd>], [<cFileName>], [<cResName>], [<cToolTip> ], [<(oImg)>]  )
                                             
 #xcommand REDEFINE IMAGE [ <oImg> ] ;
            [ ID <nId> ] ;
            [ OF <oWnd> ] ;
		        [ FILENAME <cFileName> ] ;
		        [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
		     => ;
            [ <oImg> := ] TImage():Redefine( <nId>, [<oWnd>], [<cFileName>],;
            [<cResName>] )                      
                                             
//----------------------------------------------------------------------------//		 								   
					       
#xcommand @ <nRow>, <nCol> WEBVIEW <oWeb> ;
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ URL <cUrl> ] ;
          => ;
             <oWeb> := TWebView():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>, <cUrl> )      					

             
#xcommand REDEFINE WEBVIEW <oWeb> ;
             [ ID <nId> ] ;
             [ OF <oWnd> ] ;
             [ URL <cUrl> ] ;
          => ;
             <oWeb> := TWebView():Redefine( <nId>, <oWnd>, <cUrl> )                             		       

//----------------------------------------------------------------------------//		 								   

#xcommand @ <nRow>, <nCol> PDFVIEW <oPdf> ;
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ FILE <cPdf> ] ;
             [ <lautoScale: AUTOSCALE > ] ;              
          => ;
             <oPdf> := TPdfview():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <oWnd>, <cPdf> ,[<.lautoScale.>] )  

#xcommand REDEFINE PDFVIEW [ <oPdf> ] ;
             [ ID <nId> ] ;
             [FILE  <cPdf>  ];
             [ <of: OF, PARENT, DIALOG, WINDOW> <oWnd> ] ;
              => ;
             [ <oPdf> := ] TPdfview():Redefine( <nId>, <oWnd>, <cPdf> )   

//----------------------------------------------------------------------------//		 								   
							       
#xcommand DEFINE <bar: TOOLBAR, BUTTONBAR> <oTbr> ;
             [ <style: DEFAULT, ICON, LABEL, ICONLABEL > ] ;
             [ OF <oWnd> ] ;
		      => ;
             [ <oTbr> := ] TToolBar():New( <oWnd> ,[ Upper(<(style)>) ])
             
                                               
#xcommand REDEFINE <bar: TOOLBAR, BUTTONBAR> <oTbr> ;
             [ <style: DEFAULT, ICON, LABEL, ICONLABEL > ] ;
             [ OF <oWnd> ] ;
		      => ;
             [ <oTbr> := ] TToolBar():Redefine( <oWnd> ,[ Upper(<(style)>) ])
                                                                                                              
#xcommand DEFINE BUTTON [ <oBtn> ] OF <oTbr> ;
             [ PROMPT <cPrompt> ] ;
			       [ TOOLTIP <cToolTip> ] ;
			       [ ACTION <uAction,...> ] ;
			       [ IMAGE <cImage> ] ;
             [ <lSelectable: SELECTABLE> ] ;
            => ;
		         [ <oBtn> := ] <oTbr>:AddButton( <cPrompt>, <cToolTip>, [\{||(<uAction>)\}], <cImage>,<.lSelectable.>  )             

#xcommand REDEFINE TBUTTON [ <oBtn> ] OF <oTbr> ;
             [ PROMPT <cPrompt> ] ;
			       [ TOOLTIP <cToolTip> ] ;
			       [ ACTION <uAction,...> ] ;
			       [ IMAGE <cImage> ] ;
          => ;
		         [ <oBtn> := ] <oTbr>:AddRButton( <cPrompt>, <cToolTip>, [\{||(<uAction>)\}], <cImage> )   
                  
//----------------------------------------------------------------------------//		 								   

#xcommand @ <nRow>, <nCol> MOVIE [ <oMovie> ] ;
             [ FILENAME <cFileName> ] ; 
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
          => ;
             [ <oMovie> := ] TMovie():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <oWnd>, [<(cFileName)>] , [<nAutoResize>] )

#xcommand REDEFINE MOVIE [ <oMovie> ] ;
             [ ID <nId> ] ;
             [FILE  <cMovie>  ];
             [ <of: OF, PARENT, DIALOG, WINDOW> <oWnd> ] ;
              => ;
             [ <oMovie> := ] TMovie():Redefine( <nId>, <oWnd>, <cMovie> )   

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> COVERFLOW [ <oCoverFlow> ] ;
             [ OF <oWnd> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		      => ;
		         [ <oCoverFlow> := ] TCoverFlow():New( <nRow>, <nCol>, <nWidth>,;
		         <nHeight>, <oWnd> )
                 
#xcommand REDEFINE COVERFLOW [ <oCoverFlow> ] ;
             [ ID <nId> ] ; 
             [ OF <oWnd> ] ;
		      => ;
		         [ <oCoverFlow> := ] TCoverFlow():Redefine( <nId>, <oWnd> )
                 
//----------------------------------------------------------------------------//
                                
#xcommand @ <nRow>, <nCol> SPLITTER [ <oSplitter> ] ;
             [ OF <oWnd> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		         [ <h: HORIZONTAL> ] ;
		         [ <v: VERTICAL> ] ;
		         [ STYLE <nStyle> ] ;
		         [ AUTORESIZE <nAutoResize> ] ;
             [ VIEWS <nViews> ] ;
	       => ;
		         [ <oSplitter> := ] TSplitter():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		         <oWnd>,(.not.<.h.>) [.or. <.v.>], <nStyle> , <nAutoResize> [,<nViews> ] )

#xcommand DEFINE VIEW [<oView>] OF <oSplitter> ;
          => ;
             [<oView> :=] <oSplitter>:addView()

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> SLIDER [ <oSlider> ] ;
             [ VALUE <nValue> ] ;
             [ OF <oWnd> ] ;
		         [ <change: ON CLICK, ON CHANGE> <uAction,...> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
		      => ;
		         [ <oSlider> := ] TSlider():New( <nRow>, <nCol>, <nWidth>,;
		         <nHeight>, [<oWnd>], [\{| nValue | <uAction> \}],;
		         <nValue>, [<nAutoResize>], [<(oSlider)>] , <(uAction)> )
 
#xcommand REDEFINE SLIDER [ <oSlider> ] [ VALUE <nValue> ];
             [ ID <nId> ] ;
             [ <of: OF, PARENT, DIALOG, WINDOW> <oWnd> ] ;
             [ <change: ON CLICK, ON CHANGE> <uAction,...> ] ;
          => ;
             [ <oSlider> := ] TSlider():Redefine( <nId>, <oWnd>,;
             [\{||(<uAction>)\}], < nValue> )   
              
//----------------------------------------------------------------------------//
                                                                      
#xcommand @ <nRow>, <nCol> SEGMENTBTN [ <oBtn> ] ;
             [ OF <oWnd> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
             [ ACTION <uAction,...> ] ;
		         [ <it: PROMPTS, ITEMS> <aItems> ] ;
		         [ <im: IMAGES, BITMAPS > <aImages> ] ;
		         [ STYLE <nStyle> ] ;
		         [ TRACKING <nTracking> ] ;
		         [ AUTORESIZE <nAutoResize> ] ;
		      => ;
		         [ <oBtn> := ] TSegment():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		         <oWnd>, [\{||(<uAction>)\}], <aItems>, [ <aImages> ], [ <nStyle> ],;
             [ <nTracking> ], [<nAutoResize>] )

#xcommand REDEFINE SEGMENTBTN [ <oBtn> ] ;
             [ ID <nId> ] ;         
             [ OF <oWnd> ] ;
		         [ ACTION <uAction,...> ] ;
	   	    => ;
		         [ <oBtn> := ] TSegment():Redefine( <nId>, <oWnd>,;
		         [\{||(<uAction>)\}] )
		         
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> SIMAGE [ <oImage> ] ;
             [ FILENAME <cFileName> ] ;
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
          => ;
             [ <oImage> := ] TSimage():New( <nRow>, <nCol>, <nWidth>,;
             <nHeight>, <oWnd>,[<(cFileName)>] )

//----------------------------------------------------------------------------//

 #xcommand @ <nRow>, <nCol> FOLDER [ <oFld> ] ;
             [ OF <oWnd> ] ;
		         [ SIZE <nWidth>, <nHeight> ] ;
		         [ PAGES <pages,...> ] ;
		         [ ON CHANGE <uChange,...> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
             [ <lFlipped: FLIPPED> ] ;
             [ PIXEL ] ;
		      => ;
		         [ <oFld> := ] TTabs():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
		         <oWnd>, [\{<pages>\}], [\{| nTab |(<uChange>)\}], [<nAutoResize>], [<(oFld)>] ,;
	          [<.lFlipped.>] , [(<uChange>)] )

#xcommand @ <nRow>, <nCol> TABS [ <oTabs> ] ;
             [ <items: PROMPTS, ITEMS> <aPrompts> ] ;
             [ OF <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ON CHANGE <uChange,...> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
             [ <lFlipped: FLIPPED> ] ;
             [ PIXEL ] ;
		      => ;
	           [ <oTabs> := ] TTabs():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <oWnd>,;
	           <aPrompts>, [\{| nTab |(<uChange>)\}], [<nAutoResize>], [<(oTabs)>],;
	           [<.lFlipped.>] , [(<uChange>)] )
    
#xcommand REDEFINE TABS [ <oTabs> ] ;
             [ ID <nId> ] ;   
             [ OF <oWnd> ] ;
             [ ON CHANGE <uChange,...> ] ;
          => ;
	           [ <oTabs> := ] TTabs():Redefine( <nId>, <oWnd>,;
	           [\{| nTab |(<uChange>)\}] )
 
//----------------------------------------------------------------------------//
                 
#xcommand DEFINE ROOTNODE oNode => oNode := TNode():New()	

#xcommand DEFINE NODE [ <oNode> PROMPT ] <cPrompt> ;
             [ OF <oNodeParent> ] ;
             [ <lgroup: GROUP> ] ;
          => ;
	 	         [ <oNode> := ] TNode():New( <cPrompt>, [<.lgroup.>], <oNodeParent> )
              
#xcommand DEFINE SEPARATOR NODE [ <oNode>  ]  ;
             [ OF <oNodeParent> ] ;
             [ <lgroup: GROUP> ] ;
          => ;
	 	         [ <oNode> := ] TNode():New( "Separator", [<.lgroup.>], <oNodeParent> )              

#xcommand ACTIVATE ROOTNODE <oNode> => <oNode>:Rebuild()

//----------------------------------------------------------------------------//

#xcommand @ <nTop>, <nLeft> <outline: OUTLINE, TREE> <oOut> ;
            [ TITLE <cTitle> ] ;
            [ SIZE <nBottom>, <nRight> ] ;
            [ OF <oWnd> ] ;
            [ <lnoselected: NO SELECTED > ] ; 
            [ NODE <oNode> ] ;
            [ AUTORESIZE <nAutoResize> ] ;
            [ ACTION <uAction,...> ] ;	 
         => ;
            <oOut> := TOutline():New( <nTop>, <nLeft>, <nBottom>, <nRight>,<oWnd>,;
        	 	[<.lnoselected.>],<oNode> , [\{||(<uAction>)\}] , <nAutoResize>, <cTitle> )

#xcommand REDEFINE <outline: OUTLINE, TREE> <oOut> ;
            [ ID <nId> ] ;  
            [ OF <oWnd> ] ;
            [ NODE <oNode> ] ;
             => ;
        <oOut> := TOutline():Redefine( <nId>, <oWnd>,<oNode> )

//----------------------------------------------------------------------------//
        
#xcommand DEFINE SOUND <oSound> [ FILE  <cFile> ];
                 => ;
		     [ <oSound> := ] TSound():New( <cFile> )
		     
#xcommand SOUND PLAY <oSound> => <oSound>:Play()

//----------------------------------------------------------------------------//
        
#xcommand DEFINE MAIL <oMail> [ TO  <cTo> ];
             [ SUBJECT <cSubject> ];
             [ FROM <cFrom> ];
             [ MESSAGE <cMsg> ];
             [ ATTACHS <attachs, ...> ] ;
          => ;
		         [ <oMail> := ] TMail():New( <cTo> ,<cSubject>, <cFrom>, <cMsg>,;
		         [\{ <attachs> \}])

#xcommand MAIL SEND <oMail> => <oMail>:send()

#xcommand MAIL <oMail> ATTACH <cfile>  => <oMail>:addAttach(<cfile>)

//----------------------------------------------------------------------------//
        
#xcommand DEFINE ITUNES <oItunes> ;
             [VOLUME <nVolume> ] ;
          => ;
		         [ <oItunes> := ] TItunes():New( <nVolume> )

//----------------------------------------------------------------------------//
   
#xcommand @ <nRow>, <nCol> PROGRESS <oPrg> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <pos: POS, POSITION> <nPos> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ AUTORESIZE <nAutoResize> ] ;
          => ;
             <oPrg> := TProgress():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <oWnd>, [<nPos>], [<nAutoResize>], [<(oPrg)>] )             
   
#xcommand REDEFINE PROGRESS <oPrg> ;
             [ ID <nId> ] ; 
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <pos: POS, POSITION> <nPos> ] ;
          => ;
             <oPrg> := TProgress():Redefine( <nId>,<oWnd>, [<nPos>] )                       
                 
//----------------------------------------------------------------------------//
                            
#endif