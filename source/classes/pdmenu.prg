// PullDown menu support functions - (c) FiveTech Software 2006

static aMenus := {}, cLastPrompt := ""

//---------------------------------------------------------------------------//

function MenuBegin( lPopup )

   AAdd( aMenus, TMenu():New( cLastPrompt, lPopup ) )

return ATail( aMenus )

//---------------------------------------------------------------------------//

function MenuAddItem( cPrompt, bAction, cKey ,cImage)

   cLastPrompt = cPrompt

return ATail( aMenus ):AddItem( cPrompt, bAction, cKey ,cImage) 

//---------------------------------------------------------------------------//

function MenuAddSeparator()

   ATail( aMenus ):AddSeparator()
   
return nil   

//---------------------------------------------------------------------------//

function MenuEnd()

   local oMenu := ATail( aMenus )

   if Len( aMenus ) > 1
      ASize( aMenus, Len( aMenus ) - 1 )
      ATail( aMenus ):SetSubMenu( oMenu )
   else
      if ! ATail( aMenus ):lPopup 
         ATail( aMenus ):Activate() 
      endif     
      aMenus = {}
   endif   

return nil

//---------------------------------------------------------------------------//

function ShowPopupMenu( oMenu, oWnd, nRow, nCol )

  oWnd:oPopup = oMenu
  
  PopMnuShow( oMenu:hMenu, oWnd:hWnd,;
              If( oWnd:lFlipped, oWnd:nHeight - nRow, nRow ), nCol )

  oWnd:oPopup = nil

return nil

//---------------------------------------------------------------------------//