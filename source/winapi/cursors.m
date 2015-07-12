#include <fivemac.h>

HB_FUNC( SETCURSORSIZE ) 
{
   [ [ NSCursor resizeLeftRightCursor ] set ];	
}   

HB_FUNC( SETCURSORARROW )
{
   [ [ NSCursor arrowCursor ] set ];	
}   

HB_FUNC( SETCURSORHAND )
{
   [ [ NSCursor openHandCursor ] set ];	
}   

HB_FUNC( SETCURSORRESIZEDOWN )
{
   [ [ NSCursor resizeDownCursor ] set ];	
}   
	
HB_FUNC( SETCURSORCLOSEHAND )
{
   [ [ NSCursor closedHandCursor ] set ];	
} 	

HB_FUNC( SETCURSORIMAGE )
{
  NSString * string = hb_NSSTRING_par( 1 );
  NSImage * image ;
    
  NSFileManager * filemgr = [ NSFileManager defaultManager ];
    
  if( [ filemgr fileExistsAtPath: string ] ) 
        image = [ [ NSImage alloc ] initWithContentsOfFile : string ]  ; 
    else
        image = ImgTemplate( string ) ;
      
  NSCursor *  imageCursor = [[NSCursor alloc] initWithImage:image hotSpot:NSZeroPoint];
  [image release];
  [imageCursor set];
}    