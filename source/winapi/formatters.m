#include <fivemac.h>


HB_FUNC( FORMATTERCREATE )
{
  NSFormatter *formatter = [[[NSFormatter alloc] init]autorelease ];
  hb_retnl( ( HB_LONG ) formatter );
}

HB_FUNC( FORMATTERDATECREATE )
{
    NSDateFormatter *formatter = [ [[NSDateFormatter alloc] init] autorelease ];
    hb_retnl( ( HB_LONG ) formatter );
}

HB_FUNC( FORMATTERNUMBERCREATE )
{
    NSNumberFormatter *formatter =  [[[NSNumberFormatter alloc] init] autorelease ];
    hb_retnl( ( HB_LONG ) formatter );
}

HB_FUNC( FORMATTERSETDATESHORT )
{
    NSDateFormatter *formatter = ( NSDateFormatter * ) hb_parnl( 1 );
    [formatter setDateStyle:NSDateFormatterShortStyle];
 }

HB_FUNC( FORMATTERSETDATEMEDIUM )
{
    NSDateFormatter *formatter = ( NSDateFormatter * ) hb_parnl( 1 );
    [formatter setDateStyle:NSDateFormatterMediumStyle];
 }

HB_FUNC( FORMATTERSETTIMESHORT )
{
    NSDateFormatter *formatter = ( NSDateFormatter * ) hb_parnl( 1 );
    [formatter setTimeStyle:NSDateFormatterShortStyle];
 }

HB_FUNC( FORMATTERSETTIMEMEDIUM )
{
    NSDateFormatter *formatter = ( NSDateFormatter * ) hb_parnl( 1 );
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
 }

HB_FUNC( FORMATTERNUMERICSETLOCALE )
{
  NSNumberFormatter * formatter = ( NSNumberFormatter * ) hb_parnl( 1 );
  NSLocale * locale = ( NSLocale * ) hb_parnl( 2 );
  [ formatter setLocale: locale ];
}

HB_FUNC( FORMATTERSETNUMERIC )
{
  NSNumberFormatter * formatter = ( NSNumberFormatter * ) hb_parnl( 1 );
 [ formatter setNumberStyle: NSNumberFormatterNoStyle ];
 }


HB_FUNC( FORMATTERSETCURRENCY )
{
  NSNumberFormatter * formatter = ( NSNumberFormatter * ) hb_parnl( 1 );
  [ formatter setNumberStyle: NSNumberFormatterCurrencyStyle ];
}

HB_FUNC( LOCALECREATEFROMID )
{
  NSString * string = hb_NSSTRING_par( 1 );   
  NSLocale * locale = [NSLocale localeWithLocaleIdentifier: string ];
  hb_retnl( ( HB_LONG ) locale );
}

HB_FUNC( LOCALECURRENT )
{
  NSLocale * locale = [NSLocale currentLocale ];
  hb_retnl( ( HB_LONG ) locale );
}

HB_FUNC( LOCALEGETNAME )
{
  NSLocale * locale = ( NSLocale * ) hb_parnl( 1 );
  NSString * language = [ [ NSLocale preferredLanguages] objectAtIndex:0] ;
  NSString * displayNameString = [ locale displayNameForKey:NSLocaleIdentifier value: language ];
  hb_retc( [ displayNameString cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( LOCALEGETPREFID )
{
  NSString * language = [ [  NSLocale preferredLanguages] objectAtIndex:0] ;
  hb_retc( [ language cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( LOCALEGETMESURESYSTEM )
{
  NSLocale * locale = ( NSLocale * ) hb_parnl( 1 );
  NSString * string = [ locale objectForKey: NSLocaleMeasurementSystem ]; 
  hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( LOCALEMESUREISMETRIC )
{
  NSLocale * locale = ( NSLocale * ) hb_parnl( 1 );
  bool isMetric = [[ locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
  hb_retl( ( BOOL ) isMetric );
}