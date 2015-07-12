#include <fivemac.h>

HB_FUNC( ARRAYCREATEEMPTY )
{
   NSMutableArray * myarray =   [[[ NSMutableArray alloc ] init ] autorelease ] ;

   hb_retnl( ( HB_LONG ) myarray );
}

HB_FUNC( ARRAYADDSTRING )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 );
   NSString * string =hb_NSSTRING_par( 2 ) ;
  
   [ myarray addObject: string  ] ;
}  
 
HB_FUNC( ARRAYADDOBJ )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   NSObject * object = ( NSObject * ) hb_parnl( 2 ); 

   [ myarray addObject: object  ] ;
}  
 
 
HB_FUNC( ARRAYDELALL )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 

   [ myarray removeAllObjects ] ;
}  
 
HB_FUNC( ARRAYADEL )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
  
   [ myarray  removeObjectAtIndex: hb_parni(2) ];
}    
 
HB_FUNC( ARRAYCREATELEN )
{
   NSMutableArray * myarray =  [[[ NSMutableArray alloc ] initWithCapacity:  hb_parni( 1 ) ] autorelease ];

   hb_retnl( ( HB_LONG ) myarray );
} 
  
HB_FUNC( ARRAYADDSTRINGINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 ) ;
   
   [ myarray insertObject: string atIndex: hb_parni(3) ];
}     

HB_FUNC( ARRAYADDOBJINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   NSObject * object = ( NSObject * ) hb_parnl( 2 ); 
   
   [ myarray insertObject: object atIndex: hb_parni(3) ];
}  

HB_FUNC( ARRAYLEN )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   
   hb_retni( [ myarray count] ) ;
}    
 
HB_FUNC( ARRAYGETOBJINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   NSObject * object =  [ myarray  objectAtIndex: hb_parni(2) ];
   
   hb_retnl( ( HB_LONG ) object );  
} 

 HB_FUNC( ARRAYGETSTRINGINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   NSString * string  =  [ myarray  objectAtIndex: hb_parni(2) ];
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
} 

HB_FUNC( ARRAYSETOBJINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 ); 
   NSObject * object = ( NSObject * ) hb_parnl( 3 ); 
   
   [ myarray replaceObjectAtIndex: hb_parni(2) withObject:object ];
} 

HB_FUNC( ARRAYSETSTRINGINDEX )
{
   NSMutableArray * myarray = ( NSMutableArray * ) hb_parnl( 1 );
   NSString * string =hb_NSSTRING_par( 3 ) ;
     
   [ myarray replaceObjectAtIndex: hb_parni(2) withObject:string ];
}  

HB_FUNC( DICTCREATEEMPTY )
{
   NSMutableDictionary * mydict =  [  NSMutableDictionary dictionary ] ;
   
   hb_retnl( ( HB_LONG ) mydict );
}

HB_FUNC( DICTCREATELEN )
{
   NSMutableDictionary * mydict =  [ NSMutableDictionary dictionaryWithCapacity: hb_parni( 1 ) ];
   
   hb_retnl( ( HB_LONG ) mydict );
}
