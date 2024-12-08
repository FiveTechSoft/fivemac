#include <fivemac.h>
#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#include <IOKit/IOKitLib.h>

#define CGAutorelease(x) (__typeof(x))[NSMakeCollectable(x) autorelease]
#define DURATION_ANIMATION 3.0

/*
@interface NSApplication()
- (void) speakString: (NSString *) string;						// NSApp speaks!
@end
*/

NSString * NumToStr( NSInteger myInteger )
{
    int myInt = myInteger ;
    NSString *intString = [ NSString stringWithFormat : @"%d", myInt ];

    return intString;
}

NSString * hb_NSSTRING_par( int iParam ) // NSUTF8StringEncoding
{
   return [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( iParam ) ? hb_parc( iParam ) : "" encoding:  NSWindowsCP1252StringEncoding ] autorelease ];   
}

NSAttributedString * hb_NSASTRING_par( int iParam )
{
   NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( iParam ) ? hb_parc( iParam ) : "" encoding:  NSUTF8StringEncoding ] autorelease ];
   NSData * data = [ string dataUsingEncoding: NSUTF8StringEncoding ];

   return [ [ [ NSAttributedString alloc ] initWithRTF: data documentAttributes: NULL ] autorelease ];   
}

HB_FUNC( RANDOMMINMAX)
{
   hb_retni( ( arc4random() % ( hb_parni(2) - hb_parni(1) + 1 ) ) + hb_parni(1) ) ;
}

HB_FUNC( OSVERSION)
{

   NSString * version = [[NSProcessInfo processInfo] operatingSystemVersionString];

   hb_retc( [ version cStringUsingEncoding: NSWindowsCP1252StringEncoding ] );
}


HB_FUNC( SDKVERSION)
{
    NSString * version  = @" " ;
  
 #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090	
       version = @"1090"  ;
 #else
      #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1080	
    		   version = @"1080" ;  
    	#else
    		  #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070	
    		   version = @"1070" ;  
    	#else
    		 #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
    		   version = @"1060" ;  
    	   #else
    		    #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1050	
    		      version = @"1050" ;  
    	  		#else
    		      version = @"1040" ;      		   
    	   		#endif    		     		   
    	   #endif   
    	#endif  
   #endif
 #endif
    
 hb_retc( [ version cStringUsingEncoding:NSUTF8StringEncoding ] );
}


HB_FUNC( VALIDEMAIL )
{
    NSString * string = hb_NSSTRING_par( 1 );   
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * emailTest = [ NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex ];

    hb_retl( [emailTest evaluateWithObject: string ] );
}

HB_FUNC( SPEAK )
{
  NSSpeechSynthesizer * synth = [ [ NSSpeechSynthesizer alloc ] initWithVoice: nil ];
  NSString * string = hb_NSSTRING_par( 1 );   
  [ synth startSpeakingString: string ];
}

HB_FUNC( SLEEP )
{
 [NSThread sleepForTimeInterval: hb_parnl(1)/1.0];
}

HB_FUNC( NSSTRINGTOSTRING ) 
{
   NSString * string = ( NSString * ) hb_parnl( 1 );
   hb_retc( [ string cStringUsingEncoding : NSUTF8StringEncoding ] );
}   

HB_FUNC( STRINGTONSTRING ) 
{
 NSString * string = [ [ [ NSString alloc ] initWithCString: HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "" encoding: hb_parnl( 2 ) ] autorelease ];
 hb_retnl( ( HB_LONG ) string );
}

HB_FUNC( NSSTRINGCANCONVERENCODE ) 
{
 NSString * string = ( NSString * ) hb_parnl( 1 );
 hb_retl( [ string canBeConvertedToEncoding:hb_parnl( 2 ) ] ) ;
}

HB_FUNC( GETSERIALNUMBER )
{
    NSString *serial = nil;

    io_service_t platformExpert = IOServiceGetMatchingService(kIOMainPortDefault,
                                                              IOServiceMatching("IOPlatformExpertDevice"));
    if (platformExpert) {
        CFTypeRef serialNumberAsCFString =
        IORegistryEntryCreateCFProperty(platformExpert,
                                        CFSTR(kIOPlatformSerialNumberKey),
                                        kCFAllocatorDefault, 0);
        if (serialNumberAsCFString) {
            serial = CFBridgingRelease(serialNumberAsCFString);
        }
        
        IOObjectRelease(platformExpert);
    }
  hb_retc( [ serial cStringUsingEncoding : NSUTF8StringEncoding ]  );
}

HB_FUNC( NSLOG )
{
  NSLog( @"%@", hb_NSSTRING_par( 1 ) );
}   

HB_FUNC( NSNLOG )
{
    NSLog( @"%i", hb_parni( 1 ) );
}


HB_FUNC( ISCAPSLOCKDOWN )
{
 bool wasCapsLockDown = CGEventSourceKeyState(kCGEventSourceStateHIDSystemState, 57) ;
 hb_retl( ( BOOL ) wasCapsLockDown );
}
    
/*
HB_FUNC( SAVESCREEN )
{

    // Creamos la captura de pantalla...
    CGImageRef image = CGAutorelease(CGWindowListCreateImage(CGRectInfinite, 
                                                               kCGWindowListOptionOnScreenOnly, 
                                                               kCGNullWindowID, 
                                                               kCGWindowImageDefault));
    
    //...y la guardamos.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // guardaremos la captura en formato .tiff
    NSString *extCapture = @".tiff";
    NSString *numCapture = [[NSString alloc] init];
    // Guardaremos la captura en el escritorio.
     NSString *pathCapture = [NSHomeDirectory() stringByAppendingPathComponent: @"Desktop"];
     BOOL saved = NO;
     int n = 0;
        
        while (!saved) {
            numCapture = [[[NSNumber alloc] initWithInt: n] stringValue];
            // El nombre por defecto de la captura + un nââ«mero de captura + su extensiââ¥n.
            NSString* nameCapture = [[@"CapturaPantalla" stringByAppendingString: numCapture]
                                     stringByAppendingString: extCapture];
            
            // Comprobamos si ya existe una captura con un determinado nââ«mero de captura en el
            // escritorio. Si no existe la guardamos, si existe aumentamos el nââ«mero de captura
            // y comprobamos de nuevo.
            if ([fileManager fileExistsAtPath: [pathCapture stringByAppendingPathComponent: nameCapture]])
                n++;
            else {            
                NSBitmapImageRep *capture = [[NSBitmapImageRep alloc] initWithCGImage: image];
                NSData *dataImage = [capture TIFFRepresentation];
                
                saved = [dataImage writeToFile: [pathCapture stringByAppendingPathComponent: nameCapture]
                                    atomically: YES];
            }
        }
        
     hb_retl( saved );        
 }
    

HB_FUNC( ANIMABOTES )
{
      
    BOOL salta =  hb_parl( 1 ) ;    
    
    // Creamos la captura de pantalla...
    CGImageRef capture = CGAutorelease(CGWindowListCreateImage(CGRectInfinite, 
                                                             kCGWindowListOptionOnScreenOnly, 
                                                             kCGNullWindowID, 
                                                             kCGWindowImageDefault));

    // Creamos una ventana del tamaâÂ±o de la pantalla.
    NSRect displayBounds = [[NSScreen mainScreen] frame];
    NSWindow * window = [[NSWindow alloc] initWithContentRect: displayBounds 
                                         styleMask: NSBorderlessWindowMask 
                                           backing: NSBackingStoreRetained
                                             defer: NO 
                                            screen: [NSScreen mainScreen]];
    
    // Hacemos que el NSView de la ventana principal permita CALayers.
    // Y coloreamos su fondo con un color solido (negro en este caso).
    NSView *contentView = [window contentView];
    contentView.wantsLayer = YES;
    contentView.layer.backgroundColor = CGAutorelease(CGColorCreateGenericGray(0.0, 1.0));
    
    /////////
    //  Empezamos con lo interesante: lo primero configurar las CALayer.
    /////////////////////////////////////////////////////////////////////
    
    // Creamos una CALayer para la captura de pantalla que acabamos de realizar.
    CALayer *screenLayer = [CALayer layer];
    screenLayer.frame = CGRectMake(0,
    							   0,
    							   CGImageGetWidth(capture),
    							   CGImageGetHeight(capture));
    screenLayer.contents = (id) capture;
    
    // AâÂ±adimos un contenedor donde almacenar nuestras CALayers de la captura y su reflejo.
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = screenLayer.frame;
    [containerLayer addSublayer: screenLayer];
    
    // Creamos la CALayer para el reflejo de la captura.
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = screenLayer.contents;
    reflectionLayer.opacity = 0.4;
    reflectionLayer.frame = CGRectOffset(screenLayer.frame,
    									 0.5,
    									 -NSHeight(displayBounds) + 0.5);
    reflectionLayer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0); // Volteamos el eje Y.
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    [containerLayer addSublayer: reflectionLayer];
    
    // Creamos una CALayer para la sombra situada encima de la CALayer del reflejo.
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = reflectionLayer.bounds;
   // shadowLayer.delegate = self;
    // Ahara que somos el delegado de la CALayer, la lââ nea siguiente invocarâÂ° el mâÂ©todo
    // -drawLayer:inContext: implementado mâÂ°s arriba.
    [shadowLayer setNeedsDisplay];
    [reflectionLayer addSublayer: shadowLayer];
    
    // AâÂ±adimos la CALayer contenedora a la CALayer del NSView de la ventana principal.
    [contentView.layer addSublayer: containerLayer];
    
    // Situamos la ventana principal en frente de todo.
    [window setLevel: CGShieldingWindowLevel()];
    [window makeKeyAndOrderFront: nil];
    
    ////////
    // Comenzamos a animar
    ////////////////////////
    
    [CATransaction begin];
    [CATransaction setValue: [NSNumber numberWithFloat: DURATION_ANIMATION]
                     forKey: kCATransactionAnimationDuration];
    
    // Creamos la animaciââ¥n con el efecto de encogimiento. Esto harâÂ° que la imagen se vaya
    // haciendo mâÂ°s y mâÂ°s pequeâÂ±a.
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    shrinkAnimation.toValue = [NSNumber numberWithFloat: 0.0];
    [containerLayer addAnimation: shrinkAnimation forKey: @"shrinkAnimation"];
    
    // Creamos la animaciââ¥n con el efecto de desvanecimiento. Esto harâÂ° que la imagen se vaya
    // desvaneciendo mientras se encoje.
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    fadeAnimation.toValue = [NSNumber numberWithFloat: 0.5];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    [containerLayer addAnimation: fadeAnimation forKey: @"fadeAnimation"];
  
     
    
    
   if ( salta ) 
   {

    
    // Creamos los key frame de la animaciââ¥n que darâÂ°n el efecto de que la imagen da saltos
    // mientras se encoje y desvanece.
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
    CGMutablePathRef positionPath = CGAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(positionPath, NULL, containerLayer.position.x, containerLayer.position.y);
    
    
    CGPathAddQuadCurveToPoint(positionPath, NULL,
                              containerLayer.position.x,
                              containerLayer.position.y,
                              containerLayer.position.x, 
                              containerLayer.position.y);
           
    CGPathAddQuadCurveToPoint(positionPath, NULL, 
                              containerLayer.position.x,
                              containerLayer.position.y * 2,
                              containerLayer.position.x,
                              containerLayer.position.y);
    
         
    CGPathAddQuadCurveToPoint(positionPath, NULL, 
                              containerLayer.position.x,
                              containerLayer.position.y * 2.5, 
                              containerLayer.position.x,
                              containerLayer.position.y);
  
   
    positionAnimation.path = positionPath;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    [containerLayer addAnimation: positionAnimation forKey: @"positionAnimation"];
   
    }  
    
    // Iniciamos la animaciââ¥n.
    [CATransaction commit];
    
    // Luego de hacer la captura, guardarla y realizar la animaciââ¥n cerramos la aplicaciââ¥n.
   // [NSApp performSelector: @selector(terminate:) withObject: nil afterDelay: DURATION_ANIMATION];    
    
}



HB_FUNC( ANIMASHAKE )
{
  // conseguinmos el frame a animar 
    
  NSWindow * window = ( NSWindow * ) hb_parnl( 1 );
  NSRect frame = [ window frame ];   
    
  int   numberOfShakes  = hb_parni( 2 );
  float durationOfShake = ( hb_parnl( 3 )/1.0 );
  float vigourOfShake   = ( hb_parnl( 4 )/100.0 );
    
CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
CGMutablePathRef shakePath = CGPathCreateMutable();

CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));

int index;
for (index = 0; index < numberOfShakes; ++index)
{
    // Movimiento hacia la izquierda.
    CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
    // Movimiento hacia la derecha.
    CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
    // Movimiento hacia abajo. 
    CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame) - frame.size.width * vigourOfShake);
    // Movimiento hacia arriba.
    CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame) + frame.size.width * vigourOfShake);        
}
CGPathCloseSubpath(shakePath);
shakeAnimation.path = shakePath;
shakeAnimation.duration = durationOfShake;
shakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];


[ window setAnimations: [NSDictionary dictionaryWithObject:  shakeAnimation forKey: @"frameOrigin" ] ];
[[window animator] setFrameOrigin:  frame.origin ];
       

}
*/

HB_FUNC( ANIMASHAKE )
{
}

