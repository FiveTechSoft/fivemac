#include <fivemac.h>

static PHB_SYMB symFMH = NULL;

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1060	
   @interface Get : NSTextField
#else
   @interface Get : NSTextField <NSTextFieldDelegate>
#endif
{
}
- ( BOOL ) textShouldEndEditing : ( NSText * ) text;
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification;
- ( void ) controlTextDidEndEditing:(NSNotification *) aNotification;
- (BOOL)   acceptsFirstResponder;
- ( void ) keyUp : ( NSEvent * ) theEvent;
- (BOOL) performKeyEquivalent: (NSEvent*) theEvent ;
@end

@implementation Get
- ( BOOL ) textShouldEndEditing : ( NSText * ) text
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_GETVALID );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );

 //NSLog( @"The contents of the text field end" );
    
   return hb_parl( -1 );	
}

- ( void ) controlTextDidEndEditing : ( NSNotification * ) aNotification
    {
        if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
        
        hb_vmPushSymbol( symFMH );
        hb_vmPushNil();
        hb_vmPushLong( ( HB_LONG ) [ self window ] );
        hb_vmPushLong( WM_GETLOSTFOCUS );
        hb_vmPushLong( ( HB_LONG ) self );
        hb_vmDo( 3 );
        
        //NSLog( @"The contents of the text field end" );
        
        TRUE ;
    }
    
- ( void ) controlTextDidChange : ( NSNotification * ) aNotification
{
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
   
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_GETCHANGED );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );
   
   // NSLog( @"The contents of the text field changed" );
}


- (BOOL) performKeyEquivalent: (NSEvent*) theEvent
{
    BOOL handled = NO;
    if( ([theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask)
       == NSEventModifierFlagCommand ) {
        NSString* keyChars = [theEvent charactersIgnoringModifiers];
        
        NSRange range = [[ self currentEditor ] selectedRange];
        bool hasSelection = (range.length > 0);
        
        handled = YES;
        
        NSResponder * responder = [[self window] firstResponder];
       
        
        if ((responder != nil) && [responder isKindOfClass:[NSTextView class]])
        {
        
         NSTextView * textView = (NSTextView *)responder;
            
        if( [keyChars isEqual: @"a"])
               [ textView  selectAll:  self  ];
        else if( hasSelection && [keyChars isEqual: @"x"])
            [ textView   cut: self ];
        else if( hasSelection && [keyChars isEqual: @"c"])
             [ textView copy: self ];
        else if( [keyChars isEqual: @"v"])
             [ textView  paste: self ];
        else if( [keyChars isEqual: @"z"])
             [[textView undoManager] undo];
        else if( [keyChars isEqual: @"y"])
            [[textView undoManager] redo];
            
            
        else
            handled = NO;
    }
    }
    return handled || [super performKeyEquivalent: theEvent];
}

- ( void ) keyUp : ( NSEvent * ) theEvent
{
   //  NSLog(@"Pressed key in NStextField!");
 // unsigned int flags = [ theEvent modifierFlags ];
    
   NSString * key = [ theEvent characters ];
   int unichar = [ key characterAtIndex: 0 ];
  
   if( symFMH == NULL )
      symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ]  );
   hb_vmPushLong( WM_KEYDOWN );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmPushLong( unichar );
   hb_vmDo( 4 );
    
   //  if( hb_parnl( -1 ) != 1 )
   //     [ super keyDown: theEvent ];
}

- ( BOOL ) acceptsFirstResponder
{
   if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ self window ] );
   hb_vmPushLong( WM_WHEN );
   hb_vmPushLong( ( HB_LONG ) self );
   hb_vmDo( 3 );
    
   if( HB_ISLOG( -1 ) )
      return hb_parl( -1 );
   else
      return TRUE;
}

@end

HB_FUNC( GETCREATE ) 
{
   Get * edit = [ [ Get alloc ] 
 			  initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : edit ];
   [ edit setDelegate: edit ];
   
   hb_retnl( ( HB_LONG ) edit );
}   

HB_FUNC( GETRESCREATE ) 
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
   Get * edit  = ( Get * ) [ GetView( window ) viewWithTag: hb_parnl( 2 ) ];
    
   [ edit setDelegate: edit ];
    
 	 hb_retnl( ( HB_LONG ) edit );	 			
}  

HB_FUNC( GETSETTEXT )
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSString * string =  hb_NSSTRING_par( 2 ) ;
  
  [ get setStringValue: string ];
} 

HB_FUNC( GETSETNUMBER )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSString * string ;
    string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 2 ) ? hb_parc( 2 ) : "" encoding :  NSWindowsCP1252StringEncoding ] autorelease ];
    
    double numerito = [string doubleValue] ;
    
    NSNumberFormatter * formato = [[NSNumberFormatter alloc] init];
   
    [formato setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formato setGroupingSeparator : @"."];
    [formato setDecimalSeparator:@","];
    [formato setGroupingSize:3];
    [formato setMaximumFractionDigits:2];
    [formato setMinimumFractionDigits:2];
    [formato setNumberStyle: NSNumberFormatterDecimalStyle];
    [formato setGeneratesDecimalNumbers:YES];
    
    
    [ [ get cell ] setFormatter: formato ];
   
    [ get setDoubleValue: numerito ];
    
  //  [get setStringValue : string] ;

}



HB_FUNC( GETGETTEXT ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSString * string = [ get stringValue ];
   
   hb_retc( [ string cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}   

HB_FUNC( GETSETTOEND ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { [[get stringValue ] length], 0 };
   
   [ [ get currentEditor ] setSelectedRange: range ];
}

HB_FUNC( GETGETPOS ) // hGet --> cText
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = [ [ get currentEditor ] selectedRange ];
   
   hb_retni( range.location );
   #endif
}

HB_FUNC( GETGETENDSELPOS ) // hGet --> cText
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = [ [ get currentEditor ] selectedRange ];
   
   hb_retni( range.location + range.length );
   #endif
}

HB_FUNC( GETSETTOSTART ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { 0, 0 };
   
   [ [ get currentEditor ] setSelectedRange: range ];
}

HB_FUNC( GETSETTO ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { hb_parni( 2 ), 0 };
   
   [ [ get currentEditor ] setSelectedRange: range ];
}

HB_FUNC( GETSETSELRANGE ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { hb_parni( 2 ), hb_parni( 3 ) };
   
   [ [ get currentEditor ] setSelectedRange: range ];
}

HB_FUNC( GETSETSELALL ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { 0, [ [ get stringValue ] length ] };
   
   [ [ get currentEditor ] setSelectedRange: range ];
}

HB_FUNC( GETDELSELECTED ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );

   [ [ get currentEditor ] delete: nil ];
}

HB_FUNC( GETCOPYSELECTED ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   
   [ [ get currentEditor ] copy: nil ];
}

HB_FUNC( GETPASTEIN ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSRange range = { hb_parni( 2 ), 0 };
   
   [ [ get currentEditor ] setSelectedRange: range ];
   [ [ get currentEditor ] paste: nil ];
}

HB_FUNC( GETCUTSELECTED ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   
   [ [ get currentEditor] cut: nil ];
}

@interface NSHarbourFormatter : NSFormatter
{
   @public NSTextField * get;	
}
- ( NSString * ) stringForObjectValue: ( id ) anObject;
- ( BOOL ) getObjectValue: ( id * ) anObject forString: ( NSString * ) string 
	errorDescription: ( NSString ** ) error;	
@end

@implementation NSHarbourFormatter

- ( NSString * ) stringForObjectValue: ( id ) obj 
{
   if( symFMH == NULL )
       symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ get window ] );
   hb_vmPushLong( WM_GETGETSTRING );
   hb_vmPushLong( ( HB_LONG ) get );
   hb_vmDo( 3 );
       
   return hb_NSSTRING_par( -1 );
}

- ( BOOL ) getObjectValue: ( id * ) obj forString: ( NSString * ) string 
	         errorDescription: ( NSString ** ) error 
{
   if( symFMH == NULL )
       symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
    
   hb_vmPushSymbol( symFMH );
   hb_vmPushNil();
   hb_vmPushLong( ( HB_LONG ) [ get window ] );
   hb_vmPushLong( WM_GETSETVALUE );
   hb_vmPushLong( ( HB_LONG ) get );
   hb_vmPushString( [ string cStringUsingEncoding: NSWindowsCP1252StringEncoding ], [ string length ] ); 
   hb_vmDo( 4 );

   * obj = hb_NSSTRING_par( -1 );    
       
   return TRUE;
}


- (BOOL) isPartialStringValid : (NSString*) partial newEditingString: (NSString**) newString
              errorDescription: (NSString**) errorString;
{
    
    if( symFMH == NULL )
        symFMH = hb_dynsymSymbol( hb_dynsymFindName( "_FMO" ) );
    
    hb_vmPushSymbol( symFMH );
    hb_vmPushNil();
    hb_vmPushLong( ( HB_LONG ) [ get window ] );
    hb_vmPushLong( WM_GETPARTEVALUE );
    hb_vmPushLong( ( HB_LONG ) get );
    hb_vmPushString( [ partial cStringUsingEncoding: NSWindowsCP1252StringEncoding ], [ partial length ] );
    
    hb_vmDo( 4 );
    
    
    *newString = hb_NSSTRING_par( -1 ) ;
  // partial = hb_NSSTRING_par( -1 ) ;
    
    return FALSE ;
}



@end

HB_FUNC( GETSETPLACEHOLDER )
{
 NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
 NSString * placeHolder = hb_NSSTRING_par( 2 );
 [ [ get cell] setPlaceholderString: placeHolder ];
 }


HB_FUNC( GETSETPICTURE ) 
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSHarbourFormatter * formatter = [ [ [ NSHarbourFormatter alloc ] init ] autorelease ];	

   formatter->get = get;

   [ [ get cell ] setFormatter: formatter ];
}  

HB_FUNC( GETSETCURRENCY ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [ [ NSNumberFormatter alloc ] init ]
                                     autorelease ];
    [ formatter setNumberStyle: NSNumberFormatterCurrencyStyle  ];
    [ [ get cell ] setFormatter: formatter ];
}


HB_FUNC( GETSETNUMERIC ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSNumberFormatter * formatter = [ [ NSNumberFormatter alloc ] init ] ;
   [ formatter setNumberStyle: NSNumberFormatterNoStyle ];
   [ [ get cell ] setFormatter: formatter ];
}  

HB_FUNC( GETSETNUMMAX ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSNumberFormatter * formatter = [ [get cell ] formatter ];
    
   [ formatter setMaximum: [ NSNumber numberWithInt: hb_parni( 2 ) ] ];
   [ [get cell ] setFormatter: formatter ];
}  


HB_FUNC( GETSETNUMMIN ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSNumberFormatter * formatter = [ [get cell ] formatter ];
    
   [formatter setMinimum: [ NSNumber numberWithInt: hb_parni( 2 ) ] ];
   [ [get cell ] setFormatter: formatter ];
}  

HB_FUNC( GETSETDECMAX ) // hGet --> cText
{
   NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
   NSNumberFormatter * formatter = [ [get cell] formatter ];
    
   [ formatter setMaximumFractionDigits: ( NSUInteger ) [ NSNumber numberWithInt: hb_parni( 2 ) ] ];
   [ [get cell ]setFormatter: formatter ];
}

HB_FUNC( GETSETNUMBERFORMAT ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [get cell] formatter ];
    NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 2 ) ? hb_parc( 2 ) : "" encoding : NSUTF8StringEncoding ] autorelease ];
    [ formatter setFormat: string  ];
    [ [get cell] setFormatter: formatter ];
}

HB_FUNC( GETGETNUMBERFORMAT ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [get cell] formatter ];
    NSString * string = [ formatter format ];
        hb_retc( [ string cStringUsingEncoding:   NSWindowsCP1252StringEncoding  ] );
 }

HB_FUNC( GETSETGROUPSEPARATOR ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [get cell ] formatter ];
    NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 2 ) ? hb_parc( 2 ) : "" encoding : NSUTF8StringEncoding ] autorelease ];
    [ formatter setGroupingSeparator: string  ];
    [ [get cell] setFormatter: formatter ];
}

HB_FUNC( GETSETGROUPSIZE ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [get cell ] formatter ];
   [ formatter setGroupingSize: hb_parni(2)  ];
    [ [get cell ] setFormatter: formatter ];
}

HB_FUNC( GETSETGROUPUSES ) // hGet --> cText
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSNumberFormatter * formatter = [ [get cell ] formatter ];
    [ formatter  setUsesGroupingSeparator : YES ];
    [ [get cell ] setFormatter: formatter ];
}


HB_FUNC( TXTAUTOAJUST )
{
   NSTextField * texto = ( NSTextField * ) hb_parnl( 1 );
	 
	 [ texto setAutoresizingMask: hb_parnl( 2 )  ];	
}

HB_FUNC( TXTSETFOCUS )
{
   NSWindow * window = ( NSWindow * ) hb_parnl( 1 ); 
   NSTextField * texto = ( NSTextField * ) hb_parnl( 2 );
   
   [ window makeFirstResponder: texto ];
}

HB_FUNC( ISCOMMANDKEYPRESSED )
{
    hb_retl( (([[NSApp currentEvent] modifierFlags] & NSCommandKeyMask) == NSCommandKeyMask) );
}


HB_FUNC( ISSHIFFKEYPRESSED )
{ 
    hb_retl( ( ( [ [NSApp currentEvent] modifierFlags] & NSShiftKeyMask  ) == NSShiftKeyMask )) ;
}  

HB_FUNC( ISOPTIONKEYPRESSED )
{ 
    hb_retl(  ( ( [ [NSApp currentEvent] modifierFlags] & NSAlternateKeyMask ) == NSAlternateKeyMask ) )  ; 
}

HB_FUNC( ISCONTROLKEYPRESSED )
{ 
    hb_retl(  ( ( [ [NSApp currentEvent] modifierFlags] & NSControlKeyMask ) == NSControlKeyMask ) )  ; 
}

HB_FUNC( CHOOSESHEETTXT )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
    NSTextField * texto = ( NSTextField * ) hb_parnl( 1 );
    NSString * string = hb_NSSTRING_par( 2 );
      
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    if( [ string length ] != 0 )
    {   
       [ panel setDirectoryURL: [ NSURL fileURLWithPath: string ] ];
    }
    [ panel setCanChooseDirectories: YES ];
    [ panel setMessage:@"Importe el Archivo"];
    [ panel beginSheetModalForWindow: [ texto window ] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSString *source =  [[[[panel URLs] objectAtIndex:0]  path]
                                 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [ texto setStringValue : source ];
            
        } } ];
   #endif
}

HB_FUNC( GETSETFORMATTER )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSFormatter *formatter =( NSFormatter * ) hb_parnl( 2 );
     [ [get cell] setFormatter: formatter ];
}


HB_FUNC( GETSETDATEFORMATSHORT )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [ [get cell] setFormatter: formatter ];
}

HB_FUNC( GETSETDATEFORMATMEDIUM )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSDateFormatter *formatter =  [[[NSDateFormatter alloc] init ] autorelease ];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [ [get cell] setFormatter: formatter ];
}

HB_FUNC( GETSETTIMEFORMATSHORT )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [ [get cell] setFormatter: formatter ];
}

HB_FUNC( GETSETTIMEFORMATMEDIUM )
{
    NSTextField * get = ( NSTextField * ) hb_parnl( 1 );
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [ [get cell] setFormatter: formatter ];
}




