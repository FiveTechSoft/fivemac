#include <hbapi.h>

//----------------------------------------------------------------------------//

HB_FUNC( NOR )
{
   unsigned long ulRet = 0;
   unsigned int ui = 0;

   while( ui < hb_pcount() )
      ulRet |= ( HB_LONG ) hb_parnl( ++ui );

   hb_retnl( ulRet );
}

//----------------------------------------------------------------------------//
