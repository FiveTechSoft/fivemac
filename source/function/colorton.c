
#include <hbapi.h>


HB_FUNC( NRGBBLUE ) //  nRgbColor --> nRed
{
   hb_retni( ( HB_BYTE ) ( hb_parnl( 1 ) / 65536 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( NRGBGREEN ) //  nRgbColor --> nGreen
{
   hb_retni( ( HB_BYTE ) ( hb_parnl( 1 ) / 256 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( NRGBRED ) //  nRgbColor --> nRed
{
    HB_LONG lRgbColor = hb_parnl( 1 );
    HB_BYTE bBlue     = lRgbColor / 65536;
    HB_BYTE bGreen    = lRgbColor / 256;

   hb_retni( ( HB_BYTE ) ( lRgbColor - ( bBlue * 65536 ) - ( bGreen * 256 ) ) );
}
