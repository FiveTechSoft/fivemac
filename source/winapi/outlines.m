#include <fivemac.h>
#import <Foundation/Foundation.h>

@interface ImageAndTextCell : NSTextFieldCell
{
   @private
   NSImage *image;
}

- ( void ) setImage: ( NSImage * ) anImage;
- ( NSImage * ) image;
- ( void ) drawWithFrame: ( NSRect ) cellFrame inView: ( NSView * ) controlView;
- ( NSSize ) cellSize;

@end

@interface SeparatorCell : NSTextFieldCell
{}

@end

@class Node;

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface MDataSource : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate>  
#else
   @interface MDataSource : NSObject  
#endif
{
   Node * rootNode;
   BOOL isdisclo ;
}

- (void) SetDisclo: ( BOOL ) ldisclo;
- (void) setRootNode: ( Node * ) mynode;
	
@end

@interface Node : NSObject
{
   NSString * name;
	 NSMutableArray * children;
	 BOOL isGroup;
   NSString * bmp;
}

@property ( readwrite, retain ) NSString * name;
@property ( readwrite, retain ) NSMutableArray * children;
@property ( readwrite ) BOOL isGroup;
@property ( readwrite, retain ) NSString * bmp;

@end

@implementation Node

@synthesize name, children, isGroup, bmp;

- ( id ) init
{
	self = [ super init ];
	
	if( self )
	{
	   self.name = nil;
     self.bmp = nil;
		 self.children = [ NSMutableArray array ];
		 self.isGroup = NO;
	}
	
	return self;
}

- ( void ) dealloc
{
   self.name = nil;
   self.bmp = nil;
	 self.children = nil;
	 
	 [ super dealloc ];
}

@end

@implementation MDataSource 

- ( void ) SetDisclo: ( BOOL ) ldisclo
{
   isdisclo = ldisclo;
}

- ( void ) createNode 
{
  rootNode = [ [ Node alloc ] init ];
}

- ( void ) setRootNode: ( Node * ) mynode
{
   rootNode = mynode ;
}

// Data Source methods

- ( NSInteger ) outlineView: ( NSOutlineView * ) outlineView numberOfChildrenOfItem: ( id) item
{
   Node * node = item == nil ? rootNode : ( Node * ) item;
	 
	 return [ node.children count ];
}

- ( BOOL ) outlineView: ( NSOutlineView * ) outlineView isItemExpandable: ( id ) item
{
   Node * node = ( Node * ) item;
	 
	 return node.isGroup;
}

- ( id ) outlineView: ( NSOutlineView * ) outlineView child: ( NSInteger ) index ofItem: ( id ) item
{
   Node * node = item == nil ? rootNode : ( Node * ) item;
	 
	 return [ node.children objectAtIndex: index ];
}

- ( id ) outlineView: ( NSOutlineView * ) outlineView objectValueForTableColumn: ( NSTableColumn * ) tableColumn byItem: ( id ) item
{
	Node * node = ( Node * ) item;
  ImageAndTextCell * imageCell = [ [ [ ImageAndTextCell alloc ] init ] autorelease ];
  
  [ tableColumn setDataCell: imageCell ];	
  
  return node.name;
}

// Delegate methods

- ( BOOL ) outlineView: ( NSOutlineView * ) outlineView isGroupItem: ( id ) item
{
	//Node *node = (Node *)item;
    return ! isdisclo;
}

// -------------------------------------------------------------------------------
//	dataCellForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- ( NSCell *) outlineView: ( NSOutlineView * ) outlineView dataCellForTableColumn: ( NSTableColumn *) tableColumn item: ( id ) item
{
    NSCell* returnCell = [tableColumn dataCell];
    Node * node = ( Node * ) item;

   	if ( [node.name isEqualToString:@"Separator"  ])
    {
		   SeparatorCell * separatorCell = [ [ SeparatorCell alloc ] init ];
       [ separatorCell setEditable: NO ];
       returnCell = separatorCell;
    }
	 return returnCell;
}

- (void)outlineView:(NSOutlineView *)outlineView
        willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    Node *node = (Node *)item;
    NSImage *image1 ;
    NSFileManager * filemgr = [ NSFileManager defaultManager ];
    
    if( [ filemgr fileExistsAtPath: node.bmp ] )
       image1 =   [ [ NSImage alloc ] initWithContentsOfFile : node.bmp ]  ; 
    else 
    {
       // NSBeep();	  	
      image1 = ImgTemplate( node.bmp ) ;
    }    
    
  //  NSImage *image1 =   [ [ NSImage alloc ] initWithContentsOfFile : node.bmp ]  ; 
     
    [(ImageAndTextCell*)cell setImage:image1];
    [(ImageAndTextCell*)cell setTitle:node.name];    
}

@end

@interface MOutlineView : NSOutlineView
{
}
@end

@implementation  MOutlineView
   
@end

//----------------------------------------------------------------------------------

HB_FUNC( OUTLINECREATE ) 
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   NSScrollView * sv = [ [ NSScrollView alloc ] 
                       initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
    
   MOutlineView * outlineView = [[MOutlineView alloc] initWithFrame: [ [sv contentView] frame]];    
   MDataSource * data = [ [ MDataSource alloc ] init ];
     
   [ sv setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable ];
    
   [ sv setHasVerticalScroller: YES ];
   [ sv setHasHorizontalScroller: YES ];
   [ sv setBorderType: NSBezelBorder ];

   [ sv setAutoresizesSubviews: YES ];
   
   [ sv setDocumentView: outlineView ];		
   [ GetView( window ) addSubview: sv ];
     
   [ data createNode ];
    
   [ outlineView setDataSource: data ];
   [ outlineView setDelegate: data ];
   
   // scroll to the top in case the outline contents is very long
	 [ [ [ outlineView enclosingScrollView ] verticalScroller ] setFloatValue: 0.0 ];
	 [ [ [ outlineView enclosingScrollView ] contentView ] scrollToPoint: NSMakePoint( 0, 0 ) ];
    
   [ data SetDisclo: YES ]; 
    
    if (hb_parl( 6 ) ) 
       [ outlineView setSelectionHighlightStyle: 0 ];
    else
       [ outlineView setSelectionHighlightStyle: 1 ];
    
   [ outlineView setIndentationMarkerFollowsCell: YES ] ;
       
   NSTableColumn * c =  [[[NSTableColumn alloc] initWithIdentifier: @"NAME"] autorelease ];
   [ c setEditable: NO ];
   [ c setMinWidth: hb_parnl( 3 ) ];
     
   [ [ c headerCell ] setStringValue: @"Header" ];
   [ [ c headerCell ] setAlignment: NSCenterTextAlignment ];
    
	 [ outlineView addTableColumn: c ];
   [ outlineView setOutlineTableColumn: c ];
   [ outlineView setAction: @selector( BtnClick: ) ];
   [ outlineView reloadData ];   
     
   hb_retnl( ( HB_LONG ) outlineView );
}   

HB_FUNC( CREATEOUTLINERESOURCES )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   MOutlineView * outlineView = ( MOutlineView * ) [ GetView( window ) viewWithTag: hb_parnl( 2 ) ];
   MDataSource * data = [ [ MDataSource alloc ] init ];
   
   [ data createNode ];
    
   [ outlineView setDataSource : data ];
   [ outlineView setDelegate : data ];
    
   [ data SetDisclo: NO ] ;   
    
   [ outlineView setIndentationMarkerFollowsCell: YES ] ;   
         
   [ outlineView setAction: @selector( BtnClick: ) ];
   [ outlineView reloadData ];   
    
   hb_retnl( ( HB_LONG ) outlineView );
}

HB_FUNC( OUTLINESELECTORSTYLE ) // oBrw:hWnd, nHightLightStyle
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
    if( hb_parl( 2 ) )
       [ outlineView setSelectionHighlightStyle: 1 ];  
    else
       [ outlineView setSelectionHighlightStyle: 0 ];    
} 

HB_FUNC( OUTLINEGETITEMNAME )
{ 
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   NSString * string =  [ [ outlineView itemAtRow: [ outlineView selectedRow ] ] name ] ;
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( OUTLINEGETROWS )
{ 
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   hb_retnl( [ outlineView numberOfRows ] );
}

HB_FUNC( OUTLINEGETITEM )
{ 
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   hb_retnl( ( HB_LONG ) [ outlineView itemAtRow: [ outlineView selectedRow ] ] );
}

HB_FUNC( OUTLINEITEMATROW )
{ 
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   hb_retnl( ( HB_LONG ) [ outlineView itemAtRow: hb_parnl( 2 ) ] );
}

HB_FUNC( OUTLINESETITEM ) // oBrw:hWnd, nindex
{ 
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
   
   [ outlineView selectRowIndexes: [ NSIndexSet indexSetWithIndex: hb_parnl( 2 ) ] byExtendingSelection: NO ];
}    

HB_FUNC( OUTLINESETROOTNODE )
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
   Node * rootNode = ( Node * ) hb_parnl( 2 );
    
   [ ( ( MDataSource * ) [ outlineView dataSource ] ) setRootNode: rootNode  ];  
   [ outlineView reloadData ];
}

HB_FUNC( OUTLINESETDISCLO )
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
    
   [ ( ( MDataSource * ) [ outlineView dataSource ] ) SetDisclo : hb_parl( 2 ) ];  
}

HB_FUNC( OUTLINESETHEADERTITLE )
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ) ;
   NSTableColumn * col = [ outlineView outlineTableColumn ];
    
   [ [ col headerCell ] setStringValue: string ];
}

HB_FUNC( OUTLINESETALTERNATECOLOR )
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   [outlineView setUsesAlternatingRowBackgroundColors: hb_parl( 2 ) ];   
}

HB_FUNC( OUTLINESETNOHEAD ) // hTableView
{
   MOutlineView * outlineView   = ( MOutlineView * ) hb_parnl( 1 );
   NSTableHeaderView * backhead = [ outlineView headerView ] ;
   
   [ outlineView setHeaderView: NULL ];    
   
   hb_retnl( ( HB_LONG ) backhead );
}

HB_FUNC( OUTLINESHOWHEAD )
{
   MOutlineView * outlineView   = ( MOutlineView * ) hb_parnl( 1 );
   NSTableHeaderView * backhead = [ outlineView headerView ] ;
   NSTableHeaderView * head     = ( NSTableHeaderView * ) hb_parnl( 2 );  
    
   if( hb_parl( 3 ) )
      [ outlineView setHeaderView: head ];
   else
      [ outlineView setHeaderView: NULL ]; 
    
   hb_retnl( ( HB_LONG ) backhead );
}

HB_FUNC( OUTLINEREFRESH )
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   [ outlineView reloadData ];  
}
 
HB_FUNC( OUTLINEROWFORITEM )
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   hb_retnl( [ outlineView rowForItem: ( id ) hb_parnl( 2 ) ] );  
}

HB_FUNC( OUTLINEEXPANDALL )
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
   
   [ outlineView expandItem: nil expandChildren: YES ];
}

HB_FUNC( OUTLINEAUTORESIZECOLUMN ) // hTableView
{
   MOutlineView * outlineView = ( MOutlineView * ) hb_parnl( 1 );
  
   [ outlineView setAutoresizesOutlineColumn: hb_parl( 2 ) ];
}

HB_FUNC( OUTLINESETCOLWIDTH ) // hTableView, nColumn, nWidth
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
    
   [ [ outlineView outlineTableColumn ] setWidth: hb_parnl( 2 ) ];    
   [ outlineView reloadData ];
} 

HB_FUNC( OUTLINESCROLLHSHOW )
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
   NSScrollView * sv = [outlineView enclosingScrollView ];
   
   [ sv setHasHorizontalScroller: hb_parl( 2 ) ] ;
}

HB_FUNC( OUTLINESCROLLVSHOW )
{
   MOutlineView * outlineView =  ( MOutlineView * ) hb_parnl( 1 );
   NSScrollView * sv = [outlineView enclosingScrollView ];
    
   [ sv setHasVerticalScroller: hb_parl( 2 ) ] ;
}

HB_FUNC( NODEROOTCREATE )
{
   Node * rootNode = [ [ Node alloc ] init ];
   
   hb_retnl( ( HB_LONG ) rootNode );
}
             
HB_FUNC( NODECREATE )
{
   NSString * string = hb_NSSTRING_par( 2 );
   NSString * cBmp   = hb_NSSTRING_par( 4 );
   Node * parentNode = ( Node * ) hb_parnl( 1 );
   Node * newNode1   = [ [ Node alloc ] init ];
   
   newNode1.name = string;
   newNode1.bmp = cBmp; 
 
   newNode1.isGroup = hb_parl( 3 );
   
   [ parentNode.children addObject: newNode1 ];
   [ newNode1 release ];
   
   hb_retnl( ( HB_LONG ) newNode1 );
}