#include <fivemac.h>


#if __MAC_OS_X_VERSION_MAX_ALLOWED > 1070

static PHB_SYMB symFMH = NULL;

@interface NotiDelegate : NSObject < NSUserNotificationCenterDelegate>
{
}

@end

@implementation NotiDelegate
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    NSLog(@"delivered") ;
}

- (void) userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    NSLog(@"clicked") ;
    if( symFMH == NULL )
		symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMN" ) );
	
	hb_vmPushSymbol( symFMH );
	hb_vmPushNil();
	hb_vmPushLong( ( HB_LONG )  notification  );
	hb_vmPushLong( WM_NOTICLICK );
    hb_vmPushLong( ( HB_LONG )  notification  );
	hb_vmDo( 3 );
     NSLog(@"clicked2") ;  
   
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
  //  NSLog(@"SI") ;
    return YES;
}

@end

HB_FUNC( NOTIFICREATE )
{
   NSUserNotification * notice = [[ NSUserNotification alloc] init ];
     
   notice.title = hb_NSSTRING_par( 1 );
   notice.informativeText = hb_NSSTRING_par( 2 )  ;
   notice.subtitle = hb_NSSTRING_par( 3 );
   notice.soundName = NSUserNotificationDefaultSoundName ;
   
    hb_retnl( ( HB_LONG ) notice );
}   


HB_FUNC( NOTIFYSETTITLE )
{
    NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
    notice.title = hb_NSSTRING_par( 2 );
}

HB_FUNC( NOTIFYGETTITLE )
{
    NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
    NSString * string = notice.title ;
    hb_retc( [ string cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}


HB_FUNC( NOTIFYSETINFO )
{
    NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
    notice.informativeText = hb_NSSTRING_par( 2 );
}

HB_FUNC( NOTIFYSETSUBTITLE )
{
    NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
    notice.subtitle = hb_NSSTRING_par( 2 );
}

HB_FUNC( NOTIFYDELIVER ) 
{
  NotiDelegate * notidele = [[ NotiDelegate alloc] init ];
   NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
   NSUserNotificationCenter * center = [ NSUserNotificationCenter defaultUserNotificationCenter];
 //  [notice setDeliveryDate:[NSDate dateWithTimeInterval:20 sinceDate:[NSDate date]]];
   [center setDelegate: notidele  ];
   [center deliverNotification:notice];
}  

HB_FUNC( NOTIFISOUND )
{
   NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
  notice.soundName = NSUserNotificationDefaultSoundName ;
}

HB_FUNC( NOTIFYDELETEALL ) 
{
   NSUserNotificationCenter * center = [NSUserNotificationCenter defaultUserNotificationCenter]; 
  [ center removeAllDeliveredNotifications ] ;
}  

HB_FUNC( NOTIFYDELETE ) 
{
   NotiDelegate * notidele = [[ NotiDelegate alloc] init ];

   NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
   NSUserNotificationCenter * center = [NSUserNotificationCenter defaultUserNotificationCenter];
   [center setDelegate: notidele ];
   [ center removeDeliveredNotification : notice ] ;
    
} 

HB_FUNC( NOTIFIISPRESENTED )
{
    NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
    hb_retl( ( BOOL )[notice isPresented ] );
}


HB_FUNC( NOTIFIINTERVAL )
{
   NSTimeInterval interval = hb_parnl( 2 ) ;
   NSUserNotification * notice = ( NSUserNotification * ) hb_parnl( 1 );
   NSUserNotificationCenter * center = [NSUserNotificationCenter defaultUserNotificationCenter];
   NotiDelegate * notidele = [[ NotiDelegate alloc] init ];
    
   [notice setDeliveryDate: [NSDate dateWithTimeIntervalSinceNow: interval ] ];
   [center setDelegate: notidele ];
   [center scheduleNotification: notice ];
}



#endif