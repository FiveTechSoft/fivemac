#include "FiveMac.ch"

extern TWindow

function Main()

   local oObj := NSObject():New( "NSView" )

   MsgInfo( oObj:GetClassName() )

   // oObj:SendMsg( "setNeedsDisplay", 1 )

   // MsgInfo( oObj:GetInstanceVariable( "needsDisplay" ) )
   
   AEval( objc_GetClassList(), { | cName | if( cName != nil, MsgInfo( cName ),) } )

return nil