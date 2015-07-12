#include <fivemac.h>
#include <objc/runtime.h>

HB_FUNC( OBJC_OBJINSTANTIATE ) // cClassName --> hObject
{
   Class cls = objc_getClass( hb_parc( 1 ) );   

   if( cls != nil )
      hb_retnl( ( HB_LONG ) [ [ cls alloc ] init ] ); // autorelease use ?
   else
      hb_ret();
}     

HB_FUNC( OBJC_OBJSENDMSG )
{
   NSObject * hObj = ( NSObject * ) hb_parnl( 1 );
   SEL Selector = NSSelectorFromString( hb_NSSTRING_par( 2 ) );
   
   if( ! [ hObj respondsToSelector: Selector ] )
      return;
        
   switch( hb_pcount() )
   {
      case 2:
         [ hObj performSelector : Selector ];
         break;
         
      case 3:
         [ hObj performSelector : Selector withObject : ( id ) hb_parnl( 3 ) ];
         break;
   }      
}       

HB_FUNC( OBJC_GETCLASSNAME )
{
   NSObject * hObj = ( NSObject * ) hb_parnl( 1 );

   hb_retc( object_getClassName( hObj ) );
}

HB_FUNC( OBJC_GETINSTANCEVARIABLE )
{
   NSObject * hObj = ( NSObject * ) hb_parnl( 1 );
   void * outValue;
   void * ivar = object_getInstanceVariable( hObj, hb_parc( 2 ), &outValue );
   // Ivar --> void *

   hb_retnl( ( HB_LONG ) ivar );
}

HB_FUNC( OBJC_GETCLASSLIST )
{
   int numClasses  = objc_getClassList( NULL, 0 );
   Class * classes = NULL;
 
   if( numClasses > 0 )
   {
      classes = ( Class * ) hb_xgrab( sizeof( Class ) * numClasses );
      numClasses = objc_getClassList( classes, numClasses );

      hb_reta( numClasses );
   
      while( numClasses )
         hb_storvc( ( char * ) class_getName( * classes++ ), numClasses--, -1 ); 
    
      // hb_xfree( classes );
   }
   else
      hb_reta( 0 );  
}   

HB_FUNC( OBJADDSUBVIEW )
{
   NSView * parent = ( NSView * ) hb_parnl( 1 );
   NSView * child  = ( NSView * ) hb_parnl( 2 );
   	
   [ parent addSubview : child ];
}   		

HB_FUNC( OBJREMOVEFROMSUPERVIEW )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );
   
   [ view removeFromSuperview ];
}   

HB_FUNC( OBJCDEALLOC )
{
   NSView * view = ( NSView * ) hb_parnl( 1 );
   
   [ view dealloc ];
}   
		