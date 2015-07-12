#include <fivemac.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface View : NSView <NSWindowDelegate>
#else
   @interface View : NSView
#endif
{
 //  @public NSWindow * hWnd;	
}
- ( BOOL ) windowShouldClose : ( NSNotification * ) notification;
- ( void ) windowWillClose: ( NSNotification * ) notification;
- ( void ) mouseDown : ( NSEvent *  ) theEvent;
- ( void ) mouseMoved : ( NSEvent *  ) theEvent;
- ( void ) keyDown : ( NSEvent *  ) theEvent;
- ( void ) MenuItem : ( id ) sender;
- ( void ) BtnClick : ( id ) sender;
- ( void ) CbxChange : ( id ) sender;
- ( void ) ChkClick : ( id ) sender;
- ( void ) RadClick : ( id ) sender;
- ( void ) TbrClick : ( id ) sender;
- ( void ) OnTimerEvent : ( NSTimer * ) timer;
- ( void ) SliderChanged : (id) sender;
@end

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   @interface Get : NSTextField <NSTextFieldDelegate>
#else
   @interface Get : NSTextField
#endif
{
 //  @public NSWindow * hWnd;	
}
- ( BOOL ) textShouldEndEditing : ( NSText * ) text;
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification;	
@end

HB_FUNC( WNDFROMNIB )
{
   NSString * string = hb_NSSTRING_par( 1 ) ;
   NSWindowController * wndController = [ [ NSWindowController alloc ] initWithWindowNibName : string ];
   NSWindow * window = [ wndController window ];
      
   NSArray * controls = [ [ window contentView ] subviews ];
   View * view = [ [ View alloc ] init ];

  
   [ window setContentView : view ];
   [ window setDelegate : view ];
  //  view->hWnd = window ;

   while( [ controls count ] > 0 )
   {
      NSControl * control = [ controls objectAtIndex : 0 ];
      NSString * className = [ control className ];
       
      // NSRunAlertPanel( [ control className ] ,@"yo", @"view", [ control className ], NULL );             
   
       [ view addSubview : control ];
      
            
    //  if( [ className isEqual : @"NSButton" ] )
    //  {
    //     NSButton * button = ( NSButton * ) control;
    //		 it works for checkboxes too, as they are buttons
    //		 and it seems as there is no way to check their style
    //    [ button setAction : @selector( BtnClick: ) ];
    //  }   
      
    //  if( [ className isEqual : @"Get" ] )
    //  {
    //     Get * get = ( Get * ) control;
    //     get->hWnd = window;
    //     [ get setDelegate : get ];
    //  }  
     
          
        
       
       if( [ className isEqual : @"TextView" ] )
       {
           Get * get = ( Get * ) control;
         //  get->hWnd = window;
           [ get setDelegate : get ];
       }  
       
          
       
     //  if( [ className isEqual : @"NSSlider" ] )
     //  {
     //     // NSSlider * slider = ( NSSlider * ) control;
     //      
     //      [ control setAction : @selector( SliderChanged: ) ];
     //  }  
     
     
     //  if( [ className isEqual : @"NSScrollView" ] )
     //  {
     //     NSScrollView * scroll = ( NSScrollView * ) control; 
     //     NSView * mycontrol = ( NSView * ) [ scroll documentView ] ;
     //     className = [ mycontrol className ] ;
     //     if ( [className  isEqual :@"MOutlineView"  ] )
     // 	  {   
     // 			  NSRunAlertPanel( @"outline" ,@"yo", @"view", NULL , NULL );  
     //		 	 }
     //	 }  
            
   }           	

 // NSRunAlertPanel( @"pausa" ,@"yo", @"view", NULL, NULL ); 
    
   hb_retnl( ( HB_LONG ) window );	
}


HB_FUNC( WNDGETCONTROL ) // hWnd, nId --> hCtrl
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   
   hb_retnl( ( HB_LONG ) [ GetView( window ) viewWithTag : hb_parni( 2 ) ] );	
}  

HB_FUNC( WNDGETIDENTFROMNIB )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
   NSWindow * window  = ( NSWindow * ) hb_parnl( 1 );
   NSArray * controls = [ [ [ [ window windowController ] window ] contentView ] subviews ];
   NSString * identif = hb_NSSTRING_par( 2 );
   int line;
 
   for( line = 0; line < [ controls count ]; line++ )
   {
      NSControl * control = [ controls objectAtIndex: line ];
      NSString * midenti = [ control identifier ];
        
      if( [ midenti isEqual : identif ] )
         return hb_retnl( ( HB_LONG ) control );	 
   }

   return hb_retnl( ( HB_LONG ) -1 );	
   #endif
}

