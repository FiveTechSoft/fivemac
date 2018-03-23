#include <fivemac.h>

HB_FUNC( CREATEURL )
{
   NSString * string =hb_NSSTRING_par( 1 ) ;
   NSURL * name = [ [ [ NSURL alloc ] initWithString : string ]autorelease ];

   hb_retnl( ( HB_LONG ) name );
}
  
 HB_FUNC( CREATEURLFILE )
{
   NSString * string =hb_NSSTRING_par( 1 ) ;
   NSURL * name = [ [ [ NSURL alloc ] initFileURLWithPath: string ] autorelease ];

   hb_retnl( ( HB_LONG ) name );
}  
   
 HB_FUNC( URLPATH )
{
   NSURL * name = ( NSURL * ) hb_parnl( 1 );
   NSString * source = [ [ name path ]
        stringByRemovingPercentEncoding ];
        
   hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}  
  
 HB_FUNC( URLPATHEXTENSION )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
   NSURL * name = ( NSURL * ) hb_parnl( 1 );
   NSString *source = [name pathExtension ] ;
            
   hb_retc( [ source cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
   #endif
}   
  
HB_FUNC( URLLOAD )
{
    NSString * string =hb_NSSTRING_par( 1 ) ;
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: string ]];
}
