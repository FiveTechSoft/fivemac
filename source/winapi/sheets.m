#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

HB_FUNC( SHEETOPENCREATE )
{
   NSOpenPanel * panel = [ [ NSOpenPanel alloc ] init ];
   hb_retnl( ( HB_LONG ) panel );
 } 

HB_FUNC( SHEETSAVECREATE )
{
    NSSavePanel * panel = [ [ NSSavePanel alloc ] init ];
    hb_retnl( ( HB_LONG ) panel );
} 

HB_FUNC( SHEETOPENRUN )
{
   NSOpenPanel * panel = ( NSOpenPanel * ) hb_parnl( 1 );
   NSWindow * window = ( NSWindow * ) hb_parnl( 2 );      
     		
   [panel setMessage: @"Import the file" ];
	
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
      if (result == NSModalResponseOK) {
      
			   //NSArray* urls = [panel URLs];
         // Use the URLs to build a list of items to import.
         
         NSURL * cUrl  = [[panel URLs] objectAtIndex:0] ;
         
         if( symFMH == NULL )
             symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
          // NSLog( @"pulsa sheet" );   
   			 hb_vmPushSymbol( symFMH );
   			 hb_vmPushNil();
   			 hb_vmPushLong( ( HB_LONG ) window );
   			 hb_vmPushLong( WM_SHEETOK );
             hb_vmPushLong( ( HB_LONG ) panel );
             hb_vmPushLong( ( HB_LONG ) cUrl );
             hb_vmDo( 4 );  
          
  	     
      } } ] ; 
      #endif   
 } 

HB_FUNC( SHEETSAVERUN )
{
    
    NSSavePanel * panel = ( NSSavePanel * ) hb_parnl( 1 );
    NSWindow * window = ( NSWindow * ) hb_parnl( 2 );
    NSString * newName = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 3 ) ? hb_parc( 3 ) : "nuevo" encoding:  NSUTF8StringEncoding ] autorelease ];
    
    [panel setNameFieldStringValue: newName];
    [panel setMessage:@"Grabe el archivo"];

    #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
	[panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK) {
            
            //NSArray* urls = [panel URLs];
            // Use the URLs to build a list of items to import.
            
            NSURL * cUrl  = [panel URL] ;
            
            if( symFMH == NULL )
                symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMH" ) );
            // NSLog( @"pulsa sheet" );   
            hb_vmPushSymbol( symFMH );
            hb_vmPushNil();
            hb_vmPushLong( ( HB_LONG ) window );
            hb_vmPushLong( WM_SHEETOK );
            hb_vmPushLong( ( HB_LONG ) panel );
            hb_vmPushLong( ( HB_LONG ) cUrl );
            hb_vmDo( 4 );  
            
            
        } } ] ; 
   #endif    
} 

HB_FUNC( SHEETSETTITLE )
{
  NSPanel * panel = ( NSPanel * ) hb_parnl( 1 );
  [ panel setTitle:  hb_NSSTRING_par( 2 ) ] ;
}
