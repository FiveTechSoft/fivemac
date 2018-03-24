// Class Application used from samples/designer.prg

#include "FiveMac.ch"

//----------------------------------------------------------------------------//

CLASS TApplication

   DATA   aForms INIT {}
   
   METHOD New()

   METHOD Run()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TApplication


return self

//----------------------------------------------------------------------------//

METHOD Run() CLASS TApplication

   if Len( ::aForms ) == 0
      AAdd( ::aForms, TForm():New() )
   endif

   ::aForms[ 1 ]:Activate()

return nil

//----------------------------------------------------------------------------//