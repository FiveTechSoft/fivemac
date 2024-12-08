#include <fivemac.h>

HB_FUNC( DATEPICKCREATE ) 
{
   NSDatePicker	* datePicker = [ [ NSDatePicker alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
   
   [ GetView( window ) addSubview : datePicker ];
   
   [ datePicker setDateValue : [ NSDate date ] ];
   [ datePicker setDatePickerElements : NSDatePickerElementFlagYearMonth ];
   [ datePicker setDatePickerStyle : NSDatePickerStyleClockAndCalendar ];
             
   hb_retnl( ( HB_LONG ) datePicker );
}

HB_FUNC( DATEPICKGETTEXT )
{
   NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
   NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
   NSString * string;
    
   [ formatter setDateStyle : NSDateFormatterShortStyle ];
   [ datePicker setFormatter : formatter ];
    
   string = [ datePicker stringValue];
    
   // NSLog( @"DateString %@", string );
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );  
}  

/* NSYearMonthDatePickerElementFlag
   NSYearMonthDayDatePickerElementFlag
   NSEraDatePickerElementFlag
   NSHourMinuteDatePickerElementFlag
   NSHourMinuteSecondDatePickerElementFlag
   NSTimeZoneDatePickerElementFlag */


HB_FUNC( DATEPICKSETDRAWBACK )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    [ datePicker setDrawsBackground : hb_parl( 2 ) ];
}


HB_FUNC( DATEPICKSETBACKCOLOR )
{
   NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
   NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                 green: ( hb_parnl( 3 ) / 255.0 ) 
                                 blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];   
                                   
   [ datePicker setBackgroundColor : color ];           
 }

HB_FUNC( DATEPICKSETTEXTCOLOR )
{
   NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
   NSColor * color =  [ NSColor colorWithCalibratedRed  : ( hb_parnl( 2 ) / 255.0 ) 
                                 green: ( hb_parnl( 3 ) / 255.0 ) 
                                 blue:  ( hb_parnl( 4 ) / 255.0 ) alpha : ( hb_parnl( 5 ) / 100.0 ) ];   
                                   
   [ datePicker setTextColor : color ];           
 }

HB_FUNC( DATEPICKSETTEXT )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    NSString * string =hb_NSSTRING_par( 2 ) ;
    
    NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
    
    [ formatter setDateStyle : NSDateFormatterShortStyle ];
    
    [ datePicker setDateValue : [formatter dateFromString : string ]  ];
    
 }

HB_FUNC( DATEPICKSETBEZELED )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    [ datePicker setBezeled : hb_parl( 2 ) ] ;
    
}

HB_FUNC( DATEPICKSETSTYLE )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    [ datePicker setDatePickerStyle: hb_parni( 2 ) ] ;
    
}

HB_FUNC( DATEPICKSETMINDATE )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    NSString * string =hb_NSSTRING_par( 2 ) ;
    
    NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
    
    [ formatter setDateStyle : NSDateFormatterShortStyle ];
    
    [ datePicker setMinDate : [formatter dateFromString : string ]  ] ;
    
}

HB_FUNC( DATEPICKSETMAXDATE )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
    NSString * string =hb_NSSTRING_par( 2 ) ;
        
    NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
    
    [ formatter setDateStyle : NSDateFormatterShortStyle ];
    [ datePicker setMaxDate : [formatter dateFromString : string ]  ] ;
    
}


HB_FUNC( DATEPICKSETTODAY )
{
    NSDatePicker * datePicker = ( NSDatePicker * ) hb_parnl( 1 );
        
    [ datePicker setDateValue:[NSDate date]];
    
}

HB_FUNC( CSHORTDATETONSDATE )
{
   NSString * string =hb_NSSTRING_par( 1 ) ;
   NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
   [ formatter setDateStyle : NSDateFormatterShortStyle ];
   NSDate * date =  [formatter dateFromString : string ] ;
   hb_retnl( ( HB_LONG ) date );
}

HB_FUNC( NSDATETOCDATESHORT )
{
   NSDate * date = ( NSDate * ) hb_parnl( 1 );
   NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
   [ formatter setDateStyle : NSDateFormatterShortStyle ];
   NSString * string = [ formatter stringFromDate : date ] ;
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );   
}

HB_FUNC( NSDATETOCDATEMEDIUM )
{
   NSDate * date = ( NSDate * ) hb_parnl( 1 );
   NSDateFormatter * formatter = [ [ [ NSDateFormatter alloc ] init ] autorelease ];
   [ formatter setDateStyle : NSDateFormatterMediumStyle ];
   NSString * string = [ formatter stringFromDate : date ] ;
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );   
}
