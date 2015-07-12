#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TSegment FROM TControl

   DATA   bAction
   DATa   aSegments

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, bAction, aSegments, aImages,;
               nStyle, nTracking ,nAutoResize )

   METHOD Redefine( nId, oWnd, bAction )

   METHOD SetCount( nSegments ) INLINE SegmentSetCount( ::hWnd, nSegments )

   METHOD SetLabel( nSegments, cLabel ) INLINE ;
          SegmentSetLabel( ::hWnd, nSegments - 1, cLabel )

   METHOD SelectedItem() INLINE  SEGMENTSELECT(::Hwnd)+1

   METHOD Click() INLINE Eval( ::bAction, ::SelectedItem() )

   METHOD SetStyle( nStyle ) INLINE SegmentSetStyle( ::hWnd, nStyle )
   
   METHOD SetEnabled( lEnabled, nSegment ) INLINE ;
          SegmentSetEnabled( ::hWnd, lEnabled, nSegment - 1 )
   
   METHOD SetImg( cFileImg, nSegment ) INLINE If( File( cFileImg ),;
          ( SegmentSetImage( ::hWnd, cFileImg, nSegment - 1 ),;
            SegmentSetImageScaling( ::hWnd, nSegment - 1 ) ), )

   METHOD SetTracking(nTrack) INLINE SegmentSetTrack(::hWnd,nTrack)

   METHOD SetMenu( oMenu, nSegment ) INLINE ;
          SegmentSetMenu( ::hWnd, oMenu:hMenu, nSegment - 1 )
   
   METHOD SetItemWidth( nWidth ) INLINE SegmentSetWidth( ::hWnd, nWidth , nSegment-1 )
   
   METHOD Initiate()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd,bAction , aSegments, aImages,;
            nStyle, nTracking  , nAutoResize ) CLASS TSegment

   DEFAULT nWidth := 90, nHeight := 30, oWnd := GetWndDefault()
   DEFAULT aSegments:= {}
   DEFAULT aImages := {}
   DEFAULT nStyle:= 5

   ::hWnd = SegmentCreate( nTop, nLeft, nWidth, nHeight, oWnd:hWnd )

   ::aSegments = aSegments

   if Len( ::aSegments ) > 0
      ::SetCount( Len( ::aSegments ) )
      AEval( ::aSegments , { | obj, ele | ::SetLabel( ele, ::aSegments[ ele ] ) } )
      if Len( aImages ) > 0
         AEval( aImages, { | cImg, ele | ::SetImg( cImg, ele ) } )
      endif
   endif

   ::SetStyle( nStyle )

   if ! Empty( nTracking )
      ::SetTracking( nTracking )
   endif

   ::nAutoResize = nAutoResize

   ::oWnd  = oWnd
   ::bAction = bAction
   
   oWnd:AddControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, bAction ) CLASS TSegment

   DEFAULT oWnd := GetWndDefault()

   ::nId     = nId
   ::oWnd    = oWnd
   ::bAction = bAction

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate() CLASS TSegment

   local hWnd := SegmentResCreate( ::oWnd:hWnd, ::nId )

   if hWnd != 0
      ::hWnd = hWnd
   else
      MsgAlert( "Non defined ID " + ;
                AllTrim( Str( ::nId ) ) + ;
                " in resource " + ::oWnd:cNibName )
   endif

return nil

//----------------------------------------------------------------------------//