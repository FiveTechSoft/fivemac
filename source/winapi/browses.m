#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1060
   @interface Wbrowse : NSTableView
#else
   @interface Wbrowse : NSTableView <NSTableViewDelegate, NSTableViewDataSource>
#endif
{
}
- ( void ) tableViewSelectionDidChange: ( NSNotification * ) aNotification;	
- ( void ) tableView: ( Wbrowse * ) tableView mouseDownInHeaderOfTableColumn: 
	                    ( NSTableColumn * ) aTableColumn;
- ( void ) keyDown : ( NSEvent *  ) theEvent;
- ( void ) drawRow: ( NSInteger ) row clipRect: ( NSRect ) clipRect;
- (void)tableView:(Wbrowse *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex ;
@end

@implementation Wbrowse
 
- ( void ) tableViewSelectionDidChange: ( NSNotification * ) aNotification
{
	if( symFMH == NULL )
		symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
	
	hb_vmPushSymbol( symFMH );
	hb_vmPushNil();
	hb_vmPushLong( ( HB_LONG ) [ self window ] );
	hb_vmPushLong( WM_BRWCHANGED );
	hb_vmPushLong( ( HB_LONG ) self );
	hb_vmDo( 3 );
}

- ( void ) tableView: ( Wbrowse * ) tableView mouseDownInHeaderOfTableColumn: 
	                  ( NSTableColumn * ) aTableColumn
{
   if( symFMH == NULL )
	    symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
	
	 hb_vmPushSymbol( symFMH );
	 hb_vmPushNil();
	 hb_vmPushLong( ( HB_LONG ) [ tableView window ] );
	 hb_vmPushLong( WM_HEADCLICK );
	 hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( [ [ ( NSTableColumn * ) aTableColumn identifier ] integerValue ] );
	 hb_vmDo( 4 );
}

- ( void ) keyDown : ( NSEvent * ) theEvent
{
   // unsigned int flags = [ theEvent modifierFlags ]; 
   NSString * key = [ theEvent characters ]; 
   int unichar = [ key characterAtIndex: 0 ];
   
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ]  );
   hb_vmPushLong( WM_KEYDOWN );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( unichar );
   hb_vmDo( 4 );
   
   if( hb_parnl( -1 ) != 1 )
      [ super keyDown: theEvent ];
}	

- ( void ) drawRow: ( NSInteger ) row clipRect: ( NSRect ) clipRect
{

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ]  );
   hb_vmPushLong( WM_BRWDRAWRECT );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( row );
   hb_vmDo( 4 );
  
  // NSColor * color = ( row % 2 ) ? [ NSColor lightGrayColor ] : [ NSColor grayColor ];
  // [ color setFill ];
 //  NSRectFill( [ self rectOfRow: row ] );
 
   [ super drawRow: row clipRect: clipRect ];
}

- (void)tableView:( Wbrowse * ) aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
   if( ! [ [ aCell className ] isEqual : @"NSImageCell" ] )
   {
      if( symFMH == NULL )
         symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
    
      hb_vmPushSymbol( symFMH );
      hb_vmPushNil();
      hb_vmPushLong( ( HB_LONG ) [ self window ] );
      hb_vmPushLong( WM_BRWCLRTEXT );
      hb_vmPushLong( ( HB_LONG ) self );
      hb_vmPushLong( ( HB_LONG ) aTableColumn );
      hb_vmPushLong( rowIndex );
      hb_vmDo( 5 );
   
      [ aCell setTextColor: ( NSColor * ) hb_parnl( -1 ) ];
   }
}

@end

@interface BrwImageAndTextCell : NSTextFieldCell
{
   NSImage * image;
}
 
- ( void ) drawWithFrame: ( NSRect ) cellFrame inView: ( NSView *) controlView;
- ( NSSize ) cellSize;
 
@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1060
   @interface DataSource : NSObject
#else
   @interface DataSource : NSObject  <NSTableViewDataSource>
#endif
{
}
- ( NSInteger ) numberOfRowsInTableView : ( Wbrowse * ) aTableView;
- ( id ) tableView : ( Wbrowse * ) aTableView objectValueForTableColumn : ( NSTableColumn * ) aTableColumn row : ( NSInteger ) rowIndex;

- (void)tableView : ( Wbrowse * ) aTableView setObjectValue: ( id ) aData forTableColumn: ( NSTableColumn * )aTableColumn row :( NSInteger ) rowIndex ;

- (void)tableView:(Wbrowse *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex ;

@end

@implementation DataSource

- ( NSInteger ) numberOfRowsInTableView : ( Wbrowse * ) aTableView
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ aTableView window ] );
   hb_vmPushLong( WM_BRWROWS );
   hb_vmPushLong( ( HB_LONG ) aTableView );
   hb_vmDo( 3 );

   return ( NSInteger ) hb_parnl( -1 );	
}

- ( id ) tableView : ( Wbrowse * ) aTableView objectValueForTableColumn : ( NSTableColumn * ) aTableColumn row : ( NSInteger ) rowIndex
{
   NSString * string;
   NSCell * cell;

   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ aTableView window ] );
   hb_vmPushLong( WM_BRWVALUE );
   hb_vmPushLong( ( HB_LONG ) aTableView );

   hb_vmPushLong(  [ [ ( NSTableColumn * ) aTableColumn identifier ] integerValue ] ) ;    
   // hb_vmPushLong( ( ( TableColumn * ) aTableColumn )->id );
    
   hb_vmPushLong( rowIndex );
    
   hb_vmDo( 5 );
    
 //   NSLog( @"valor kencoding = %i", kencoding );
    
  
  string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( -1 ) ? hb_parc( -1 ) : "" encoding: NSWindowsCP1252StringEncoding ] autorelease ];
    
    cell = [ aTableColumn dataCell ];
   
   if( [ [ [ aTableColumn dataCell ] className ] isEqual : @"NSImageCell" ] ) // && hb_fsFile( hb_parc( -1 ) ) )
      return [ [ [ NSImage alloc ] initWithContentsOfFile : string ] autorelease ]; 
      	
   else if( [ [ [ aTableColumn dataCell ] className ] isEqual : @"BrwImageAndTextCell" ] )
   {	
      NSString * filename = [ [ [ NSString alloc ] initWithCString: hb_parvc( -1, 1 ) encoding: NSWindowsCP1252StringEncoding ] autorelease ];
      NSImage * image;
      
      if( hb_parvl( -1, 3 ) ) // Is an app
         image = [ [ NSWorkspace sharedWorkspace ] iconForFile: filename ];
      else   	
         image = [ [ [ NSImage alloc ] initWithContentsOfFile: filename ] autorelease ];
      	
      [ ( BrwImageAndTextCell * ) cell setImage: image ]; 
      
      return [ [ [ NSString alloc ] initWithCString: hb_parvc( -1, 2 ) encoding: NSWindowsCP1252StringEncoding ] autorelease ];
   }  
      	
  // else 
  // {   
  //    if ( [ [ [ aTableColumn dataCell ] className ] isEqual : @"NSButtonCell" ] )
  // {
  //     // NSLog(@"si");
  //     NSButtonCell *cell = [[[NSButtonCell alloc] init] autorelease];
  //     [cell setAllowsMixedState:YES];
  //     [(NSButtonCell *)cell setButtonType:NSSwitchButton];
  //     [cell setTitle: @"hola" ];
  //   //  return cell;  
  //     return [NSNumber numberWithBool:(rowIndex & 1)];
  //        }
       
   else	
      return string;
  // }    
}   

- (void)tableView:( Wbrowse * ) aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
   // NSLog(@"siyo"); 
   // NSBeep();   // this beep sounds, so NSTableViewDataSource also calls this willDisplayCell 
}

- (void) tableView: ( Wbrowse * ) aTableView setObjectValue: ( id ) aData forTableColumn: ( NSTableColumn * ) aTableColumn row: ( NSInteger ) rowIndex 
{
	 // [ ourArray replaceObjectAtIndex: rowIndex withObject: anObject ];
      
   id loc_id = [ aTableColumn identifier ];
    
   if( [ loc_id isKindOfClass: [ NSString class ] ] )
   {
      if( symFMH == NULL )
         symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
        
      hb_vmPushSymbol( symFMH );
      hb_vmPushNil();
      hb_vmPushLong( ( HB_LONG ) [ aTableView window ] );
      hb_vmPushLong( WM_BRWSETVALUE );
      hb_vmPushLong( ( HB_LONG ) aTableView );
      hb_vmPushLong(  [ [ ( NSTableColumn * ) aTableColumn identifier ] integerValue ] ) ;    
      hb_vmPushLong( rowIndex );
      hb_vmPushLong( ( HB_LONG ) aData ) ;
      hb_vmDo( 6 );        
   }    
}

@end

HB_FUNC( BRWCREATE ) 
{
   NSScrollView * sv = [ [ NSScrollView alloc ] 
 		    	          initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   Wbrowse * browse;
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   DataSource * data = [ [ DataSource alloc ] init ];
   
   // [ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
   [ sv setHasVerticalScroller : YES ];
   [ sv setHasHorizontalScroller : YES ];
   [ sv setBorderType : NSBezelBorder ];

   browse = [ [ Wbrowse alloc ] 
 		   initWithFrame : [ [ sv contentView ] frame ] ];
   // [ browse setAllowsColumnSelection : YES ];
      
   [ sv setDocumentView : browse ];		   
   [ GetView( window ) addSubview : sv ];
   [ browse setDelegate : browse ];
   [ browse setDataSource : data ];
   [ browse setGridStyleMask : NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask ];
   
   [ browse setDoubleAction : @selector( BrwDblClick: ) ];
        
   hb_retnl( ( HB_LONG ) browse );
}  

HB_FUNC( BRWSETSIZE )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];

   [ sv setFrameSize: NSMakeSize( hb_parnl( 2 ), hb_parnl( 3 ) ) ];   
}

HB_FUNC( BRWRESCREATE )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    Wbrowse * browse =  (Wbrowse *) [  GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    NSTableColumn * column;
    int i;
     
    DataSource * data = [ [ DataSource alloc ] init ];
    
    [ browse setDelegate: browse ];
    [ browse setDataSource: data ];
    [ browse setDoubleAction: @selector( BrwDblClick: ) ];      

   	for( i = 0; i < [ browse numberOfColumns ]; i++ )   
    {
       column = [ [ browse tableColumns ] objectAtIndex : i ]; 
      // column->id = i ;  
       [ column setIdentifier: [ NSString stringWithFormat: @"%i", i ] ]; 
    }
    
    hb_retnl( ( HB_LONG ) browse );   
}


HB_FUNC( BRWSETCOLORSFORALTERNATE )
{
    Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    NSInteger row = ( NSInteger ) hb_parni( 2 );
    NSColor * color1 =( NSColor * ) hb_parnl( 3 );  
    NSColor * color2 =( NSColor * ) hb_parnl( 4 );  
    NSColor * color = ( row % 2 ) ? color1 : color2 ;
    [ color setFill ];
    NSRectFill( [ browse rectOfRow: row ] );
}

HB_FUNC( BRWSETGRAYCOLORS )
{
  Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
  NSInteger row = ( NSInteger ) hb_parni( 2 );
  NSColor * color = ( row % 2 ) ? [ NSColor lightGrayColor ] : [ NSColor grayColor ];
  [ color setFill ];
  
  NSRectFill( [ browse rectOfRow: row ] );
}

HB_FUNC( BRWSETGRADICOLOR )
{
    
    Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    int row =  hb_parni( 2 ) ;
    
    NSGradient *gradient = ( NSGradient * ) hb_parnl( 3 );   
    
    if (gradient && ![[browse selectedRowIndexes] containsIndex:row])
	{
		NSRect rowRect = [browse rectOfRow:row];
		NSRect gradientRect = NSMakeRect(3.0, ([browse rowHeight]+[browse intercellSpacing].height)*row + 1.0, rowRect.size.width - 4.0, rowRect.size.height - 2.0);
		NSBezierPath *smallerPath = [NSBezierPath bezierPathWithRoundedRect:gradientRect xRadius:9.0 yRadius:9.0];
		[gradient drawInBezierPath:smallerPath angle:90.0];
	}
    
}

HB_FUNC( BRWADDCOLUMN )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   NSTableColumn * column = [ [ NSTableColumn alloc ] init ];
  
   // column->id = [ browse numberOfColumns ];
    
    int nCol = [ browse numberOfColumns ] ;
    
   [ column setIdentifier: [ NSString stringWithFormat:@"%i", nCol ] ] ;
   [ column setWidth: 100 ];
   [ [ column headerCell ] setStringValue: string ];

   [ browse addTableColumn: column ];

   hb_retnl( ( HB_LONG ) column );
}   

HB_FUNC( COLSETHEADER )
{
   NSTableColumn * column = ( NSTableColumn * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );

   [ [ column headerCell ] setStringValue: string ];
}   

HB_FUNC( BRWREFRESH )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   	
   [ browse reloadData ];
}   

HB_FUNC( BRWGOTOP )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   	
   [ browse selectRowIndexes : [ [ NSIndexSet alloc ] initWithIndex : 0 ] byExtendingSelection : FALSE ];
   [ browse scrollRowToVisible : 0 ];   
}

HB_FUNC( BRWGOBOTTOM )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   DataSource * ds = ( DataSource * ) [ browse dataSource ];
   int iRows = [ ds numberOfRowsInTableView : browse ];
   
   [ browse selectRowIndexes : [ [ NSIndexSet alloc ] initWithIndex : iRows - 1 ] byExtendingSelection : FALSE ];
   [ browse scrollRowToVisible : iRows - 1 ];   
}

HB_FUNC( BRWSETCOLBMP ) // hTableView, nColumn
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   NSTableColumn * column =  [ [ browse tableColumns ] objectAtIndex : ( hb_parnl( 2 ) - 1 ) ];
   NSImageCell * imageCell = [ [ [ NSImageCell alloc ] init ] autorelease ];
   
   [ column setDataCell : imageCell ]; 
}

HB_FUNC( BRWSETCOLBMPTXT ) // hTableView, nColumn
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   NSTableColumn * column =  [ [ browse tableColumns ] objectAtIndex : ( hb_parnl( 2 ) - 1 ) ];
   BrwImageAndTextCell * imgTxtCell = [ [ [ BrwImageAndTextCell alloc ] init ] autorelease ];
   
   [ column setDataCell : imgTxtCell ]; 
}

#define kIconImageSize         22.0
 
#define kImageOriginXOffset     0
#define kImageOriginYOffset     0
 
#define kTextOriginXOffset      0
#define kTextOriginYOffset      0
#define kTextHeightAdjust       0
 
@implementation BrwImageAndTextCell
 
- ( void ) dealloc
{
   [ image release ];
   [ super dealloc ];
}
 
- ( id ) copyWithZone: (NSZone *)zone
{
    BrwImageAndTextCell * cell = ( BrwImageAndTextCell * ) [ super copyWithZone: zone ];
    cell.image = [ image retain ];
    return cell;
}
 
- ( void ) setImage: ( NSImage * ) anImage
{
    if( anImage != image ) 
    {
       [ image release ];
       image = [ anImage retain ];
       [ image setSize: NSMakeSize( kIconImageSize, kIconImageSize ) ];
    }
}
 
- (NSImage *)image
{
    return image;
}
 
- (BOOL)isGroupCell
{
    return ([self image] == nil && [[self title] length] > 0);
}
 
// -------------------------------------------------------------------------------
//  titleRectForBounds:cellRect
//
//  Returns the proper bound for the cell's title while being edited
// -------------------------------------------------------------------------------
- (NSRect)titleRectForBounds:(NSRect)cellRect
{   
    // the cell has an image: draw the normal item cell
    NSSize imageSize;
    NSRect imageFrame;
 
    imageSize = [image size];
    NSDivideRect(cellRect, &imageFrame, &cellRect, 3 + imageSize.width, NSMinXEdge);
 
    imageFrame.origin.x += kImageOriginXOffset;
    imageFrame.origin.y -= kImageOriginYOffset;
    imageFrame.size = imageSize;
    
    imageFrame.origin.y += ceil((cellRect.size.height - imageFrame.size.height) / 2);
    
    NSRect newFrame = cellRect;
    newFrame.origin.x += kTextOriginXOffset;
    newFrame.origin.y += kTextOriginYOffset;
    newFrame.size.height -= kTextHeightAdjust;
 
    return newFrame;
}
 
// -------------------------------------------------------------------------------
//  editWithFrame:inView:editor:delegate:event
// -------------------------------------------------------------------------------
- (void)editWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject event:(NSEvent*)theEvent
{
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}
 
// -------------------------------------------------------------------------------
//  selectWithFrame:inView:editor:delegate:event:start:length
// -------------------------------------------------------------------------------
- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    NSRect textFrame = [self titleRectForBounds:aRect];
    [super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}
 
- ( void ) drawWithFrame: ( NSRect ) cellFrame inView: ( NSView * ) controlView
{
    if( image != nil )
    {
       NSSize imageSize = [ image size ];
       NSRect imageFrame;
 
       NSDivideRect( cellFrame, &imageFrame, &cellFrame, 3 + imageSize.width, NSMinXEdge );
 
       imageFrame.origin.x += kImageOriginXOffset;
       imageFrame.origin.y -= kImageOriginYOffset;
       imageFrame.size = imageSize;

       NSRect newFrame = cellFrame;
       // newFrame.origin.x += kTextOriginXOffset;
       newFrame.origin.x -= 25;
       newFrame.size.width += 25;
       // newFrame.origin.y += kTextOriginYOffset;
       // newFrame.size.height -= kTextHeightAdjust;
        
       [ super drawWithFrame: newFrame inView: controlView ];
 
       [image drawInRect:imageFrame
                    fromRect:NSZeroRect
                   operation:NSCompositeSourceOver
                    fraction:1.0
              respectFlipped:YES
                       hints:nil];
           
         
        
    }
    else
    {
       if( [ self isGroupCell ] )
       {
          // Center the text in the cellFrame, and call super to do thew ork of actually drawing. 
          CGFloat yOffset = floor((NSHeight(cellFrame) - [[self attributedStringValue] size].height) / 2.0);
            
          cellFrame.origin.y += yOffset;
          cellFrame.size.height -= (kTextOriginYOffset*yOffset);
 
          [ super drawWithFrame: cellFrame inView: controlView ];
       }
    }
}
 
- ( NSSize ) cellSize
{
   NSSize cellSize = [ super cellSize ];
   cellSize.width += ( image ? [ image size ].width : 0 ) + 3;
   return cellSize;
}
 
@end

/*
HB_FUNC( BRWSETCOLBTN ) // hTableView, nColumn
{
    Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    NSTableColumn * column =  [ [ browse tableColumns ] objectAtIndex : ( hb_parnl( 2 ) - 1 ) ];
    NSButtonCell * buttonCell = [ [ [ NSButtonCell alloc ] init ] autorelease ];
    
    [ column setDataCell : buttonCell ]; 
}
*/
HB_FUNC( BRWROWPOS )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );

   hb_retnl( [ browse selectedRow ] == -1 ? 1: [ browse selectedRow ] + 1 );
}   

HB_FUNC( BRWSETROWPOS )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
	 int iRows;
	 
	 [ browse selectRowIndexes : [ [ NSIndexSet alloc ] initWithIndex :  hb_parnl( 2 ) - 1 ] byExtendingSelection : FALSE ];
	 iRows = [ browse selectedRow ];
	
	 [ browse scrollRowToVisible : iRows + 1 ]; 	
}   


HB_FUNC( BRWSETCOLWIDTH ) // hTableView, nColumn, nWidth
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    
   [ [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] setWidth : hb_parnl( 3 ) ];    
   [ browse reloadData ];
} 

HB_FUNC( BRWGETCOLWIDTH ) // hTableView, nIndex --> nWidth
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    
   hb_retnl( [ [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] width ] );    
} 

HB_FUNC( BRWSETROWHEIGHT ) // hTableView, nRowHeight
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );   

   [ browse setRowHeight : hb_parnl( 2 ) ];    
}  

HB_FUNC( BRWGETROWHEIGHT ) // hTableView --> nRowHeight
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );   

   hb_retnl( [ browse rowHeight ] );    
} 

HB_FUNC( BRWSETALTCOLOR ) // hTableView, lOnOff
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );  

   [ browse setUsesAlternatingRowBackgroundColors : hb_parl( 2 ) ];    
}

HB_FUNC( BRWSETFONT )
{
   NSTableView * tv = ( NSTableView * ) hb_parnl( 1 );
   NSString * name  = hb_NSSTRING_par( 2 );
   NSArray * tableColumns = [ tv tableColumns ];
   unsigned int columnIndex = [tableColumns count];
   NSFont * font = [ [ NSFont fontWithName : name 
                      size : hb_parnl( 3 ) ] autorelease ];
   
   while( columnIndex-- )
      [ [ ( NSTableColumn * ) [ tableColumns objectAtIndex: columnIndex ] dataCell ] 
      	setFont: font ];

   [ tv reloadData ];                   	
}   
   	
HB_FUNC( BRWSETGRIDLINES )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );  
   int iType = hb_parnl( 2 );
   
   switch( iType )
   {
      case 1:
         [ browse setGridStyleMask : NSTableViewGridNone ];
         break;
         
      case 2:   	
         [ browse setGridStyleMask : NSTableViewSolidHorizontalGridLineMask ];
         break;
         
      case 3:   	
         [ browse setGridStyleMask : NSTableViewSolidVerticalGridLineMask ];
         break;
         
      default:   	   
         [ browse setGridStyleMask : NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask ];
         break;
   }      
} 

HB_FUNC( BRWGETGRIDLINES )
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 ); 
   
   hb_retnl( [ browse gridStyleMask ] );
}
 
HB_FUNC( BRWSETCOLEDITABLE ) // hTableView, nIndex, lOnOff
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    
   [ [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] setEditable : hb_parl( 3 ) ];    
} 

HB_FUNC( BRWSETHEADTOOLTIP ) // hTableView, nIndex, cText
{
   Wbrowse * browse  = ( Wbrowse  * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 3 );
    
   [ [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] setHeaderToolTip : string ];    
} 

HB_FUNC( BRWSETNOHEAD ) // hTableView
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   
   [ browse setHeaderView : NULL ];    
} 

HB_FUNC( BRWSETINDICATORDESCENT ) // oBrw:hWnd, nCol
{
   Wbrowse  * browse = ( Wbrowse * ) hb_parnl( 1 );
    
   [ browse setIndicatorImage : [ NSImage imageNamed : @"NSDescendingSortIndicator" ]
      inTableColumn: [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] ];  
}

HB_FUNC( BRWSETNOINDICATOR ) // oBrw:hWnd, nCol
{
	Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
    
	[ browse setIndicatorImage : nil
				  inTableColumn: [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] ];  
}

HB_FUNC( BRWSETINDICATORASCEND ) // oBrw:hWnd, nCol
{
   Wbrowse * browse = ( Wbrowse * ) hb_parnl( 1 );
   
   [ browse setIndicatorImage : [ NSImage imageNamed : @"NSAscendingSortIndicator" ]
      inTableColumn : [ [ browse tableColumns ] objectAtIndex : hb_parnl( 2 ) - 1 ] ];  
}

HB_FUNC( BRWSETSELECTORSTYLE ) // oBrw:hWnd, nHightLightStyle
{
   Wbrowse  * browse = ( Wbrowse  * ) hb_parnl( 1 );
   
   [ browse setSelectionHighlightStyle: hb_parnl( 2 ) ];   
}

HB_FUNC( BRWGODOWN )
{
	Wbrowse  * browse = ( Wbrowse  * ) hb_parnl( 1 );
  int iRows = [ browse selectedRow ];
  
	[ browse selectRowIndexes : [ [ NSIndexSet alloc ] initWithIndex : iRows + 1 ] byExtendingSelection : FALSE ];
	[ browse scrollRowToVisible : iRows + 1 ]; 
}

HB_FUNC( BRWGOUP )
{
	Wbrowse  * browse = ( Wbrowse  * ) hb_parnl( 1 );
  // int iRows = [ browse selectedRow ] ;
	
	[ browse selectRowIndexes : [ [ NSIndexSet alloc ] initWithIndex : 0  ] byExtendingSelection : FALSE ];
	[ browse scrollRowToVisible : 0 ]; 
}

HB_FUNC( BRWSETDBLACTION )
{
	Wbrowse * browse = ( Wbrowse  * ) hb_parnl( 1 );
  
  [ browse setDoubleAction: @selector( BrwDblClick: ) ];
}

HB_FUNC( BRWSETACTION )
{
	Wbrowse * browse = ( Wbrowse  * ) hb_parnl( 1 );
  
  [ browse setAction: @selector( BrwDblClick: ) ];
}

HB_FUNC( BRWAUTOAJUST ) 
{
	NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );	
	NSScrollView * sv = [ browse enclosingScrollView ];
	
	[ sv setAutoresizingMask: hb_parnl( 2 ) ];		
}  

HB_FUNC( BRWSCROLLAUTOHIDE )
{
   NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];
   
   [ sv setAutohidesScrollers: hb_parl( 2 ) ] ;
}

HB_FUNC( BRWSCROLLSTYLE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070
      NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
      NSScrollView * sv = [ browse enclosingScrollView ];
   
      [ sv setScrollerStyle: hb_parnl( 2 ) ];
   #endif   	
}

HB_FUNC( BRWSCROLLVSHOW )
{
   NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];
   
   [ sv setHasVerticalScroller: hb_parl( 2 ) ];
}

HB_FUNC( BRWSCROLLHSHOW )
{
   NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];
   
   [ sv setHasHorizontalScroller : hb_parl( 2 ) ];
}

HB_FUNC( BRWSSETCROLLVGRAFITE )
{
   NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];
   NSScroller * scrol = [ sv verticalScroller ];
   
   [ scrol setControlTint: NSGraphiteControlTint ];
}

HB_FUNC( BRWSETBKCOLOR )
{
    NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                                    green: ( hb_parnl( 3 ) / 255.0 ) 
                                                     blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];    
    
    [  browse setBackgroundColor : color ] ;
}

HB_FUNC( BRWSETTEXTCOLOR )
{
    NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
    NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                                    green: ( hb_parnl( 3 ) / 255.0 ) 
                                                     blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];    
    
    [  [ browse cell ] setTextColor : color ] ;
}


HB_FUNC( BRWSSETCROLLHGRAFITE )
{
   NSTableView * browse = ( NSTableView * ) hb_parnl( 1 );
   NSScrollView * sv = [ browse enclosingScrollView ];
   NSScroller * scrol = [ sv horizontalScroller ];
   
   [ scrol setControlTint: NSGraphiteControlTint ];
}