#include <hbapi.h>

//----------------------------------------------------------------------------//

char * StrToken( char * szText, unsigned int wOcurrence, char bSeparator, unsigned int * pwLen )
{
   unsigned int wStart = 0, wEnd = 0, wCounter = 0;

   if( ! bSeparator )
     bSeparator = ' ';

   do {
      wStart = wEnd;

      if( bSeparator != ' ' )
      {
         if( szText[ wStart ] == bSeparator )
            wStart++;
      }
      else
      {
         while( szText[ wStart ] && szText[ wStart ] == bSeparator )
            wStart++;
      }

      if( szText[ wStart ] && szText[ wStart ] != bSeparator )
      {
         wEnd = wStart + 1;

         while( szText[ wEnd ] && szText[ wEnd ] != bSeparator )
            wEnd++;
      }
      else
         wEnd = wStart;

   } while( wCounter++ < wOcurrence - 1 && szText[ wEnd ] );

   * pwLen = wEnd - wStart;

   if( wCounter < wOcurrence )
      * pwLen = 0;

   return szText + wStart;
}

//----------------------------------------------------------------------------//

HB_FUNC( STRTOKEN )  // ( cText, nOcurrence, cSepChar ) --> cToken
{
   unsigned int wLen;
   char * szToken = StrToken( ( char * ) hb_parc( 1 ), hb_parni( 2 ),
                             ( HB_ISCHAR( 3 ) && ( hb_pcount() > 2 ) ) ? * hb_parc( 3 ) : 0, &wLen );

   hb_retclen( szToken, wLen );
}

//----------------------------------------------------------------------------//