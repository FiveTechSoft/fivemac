#include <fivemac.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface SearchGet : NSSearchField <NSTextFieldDelegate>
#else
   @interface SearchGet : NSSearchField
#endif
{
   @public NSWindow * hWnd;	
}
- ( BOOL ) textShouldEndEditing : ( NSText * ) text;
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification;	
@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface ToolBar : NSToolbar <NSToolbarDelegate>
#else
   @interface ToolBar : NSToolbar
#endif
{
 NSMutableArray *itemsSelectables;
}

- ( NSToolbarItem * ) toolbar : ( NSToolbar * ) aToolbar itemForItemIdentifier : ( NSString * ) itemIdentifier willBeInsertedIntoToolbar : ( BOOL) flag;
- ( NSArray * ) toolbarAllowedItemIdentifiers : ( NSToolbar * ) aToolbar;
- ( NSArray * ) toolbarDefaultItemIdentifiers : ( NSToolbar * ) aToolbar;
 - ( NSArray * ) toolbarSelectableItemIdentifiers : ( NSToolbar * ) toolbar;
 -  ( void ) addselectable : ( NSToolbarItem * ) item ;
@end


@implementation ToolBar


- ( NSToolbarItem * ) toolbar : ( NSToolbar * ) aToolbar itemForItemIdentifier : ( NSString * ) itemIdentifier willBeInsertedIntoToolbar : ( BOOL) flag
{
	return [ [ [ NSToolbarItem alloc ] initWithItemIdentifier : itemIdentifier ] autorelease ];
}

- ( NSArray * ) toolbarAllowedItemIdentifiers : ( NSToolbar * ) aToolbar
{
   return [ NSArray arrayWithObject : @"" ]; // s @"New", @"Open", @"Save", nil ];
}

- ( NSArray * ) toolbarDefaultItemIdentifiers : ( NSToolbar * ) aToolbar
{
	return [ NSArray arrayWithObject : @"" ]; // s @"New", @"Open", @"Save", nil ];
}


- ( NSArray * ) toolbarSelectableItemIdentifiers : ( NSToolbar * ) toolbar
{
    NSArray *selectionables =  [[itemsSelectables  copy] autorelease];    
    //  return [items allKeys];
   // return  [[toolbar items] valueForKey:@"itemIdentifier"]
    
  	return selectionables ;
   
 }

-  ( void ) addselectable : ( NSToolbarItem * ) item ;
{
    if (itemsSelectables == nil)
    {
      itemsSelectables=[[NSMutableArray alloc] init];  
    }
    
    [ itemsSelectables addObject: [item itemIdentifier] ] ;
 }


@end

HB_FUNC( TBRCREATE )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   NSString * identifier = hb_NSSTRING_par( 2 ) ;
   
   ToolBar * toolbar = [ [ [ ToolBar alloc ] initWithIdentifier : identifier ] autorelease ]; 
   
   [ toolbar setAllowsUserCustomization : NO ];
   [ toolbar setAutosavesConfiguration : NO ];
   
    BOOL lSmall = hb_parl(3) ? hb_parl( 3 ) : NO ;
    
   if  ( lSmall ) 
   {
     //  NSLog( @"yes" );
 
      [ toolbar setSizeMode : NSToolbarSizeModeSmall ];  
   }
    else
    {
 // NSLog( @"no" );
      [ toolbar setSizeMode : NSToolbarSizeModeRegular ]; // NSToolbarSizeModeSmall ]; // NSToolbarSizeModeRegular ];
    }
      
   [ toolbar setDelegate : toolbar ];
   [ window setToolbar : toolbar ];   
   
   hb_retnl( ( HB_LONG ) toolbar );
}    	 

HB_FUNC( TBRFROMWND )
{
    NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
    NSToolbar * tool = (NSToolbar *) [ window toolbar ] ;
    
    return  hb_retnl( ( HB_LONG ) tool );	
}

HB_FUNC( TBRADDITEM )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSString * label = hb_NSSTRING_par( 2 );
   NSString * tooltip = hb_NSSTRING_par( 4 );
   NSString * filename = hb_NSSTRING_par( 5 );
   NSToolbarItem * item;
   NSFileManager * filemgr = [ NSFileManager defaultManager ];
   
   [ toolbar insertItemWithItemIdentifier : label atIndex : hb_parnl( 3 ) ];
   item = [ [ toolbar items ] objectAtIndex : hb_parnl( 3 ) ];
   
   [ item setLabel : label ]; 
   //[ item setPaletteLabel : label ];
   [ item setToolTip : tooltip ];
   
   NSImage *Image  ;
    
   if( [ filemgr fileExistsAtPath: filename ] )
       Image = [ [ NSImage alloc ] initWithContentsOfFile : filename ] ;
   else 
       Image = ImgTemplate( filename ) ;
   
    [ item setImage : Image ];
    
   //[item  setTarget:item ];
   
   [ item setAction : @selector( TbrClick: )];  // Gets routed to the window view
   [item setAutovalidates: NO];
   
   [ item setEnabled : YES ];
   
   hb_retnl( ( HB_LONG ) item );
}   

// ----------- separator deprecated in 10.7 --------------
HB_FUNC( TBRADDSEPARATOR )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSToolbarItem * item;
   
   [ toolbar insertItemWithItemIdentifier : NSToolbarSeparatorItemIdentifier atIndex : hb_parnl( 2 ) ];
   
   item = [ [ toolbar items ] objectAtIndex : hb_parnl( 2 ) ];
    
   hb_retnl( ( HB_LONG ) item );
} 
//-------------------------------------------------------

HB_FUNC( TBRITEMSETVIEW )
{
   NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
   
   [ item setView : ( NSView * ) hb_parnl( 2 ) ];
}   	

HB_FUNC( TBRITEMSETSIZE )
{
   NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
   NSSize size = [ item maxSize ];
   
   size.width = hb_parnl( 2 );
   [ item setMaxSize : size ];
}   	

HB_FUNC( TBRITEMSETMINSIZE )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    NSSize size = [ item minSize ];
    
    size.width = hb_parnl( 2 );
    [ item setMinSize : size ];
}

HB_FUNC( TBRITEMSETMAXSIZE )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    NSSize size = [ item maxSize ];
    
    size.width = hb_parnl( 2 );
    [ item setMaxSize : size ];
}

HB_FUNC( TBRITEMSETSTANDARDVISPRIORITY )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    [ item setVisibilityPriority : NSToolbarItemVisibilityPriorityStandard ];
}

HB_FUNC( TBRITEMSETLOWVISPRIORITY )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    [ item setVisibilityPriority : NSToolbarItemVisibilityPriorityLow ];
}

HB_FUNC( TBRITEMSETHIGHVISPRIORITY )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    [ item setVisibilityPriority : NSToolbarItemVisibilityPriorityHigh ];
}

HB_FUNC( TBRITEMSETUSERVISPRIORITY )
{
    NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
    [ item setVisibilityPriority : NSToolbarItemVisibilityPriorityUser ];
}

HB_FUNC( TBRADDPRINT )
{
	
	ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
	
	NSToolbarItem * item;
	
	[ toolbar insertItemWithItemIdentifier : NSToolbarPrintItemIdentifier atIndex : hb_parnl( 2 ) ];
	item = [ [ toolbar items ] objectAtIndex : hb_parnl( 2 ) ];
	
	hb_retnl( ( HB_LONG ) item );
} 

HB_FUNC( TBRADDSPACEFLEX )
{
    
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    
    NSToolbarItem * item;
    
    [ toolbar insertItemWithItemIdentifier : NSToolbarFlexibleSpaceItemIdentifier atIndex : hb_parnl( 2 ) ];
    item = [ [ toolbar items ] objectAtIndex : hb_parnl( 2 ) ];
    
    hb_retnl( ( HB_LONG ) item );
} 

HB_FUNC( TBRGETITEM )
{
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    NSToolbarItem * item = [ [ toolbar items ] objectAtIndex : hb_parnl( 2 ) ];
    	
    hb_retnl( ( HB_LONG ) item );
} 

HB_FUNC( TBRITEMSCOUNT )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    
   hb_retnl( ( HB_LONG ) [ [ toolbar items ] count] );
}

HB_FUNC( TBRADDSPACE )
{
    
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSToolbarItem * item;
    
   [ toolbar insertItemWithItemIdentifier : NSToolbarSpaceItemIdentifier atIndex : hb_parnl( 2 ) ];
   item = [ [ toolbar items ] objectAtIndex : hb_parnl( 2 ) ];
    
   hb_retnl( ( HB_LONG ) item );
} 

HB_FUNC( TBRCHANGEITEMLABEL )
{
   NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 1 );
   NSString * label = hb_NSSTRING_par( 2 ) ;
    
   [ item setLabel : label ]; 
}   

HB_FUNC( TBRCHANGEITEMTOOLTIP )
{
    NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 1 );
    NSString * cToolTip = hb_NSSTRING_par( 2 ) ;
    
    [ item setToolTip : cToolTip ]; 
}  

HB_FUNC( TBRITEMDISABLE )
{
    NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 1 );
    [  item setEnabled : NO ]; 
}  

HB_FUNC( TBRITEMENABLE )
{
    NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 1 );
    [  item setEnabled : YES ]; 
}  

HB_FUNC( TBSETMODELABEL )
{
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    [toolbar setDisplayMode : NSToolbarDisplayModeLabelOnly   ] ;
}

HB_FUNC( TBSETMODEICOLBL )
{
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    [toolbar setDisplayMode : NSToolbarDisplayModeIconAndLabel   ] ;
}

HB_FUNC( TBSETMODEICO )
{
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    [toolbar setDisplayMode : NSToolbarDisplayModeIconOnly   ] ;
}

HB_FUNC( TBSETMODEDEFAULT )
{
    ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
    [toolbar setDisplayMode : NSToolbarDisplayModeDefault  ] ;
}

HB_FUNC( TBRADDSEARCH )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSString * label = hb_NSSTRING_par( 2 ) ;
   NSString * tooltip = hb_NSSTRING_par( 4 ) ;
   
   NSToolbarItem * item;
   SearchGet * edit = ( SearchGet * ) hb_parnl( 5 );
    
   [ toolbar insertItemWithItemIdentifier :@"Buscador" atIndex : hb_parnl( 3 ) ];
   item = [ [ toolbar items ] objectAtIndex : hb_parnl( 3 ) ];
    
   [ item setLabel : label ]; 
   [ item setPaletteLabel: label ];
   [ item setToolTip: tooltip ];
   [ item setEnabled: YES ];
   [ item setView: edit ];
   [ item setMinSize: NSMakeSize(  40, NSHeight( [ edit frame ] ) ) ];
   [ item setMaxSize: NSMakeSize( 200, NSHeight( [ edit frame ] ) ) ];
    
   hb_retnl( ( HB_LONG ) item );
}   

HB_FUNC( TBRSEARCHTEXT )
{
   NSToolbarItem * item = ( NSToolbarItem * ) hb_parnl( 1 );
   SearchGet * edit = ( SearchGet * ) [ item view ];
   NSString * string = [ edit stringValue ];
   
   hb_retc( [ string cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( TBRADDCONTROL )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSString * label = hb_NSSTRING_par( 3 );
   NSString * tooltip = hb_NSSTRING_par( 4 );
   NSToolbarItem * item;
   NSView * view = ( NSView * ) hb_parnl( 2 );
    
   [ toolbar insertItemWithItemIdentifier: @"ctrl" atIndex: hb_parnl( 5 ) ];
   item = [ [ toolbar items ] objectAtIndex: hb_parnl( 5 ) ];
    
   [ item setLabel : label ]; 
   [ item setPaletteLabel: label ];
   [ item setToolTip: tooltip ];
   [ item setEnabled: YES ];
   [ view removeFromSuperview ];
   [ item setView: view ];
   [ item setMinSize: NSMakeSize(  40, NSHeight( [ view frame ] ) ) ];
   [ item setMaxSize: NSMakeSize( 200, NSHeight( [ view frame ] ) ) ];
    
   hb_retnl( ( HB_LONG ) item );
}   

HB_FUNC( TBRHEIGHT )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );   
   NSRect windowFrame = [ NSWindow contentRectForFrameRect: [ window frame ] styleMask: [ window styleMask ] ];

   hb_retnl( NSHeight( windowFrame ) );
}

HB_FUNC( TBRITEMSELECTED )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 ); 
   NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 2 );
    
   [toolbar setSelectedItemIdentifier:[item itemIdentifier ]];
  
}  

HB_FUNC( TBRITEMSELECTABLE )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 ); 
   NSToolbarItem * item =( NSToolbarItem  * ) hb_parnl( 2 );

  [ toolbar addselectable : item ] ;

}

HB_FUNC( TBRADDSEGMENTEDBTN )
{
   ToolBar * toolbar = ( ToolBar * ) hb_parnl( 1 );
   NSString * label = hb_NSSTRING_par( 2 );
   NSString * tooltip = hb_NSSTRING_par( 4 );
  
   NSToolbarItem * item;
   NSSegmentedControl * segment = (NSSegmentedControl *) hb_parnl( 5 );
  
    
   [ toolbar insertItemWithItemIdentifier :label atIndex : hb_parnl( 3 ) ];
   item = [ [ toolbar items ] objectAtIndex : hb_parnl( 3 ) ];
    
   [ item setLabel : label ]; 
   [ item setPaletteLabel: label ];
   [ item setToolTip: tooltip ];
   [ item setEnabled: YES ];
   [ item setView: segment ];
   [ item setMinSize: NSMakeSize( 40, NSHeight( [ segment frame ] ) ) ];
   [ item setMaxSize: NSMakeSize( hb_parnl( 6 ) , NSHeight( [ segment frame ] ) ) ];
    
   hb_retnl( ( HB_LONG ) item );
}   

