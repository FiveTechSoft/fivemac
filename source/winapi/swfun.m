#include <fivemac.h>
#import "../swift/foo-Swift.h"


/*
HB_FUNC( FOOC )
{
    foo * sis = [[ foo alloc] init];
    NSString * string = [sis printSome ] ;
    
    hb_retc(  [ string cStringUsingEncoding : NSUTF8StringEncoding ] );
     
}

HB_FUNC( BEEPC )
{
   [[[ foo alloc] init] beep ];
    
}

HB_FUNC( HELLOC )
{
   foo * sis = [[ foo alloc] init] ;
    NSString * string =   [sis yumeWithUno:10 dos:20 ]  ;
    hb_retc(  [ string cStringUsingEncoding : NSUTF8StringEncoding ] );
  
    
}
 
*/
HB_FUNC( HELLOCC )
{
    foo * sis = [[ foo alloc] init] ;
    NSString * string =   [sis helloWithName:@"manuel" ]  ;
    hb_retc(  [ string cStringUsingEncoding : NSUTF8StringEncoding ] );
    
    
}


HB_FUNC( MOVETOTRASH3 )
{
  hb_retl( [[[ foo alloc] init] totrashWithFile: hb_parc( 1 )  ]  ) ;
 }




/*
HB_FUNC( TIMESW )
{
   foo * sis = [[ foo alloc] init] ;
 
   hb_retnd( [sis SECW ] ) ;
    
  //  NSString * string =   [sis TIMEW ]  ;
  //  hb_retc(  [ string cStringUsingEncoding : NSUTF8StringEncoding ] );

    
}

HB_FUNC( DATESW )
{
    foo * sis = [[ foo alloc] init] ;
    
    hb_retnd( [sis DATEW ] ) ;
    
    //  NSString * string =   [sis TIMEW ]  ;
    //  hb_retc(  [ string cStringUsingEncoding : NSUTF8StringEncoding ] );
    
    
}
*/
