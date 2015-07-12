#include <hbapi.h>
#include <hbapicls.h>
#include <hbapiitm.h>
#include <hbdate.h>
#include <hbset.h>
#include <hbvm.h>

//----------------------------------------------------------------------------//

void ValToChar( PHB_ITEM item )
{
  switch( hb_itemType( item ) )
  {
     case HB_IT_NIL:
          hb_retc( "nil" );
          break;

     case HB_IT_STRING:
     case HB_IT_MEMO:
          hb_retc( hb_itemGetC( item ) );
          break;
	  
     case HB_IT_INTEGER:
          {
             char lng[ 15 ];
             sprintf( lng, "%d", hb_itemGetNI( item ) );
             hb_retc( lng );
          }
          break;

     case HB_IT_LONG:
          {
             char dbl[ HB_MAX_DOUBLE_LENGTH ];
             sprintf( dbl, "%f", ( double ) hb_itemGetND( item ) );
             * strchr( dbl, '.' ) = 0;
             hb_retc( dbl );
          }
          break;

     case HB_IT_DOUBLE:
          {
             char dbl[ HB_MAX_DOUBLE_LENGTH ];
             sprintf( dbl, "%f", hb_itemGetND( item ) );
             hb_retc( dbl );
          }
          break;

     case HB_IT_DATE:
          {
             hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFindName( "DTOC" ) ) );
             hb_vmPushNil();
             hb_vmPush( item );
             hb_vmDo( 1 );
          }
          break;

     case HB_IT_LOGICAL:
          hb_retc( hb_itemGetL( item ) ? ".T." : ".F." );
          break;

     case HB_IT_ARRAY:
          if( hb_objGetClass( item ) == 0 )
             hb_retc( "Array" );
          else
             hb_retc( "Object" );
          break;

     default:
          hb_retc( "ValtoChar not suported type yet" );
 }
}

//----------------------------------------------------------------------------//

HB_FUNC( CVALTOCHAR ) // ( uVal ) --> cVal
{
   ValToChar( hb_param( 1, HB_IT_ANY ) );
}

//----------------------------------------------------------------------------//
