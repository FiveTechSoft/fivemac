//
//  AppDelegate.m
//  este
//
//  Created by Manuel Sanchez on 04/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#define HB_DONT_DEFINE_BOOL
#include "hbapi.h"
#include "hbvm.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
   
   
    
    /* 
    PHB_SYMB symMain = hb_dynsymSymbol( hb_dynsymFindName( "MYMAIN" ) );
	
   	
    hb_vmPushSymbol( symMain );
    hb_vmPushNil();
    hb_vmDo( 0 );	
    */
}

@end
