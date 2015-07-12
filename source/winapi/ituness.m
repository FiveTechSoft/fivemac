#include <fivemac.h>
#import "iTunes.h"

//------------------ itunes functions ------------------

HB_FUNC( ITUNESCREATE ) 
{  
    iTunesApplication * iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    hb_retnl( ( HB_LONG ) iTunes );
 }


HB_FUNC( ITUNESSETVOL )  // 0 to 100
{  
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    int  volume = hb_parni( 2 ) ;
    if ( [iTunes isRunning] )
       [iTunes setSoundVolume:volume ];
 }

HB_FUNC( ITUNESGETVOL )
{  
    int volume;
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    if ( [iTunes isRunning] )
        volume= [iTunes soundVolume ];
    else
        volume = 0 ;
    hb_retnl(volume) ;
}

HB_FUNC( ITUNESISRUN )
{  
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
  hb_retl( [iTunes isRunning] ) ;
}

HB_FUNC( ITUNESRUN )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
  [iTunes run ];
}


HB_FUNC( ITUNESQUIT )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );   
  [iTunes quit ];
}

HB_FUNC( ITUNESSONGNAME )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
  hb_retc( [ [[iTunes currentTrack] name] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}

HB_FUNC( ITUNESGETSONGRATING )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    hb_retni(  [[iTunes currentTrack] rating] ); 
}

HB_FUNC( ITUNESGETSONGARTIST )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    hb_retc( [ [[iTunes currentTrack] artist ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}

HB_FUNC( ITUNESGETSONGDURATION )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    hb_retnl( [[iTunes currentTrack] duration ] ); 
}

HB_FUNC( ITUNESGETSONGLYRICS )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    hb_retc( [ [[iTunes currentTrack] lyrics ] cStringUsingEncoding : NSWindowsCP1252StringEncoding ] ); 
}

HB_FUNC( ITUNESPLAY )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );    
  [iTunes playOnce:YES];
}

HB_FUNC( ITUNESSTOP )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
  [iTunes stop ];
}

HB_FUNC( ITUNESPLAYPAUSE )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 ); 
  [iTunes playpause ];
}

HB_FUNC( ITUNESNEXTTRACK )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
  [iTunes nextTrack ];
}

HB_FUNC( ITUNESPREVIOUSTRACK )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    [iTunes previousTrack ];
}

HB_FUNC( ITUNESBACKTRACK )
{
    iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
    [iTunes backTrack ];
}

HB_FUNC( ITUNESADDTRACK )
{
   iTunesApplication * iTunes = ( iTunesApplication * ) hb_parnl( 1 );  
   NSString * sourceMediaFile = hb_NSSTRING_par( 2 ); 

   /* iTunesTrack * track = */ 
   [ iTunes add: [ NSArray arrayWithObject: [ NSURL fileURLWithPath: sourceMediaFile ] ] 
   	 to: nil ];
}

HB_FUNC( ITUNESGETARTWORK )
{
  iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 ); 
 
  iTunesTrack *current = [iTunes currentTrack];
    
  SBElementArray* theArtworks = [current artworks];
    
  int totalArtworkCount = [theArtworks count];
    
    
    if (totalArtworkCount > 0)
    {
        NSImage *songArtwork ;

        iTunesArtwork *thisArtwork = [theArtworks objectAtIndex:0];
        songArtwork =[thisArtwork data];
        
        hb_retnl( ( HB_LONG )  songArtwork );
    }
        
  hb_retnl( ( HB_LONG )  0 );
    
}


    
    
HB_FUNC( ITUNESGETTRACKS )
{
   iTunesApplication * iTunes = ( iTunesApplication *) hb_parnl( 1 );  
   NSString* libraryName = hb_NSSTRING_par( 2 );  
   
   /* NSArray * sources = */ [ [ iTunes sources ] get ];
     
   iTunesSource *library = [[[[iTunes sources] get] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"kind == %i", iTunesESrcLibrary]] objectAtIndex:0];
    
   NSPredicate * predicate ;
     
   if ( [ libraryName isEqualToString : @"Movies" ] )
   { 
      predicate = [ NSPredicate predicateWithFormat:@"specialKind == %i", iTunesESpKMovies];
   }    
   else
   {   
      predicate = [ NSPredicate predicateWithFormat:@"specialKind == %i", iTunesESpKMusic] ;
   } 
    
   iTunesLibraryPlaylist *lp = [[[[library playlists] get] filteredArrayUsingPredicate: predicate ] objectAtIndex:0];
       
   NSArray * tracksToPlay = [ ( SBElementArray * ) [ lp tracks ] get ];  
                      
   NSMutableArray *theMovies = [NSMutableArray array];
    
   for( iTunesTrack * track in tracksToPlay ) 
   {
      [ theMovies addObject: [ track name ] ];
      //  NSLog( @"%@", [track name ] );
   } 

   hb_retnl( ( HB_LONG ) theMovies );
}

/*
HB_FUNC( ICALSETEVENT )
{
     
iCalApplication *iCal = [SBApplication applicationWithBundleIdentifier:@"com.apple.iCal"];
 SBElementArray *calendars = [iCal calendars];
    
 iCalCalendar *theCalendar;
[iCal activate];

NSString *calendarName = hb_NSSTRING_par( 1 ); 

      
 theCalendar = [calendars objectWithName:calendarName];   
    
//(NSLog( @"%@", theCalendar );
   
       
    if (!theCalendar )
{
 
    NSLog(@"hola") ;
//    NSDictionary *props = [NSDictionary dictionaryWithObject:calendarName forKey:@"name"];
//    theCalendar = [[[[iCal classForScriptingClass:@"calendar"] alloc] initWithProperties: props] autorelease];
 //   [[iCal calendars] addObject: theCalendar];
   
}
 */
/*

NSString *eventName =  hb_NSSTRING_par( 2 ); 
 
NSDate* startDate =[ NSDate date ]  ;
 
NSDate* endDate = [[[NSDate alloc] initWithTimeInterval:3600 sinceDate:startDate] autorelease];

iCalEvent *theEvent;
NSArray *matchingEvents =
[[theCalendar events] filteredArrayUsingPredicate:
 [NSPredicate predicateWithFormat:@"summary == %@", eventName]];

if ( [matchingEvents count] >= 1 ) {
    theEvent = (iCalEvent *) [matchingEvents objectAtIndex:0];
    [theEvent setStartDate:startDate];
    [theEvent setEndDate:endDate];
} else {
    theEvent = [[[[iCal classForScriptingClass:@"event"] alloc] init] autorelease];
    [[theCalendar events] addObject: theEvent];
    [theEvent setSummary:eventName];
    [theEvent setStartDate:startDate];
    [theEvent setEndDate:endDate];
}
*/
/*
[iCal release];
 
}
 */
