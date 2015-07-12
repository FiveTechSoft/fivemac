#include <hbapi.h>

#define IF(x,y,z) ((x)?(y):(z))

typedef unsigned char BYTE;

//----------------------------------------------------------------------------//

static BYTE ROL( BYTE b, BYTE c )
{
   while( c-- )
      b = ( b << 1 ) | ( b & 0x80 ? 1 : 0 );
   return b;
}

//----------------------------------------------------------------------------//

static BYTE ROR( BYTE b, BYTE c )
{
   while( c-- )
      b = ( b >> 1 ) | ( b & 0x01 ? 0x80 : 0 );
   return b;
}

//----------------------------------------------------------------------------//

HB_FUNC( ENCRYPT )
{
   HB_LONG w = 0, y = 0, wLen = hb_parclen( 1 );
   BYTE bCount = 0;
   char * pBuffer = ( wLen > 0 ) ? ( char * ) hb_xgrab( wLen ): NULL;
   char * pKey = ( char * ) IF( hb_pcount() > 1, hb_parc( 2 ), NULL );
   HB_LONG wLen2  = IF( pKey, hb_parclen( 2 ), 0 );

   if( wLen == 0 )
   {
      hb_retc( "" );
      return;
   }

   memcpy( pBuffer, ( char * ) hb_parc( 1 ), wLen );

   while( w < wLen )
   {
      if( pKey )
      {
         pBuffer[ w ] = ( ROL( ( BYTE ) ( ( pBuffer[ w ] ^ wLen ) ), bCount++ ) ^ pKey[ y++ ] );
         w++;
         if( y == wLen2 )
            y = 0;
      }
      else
      {	
         pBuffer[ w ] = ROL( ( BYTE ) ( ( pBuffer[ w ] ^ wLen ) ), bCount++ );
         w++;
      }
   }

   hb_retclen( pBuffer, wLen );
   hb_xfree( pBuffer );
}

//----------------------------------------------------------------------------//

HB_FUNC( DECRYPT )
{
   HB_LONG w = 0, y = 0, wLen = hb_parclen( 1 );
   BYTE bCount = 0;
   char * pBuffer = ( wLen > 0 ) ? ( char * ) hb_xgrab( wLen ): NULL;
   char * pKey = ( char * ) IF( hb_pcount() > 1, hb_parc( 2 ), NULL );
   HB_LONG wLen2  = IF( pKey, hb_parclen( 2 ), 0 );

   if( wLen == 0 )
   {
      hb_retc( "" );
      return;
   }

   memcpy( pBuffer, ( char * ) hb_parc( 1 ), wLen );

   while( w < wLen )
   {
      if( pKey )
      {
         pBuffer[ w ] = ( ROR( ( BYTE ) ( pBuffer[ w ] ^ pKey[ y++ ] ), bCount++ ) ^ wLen );
         w++;
         if( y == wLen2 )
            y = 0;
      }
      else
      {	
         pBuffer[ w ] = ( ROR( pBuffer[ w ], bCount++ ) ^ wLen );
         w++;
      }
   }

   hb_retclen( pBuffer, wLen );
   hb_xfree( pBuffer );
}

//----------------------------------------------------------------------------//
