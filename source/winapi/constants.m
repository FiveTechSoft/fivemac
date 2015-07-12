#include <fivemac.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED > 1060

HB_FUNC( NSIMAGENAMEGORIGHTTEMPLATE )
{
   hb_retc( [ NSImageNameGoRightTemplate cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}   


NSImage * ImgTemplate( NSString * name )
{
   NSArray * templates = [ [ [ NSArray alloc ] initWithObjects:
        NSImageNameQuickLookTemplate,
        NSImageNameBluetoothTemplate,
        NSImageNameIChatTheaterTemplate,
        NSImageNameSlideshowTemplate,
        NSImageNameActionTemplate,
        NSImageNameSmartBadgeTemplate,
        NSImageNameIconViewTemplate,
        NSImageNameListViewTemplate,
        NSImageNameColumnViewTemplate,
        NSImageNameFlowViewTemplate,
        NSImageNamePathTemplate,
        NSImageNameInvalidDataFreestandingTemplate,
        NSImageNameLockLockedTemplate,
        NSImageNameLockUnlockedTemplate,
        NSImageNameGoRightTemplate,
        NSImageNameGoLeftTemplate,
        NSImageNameRightFacingTriangleTemplate,
        NSImageNameLeftFacingTriangleTemplate,
        NSImageNameAddTemplate,
        NSImageNameRemoveTemplate,
        NSImageNameRevealFreestandingTemplate,
        NSImageNameFollowLinkFreestandingTemplate,
        NSImageNameEnterFullScreenTemplate,
        NSImageNameExitFullScreenTemplate,
        NSImageNameStopProgressTemplate,
        NSImageNameStopProgressFreestandingTemplate,
        NSImageNameRefreshTemplate,
        NSImageNameRefreshFreestandingTemplate,
        NSImageNameBonjour,
        NSImageNameComputer,
        NSImageNameFolderBurnable,
        NSImageNameFolderSmart,
        NSImageNameFolder,
        NSImageNameNetwork,
        NSImageNameMobileMe,
        NSImageNameMultipleDocuments,
        NSImageNameUserAccounts,
        NSImageNamePreferencesGeneral,
        NSImageNameAdvanced,
        NSImageNameInfo,
        NSImageNameFontPanel,
        NSImageNameColorPanel,
        NSImageNameUser,
        NSImageNameUserGroup,
        NSImageNameEveryone,
        NSImageNameUserGuest,
        NSImageNameMenuOnStateTemplate,
        NSImageNameMenuMixedStateTemplate,
        NSImageNameApplicationIcon,
        NSImageNameTrashEmpty,
        NSImageNameTrashFull,
        NSImageNameHomeTemplate,
        NSImageNameBookmarksTemplate,
        NSImageNameCaution,
        NSImageNameStatusAvailable,
        NSImageNameStatusPartiallyAvailable,
        NSImageNameStatusUnavailable,
        NSImageNameStatusNone,
        nil ] autorelease ];
   NSArray * names = [ [ [ NSArray alloc ] initWithObjects:
        @"QuickLook",
        @"Bluetooth",
        @"IChatTheater",
        @"Slideshow",
        @"Action",
        @"SmartBadge",
        @"IconView",
        @"ListView",
        @"ColumnView",
        @"FlowView",
        @"Path",
        @"InvalidDataFreestanding",
        @"LockLocked",
        @"LockUnlocked",
        @"GoRight",
        @"GoLeft",
        @"RightFacingTriangle",
        @"LeftFacingTriangle",
        @"Add",
        @"Remove",
        @"RevealFreestanding",
        @"FollowLinkFreestanding",
        @"EnterFullScreen",
        @"ExitFullScreen",
        @"StopProgress",
        @"StopProgressFreestanding",
        @"Refresh",
        @"RefreshFreestanding",
        @"Bonjour",
        @"Computer",
        @"FolderBurnable",
        @"FolderSmart",
        @"Folder",
        @"Network",
        @"MobileMe",
        @"MultipleDocuments",
        @"UserAccounts",
        @"PreferencesGeneral",
        @"Advanced",
        @"Info",
        @"FontPanel",
        @"ColorPanel",
        @"User",
        @"UserGroup",
        @"Everyone",
        @"UserGuest",
        @"MenuOnState",
        @"MenuMixedState",
        @"ApplicationIcon",
        @"TrashEmpty",
        @"TrashFull",
        @"Home",
        @"Bookmarks",
        @"Caution",
        @"StatusAvailable",
        @"StatusPartiallyAvailable",
        @"StatusUnavailable",
        @"StatusNone",
        nil ] autorelease ];
   NSDictionary * dict = [ [ [ NSDictionary alloc ] initWithObjects: templates forKeys: names ] autorelease ];

   return [ NSImage imageNamed : [ dict objectForKey : name ] ];
}   		

#else

NSImage * ImgTemplate( NSString * name )
{
   return nil;	
}

#endif

HB_FUNC( IMGTEMPLATE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED > 1060
      hb_retnl( ( HB_LONG ) ImgTemplate( hb_NSSTRING_par( 1 ) ) );
   #endif
}   


