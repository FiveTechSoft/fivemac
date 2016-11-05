#include <fivemac.h>

HB_FUNC( IMGCREATE ) // hWnd
{
   NSImageView * image = [ [ NSImageView alloc ] 
 			           initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ GetView( window ) addSubview : image ];
    
   hb_retnl( ( HB_LONG ) image );
}

HB_FUNC( IMGSETFILE )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   
   [ image setImage : [ [ NSImage alloc ] initWithContentsOfFile : string ] ];
   [ [ image image ] setName: string ]; 
}   

HB_FUNC( IMGSETNSIMAGE )
{
    NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
    NSImage * hImg =  ( NSImage * ) hb_parnl( 2 );
    
    [ image setImage : hImg ];
 }  

HB_FUNC( NSIMAGEFROMNAME )
{
  NSString * string = hb_NSSTRING_par( 1 );
  NSImage * image ;
    
  NSFileManager * filemgr = [ NSFileManager defaultManager ];
    
  if( [ filemgr fileExistsAtPath: string ] ) 
        image = [ [ NSImage alloc ] initWithContentsOfFile : string ]  ; 
    else
        image = ImgTemplate( string ) ;
        
  hb_retnl( ( HB_LONG ) image );    
} 


HB_FUNC( IMGGETFILE )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = [ [ image image ] name ];
   
   hb_retc( [ string cStringUsingEncoding : NSWindowsCP1252StringEncoding ] );
}

HB_FUNC( IMGSETFRAME )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
 
   [ [ image animator ] setImageFrameStyle: hb_parni( 2 ) ];
    
   // [ image setImageFrameStyle : NSImageFrameGrayBezel ];
}   

HB_FUNC( IMGSETSCALING )
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
 
   [  image  setImageScaling: hb_parni( 2 ) ];
} 

HB_FUNC( IMGSETRESFILE ) // Read image from the app resources folder
{
   NSImageView * image = ( NSImageView * ) hb_parnl( 1 );
   NSString * string = hb_NSSTRING_par( 2 );
   NSString * myImagePath = [ [ [ NSBundle mainBundle ] resourcePath ] stringByAppendingString: string ];
  
   [ image setImage : [ [ NSImage alloc ] initWithContentsOfFile : myImagePath ] ];
}

HB_FUNC( CHOOSESHEETIMAGE )
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
      NSImageView * vista = ( NSImageView * ) hb_parnl( 1 );
      NSOpenPanel * panel = [ NSOpenPanel openPanel ];
    
      [ panel setMessage: @"Import the file" ];
    	
      [ panel beginSheetModalForWindow: [vista window ] completionHandler:^(NSInteger result)
      {
         if (result == NSFileHandlingPanelOKButton)
         {
            [ vista setHidden: NO ];
            [ vista setImage  : [ [ NSImage alloc ] initWithContentsOfURL : [[panel URLs] objectAtIndex:0] ] ];
            NSString *source =  [[[[panel URLs] objectAtIndex:0]  path]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ [ vista image ] setName: source ]  ;
         } 
      } ];
   #endif    
}

HB_FUNC( NEWRESIZEIMAGE )
{
  NSImageView * vista = ( NSImageView * ) hb_parnl( 1 );
    NSString * fileName = hb_NSSTRING_par( 2 );
   
    
    NSSize newSize;
    newSize.width = hb_parnl( 3 );
    newSize.height = hb_parnl( 4 );

    NSImage *sourceImage = [ vista image ] ;
    
  //  [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        
        
        
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        
        NSData *imageData = [smallImage TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
        [imageData writeToFile:fileName atomically:NO];
        
        
    }
   
}


HB_FUNC( SIZEWIDTHIMAGE )
{

  NSImageView * vista = ( NSImageView * ) hb_parnl( 1 );
  
  NSImage *sourceImage = [ vista image ] ;
  NSData *imageData = [sourceImage TIFFRepresentation];
  NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];

NSInteger width = [imageRep pixelsWide];
//NSInteger height = [imageRep pixelsHigh];

 hb_retnl( ( HB_LONG ) width );

}


HB_FUNC( SIZEHEIGHTIMAGE )
{
    
    NSImageView * vista = ( NSImageView * ) hb_parnl( 1 );
    //  NSString * fileName = hb_NSSTRING_par( 2 );
    
    NSImage *sourceImage = [ vista image ] ;
    NSData *imageData = [sourceImage TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    
 //   NSInteger width = [imageRep pixelsWide];
    NSInteger height = [imageRep pixelsHigh];
    
    hb_retnl( ( HB_LONG ) height );
    
}

HB_FUNC( NSIMGFROMFILE )
{
    NSString * fileName = hb_NSSTRING_par( 1 );
    NSImage *image = [[NSImage alloc]initWithContentsOfFile: fileName ];
    hb_retnl( ( HB_LONG ) image );
}



HB_FUNC( NSIMGGETWIDTH )
{
    
    NSImage * image = ( NSImage * ) hb_parnl( 1 );
    NSImageRep * rep = [ [ image representations ] objectAtIndex:0 ];
    
    hb_retnl( rep.pixelsWide );
}


HB_FUNC( NSIMGGETHEIGHT )
{
    NSImage * image = ( NSImage * ) hb_parnl( 1 );
    NSImageRep * rep = [ [ image representations ] objectAtIndex:0 ];
    
    hb_retnl( rep.pixelsHigh );
}


HB_FUNC( SAVEIMAGEFROMIMAGE )
{
    NSString * fileIni = hb_NSSTRING_par( 1 );
    NSString * fileFin = hb_NSSTRING_par( 2 );
    
    NSString *extension =  [ [fileFin substringFromIndex:[fileFin length] - 3] uppercaseString ];
    NSImage *sourceImage =  [[NSImage alloc]initWithContentsOfFile: fileIni ];
    
    NSSize newSize;
    newSize.width = hb_parnl( 3 );
    newSize.height = hb_parnl( 4 );
    
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        
        NSData *imageData = [smallImage TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        
        if  ([extension isEqualToString:@"JPG"] )
        {
            imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
            [imageData writeToFile:fileFin atomically:NO];
        }
        
        if  ([extension isEqualToString:@"PNG"] )        {
            imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
            [imageData writeToFile:fileFin atomically:NO];
        }
        
        if  ([extension isEqualToString:@"BMP"] )
        {
            imageData = [imageRep representationUsingType:NSBMPFileType properties:imageProps];
            [imageData writeToFile:fileFin atomically:NO];
        }
        
        if ([extension isEqualToString:@"GIF"] )
        {
            imageData = [imageRep representationUsingType:NSGIFFileType properties:imageProps];
            [imageData writeToFile:fileFin atomically:NO];
        }
        
        if ([extension isEqualToString:@"TIF"] || [extension isEqualToString:@"IFF"])
         {
            imageData = [imageRep representationUsingType:NSTIFFFileType properties:imageProps];
            [imageData writeToFile:fileFin atomically:NO];
        }
        
    }
    
}


HB_FUNC( SAVETEXTINIMAGE ) // fileini,filefin,ctexto, fuente, ntop, nleft
{
    NSString * fileIni = hb_NSSTRING_par( 1 );
    NSString * fileFin = hb_NSSTRING_par( 2 );
    
    NSString * text = hb_NSSTRING_par( 3 );
    
    
    
    NSString *extension =  [ [fileFin substringFromIndex:[fileFin length] - 3] uppercaseString ];
    
    NSImage *iniImage =  [[NSImage alloc]initWithContentsOfFile: fileIni ];
    
    NSImage *finImage = [NSImage imageWithSize: iniImage.size flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
        [iniImage drawInRect:dstRect];
        
        // Attributes permite customizar fuente, color, etc.
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:hb_parnl( 4 ) ]};
        
        [text drawAtPoint:NSMakePoint(hb_parnl( 6 ),hb_parnl( 5 ) ) withAttributes:attributes];
        
        return YES;
    }];
    
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:[finImage CGImageForProposedRect:NULL context:nil hints:nil]];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];

    
    NSData *imageData ;
    
    if  ([extension isEqualToString:@"JPG"] )
    {
        imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
        [imageData writeToFile:fileFin atomically:NO];
    }
    
    if  ([extension isEqualToString:@"PNG"] )        {
        imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
        [imageData writeToFile:fileFin atomically:NO];
    }
    
    if  ([extension isEqualToString:@"BMP"] )
    {
        imageData = [imageRep representationUsingType:NSBMPFileType properties:imageProps];
        [imageData writeToFile:fileFin atomically:NO];
    }
    
    if ([extension isEqualToString:@"GIF"] )
    {
        imageData = [imageRep representationUsingType:NSGIFFileType properties:imageProps];
        [imageData writeToFile:fileFin atomically:NO];
    }
    
    if ([extension isEqualToString:@"TIF"] || [extension isEqualToString:@"IFF"])
    {
        imageData = [imageRep representationUsingType:NSTIFFFileType properties:imageProps];
        [imageData writeToFile:fileFin atomically:NO];
    }
    
    
    
    //NSData *data = [rep representationUsingType:NSPNGFileType properties:nil];
    //[data writeToFile: finFile atomically:YES];
    
}



/*
 HB_FUNC( IMGMASREFLEXSETFILE )
 {
 NSImageView * imageView = ( NSImageView * ) hb_parnl( 1 );
 NSString * string =  hb_NSSTRING_par( 2 ) ;
 NSImage * image = [ [ NSImage alloc ] initWithContentsOfFile : string ] ;
 
 (CGFloat)percentage = ( hb_parnl( 3 )/100.0 ) ;
 
 CGRect offscreenFrame = CGRectMake(0, 0, image.size.width, image.size.height*(1.0+percentage));
 NSBitmapImageRep * offscreen = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
  		 pixelsWide:offscreenFrame.size.width
  		 pixelsHigh:offscreenFrame.size.height
  		 bitsPerSample:8
  		 samplesPerPixel:4
  		 hasAlpha:YES
  		 isPlanar:NO
  		 colorSpaceName:NSDeviceRGBColorSpace
  		 bitmapFormat:0
  		 bytesPerRow:offscreenFrame.size.width * 4
   		 bitsPerPixel:32];
  
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:offscreen]];
  [[NSColor clearColor] set];
  
  NSRectFill(offscreenFrame);
 
  NSGradient * fade = [[NSGradient alloc] initWithStartingColor:
                      [NSColor colorWithCalibratedWhite:1.0 alpha:0.2] endingColor:[NSColor clearColor]];
 
  CGRect fadeFrame = CGRectMake(0, 0, image.size.width, offscreen.size.height - image.size.height);
  [fade drawInRect:fadeFrame angle:270.0]; 
 
  NSAffineTransform* transform = [NSAffineTransform transform];
  [transform translateXBy:0.0 yBy:fadeFrame.size.height];
  [transform scaleXBy:1.0 yBy:-1.0];
  [transform concat];
  
  [self drawAtPoint:NSMakePoint(0, 0) fromRect:CGRectMake(0, 0, self.size.width, self.size.height)
  									 operation:NSCompositeSourceIn fraction:1.0];
  
  [transform invert];
  [transform concat];
  
  [image drawAtPoint:CGPointMake(0, offscreenFrame.size.height - self.size.height)
                fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

   [NSGraphicsContext restoreGraphicsState];
  
   NSImage * imageWithReflection = [[NSImage alloc] initWithSize:offscreenFrame.size];
   [imageWithReflection addRepresentation:offscreen];
   
  [ imageView setImage : imageWithReflection ];
  
}

HB_FUNC( IMAGESETROTATE ) 
{
NSImageView * imageView = ( NSImageView * ) hb_parnl( 1 );
NSImage * image = [imageView image ] ;

(CGFloat)degrees = ( hb_parnl( 2 )/100.0 ) ;

 NSRect imageBounds = {NSZeroPoint, [image size]};
 NSBezierPath* boundsPath = [NSBezierPath bezierPathWithRect:imageBounds];
 NSAffineTransform* transform = [NSAffineTransform transform];
[transform rotateByDegrees:degrees];
[boundsPath transformUsingAffineTransform:transform];
 
 NSRect rotatedBounds = {NSZeroPoint, [boundsPath bounds].size};

 NSImage* rotatedImage = [[NSImage alloc] initWithSize:rotatedBounds.size];
 imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth (imageBounds) / 2);
 imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight (imageBounds) / 2);
 
 transform = [NSAffineTransform transform];

 [transform translateXBy:+(NSWidth(rotatedBounds) / 2) yBy:+ (NSHeight(rotatedBounds) / 2)];
 
 [transform rotateByDegrees:degrees];
 [transform translateXBy:-(NSWidth(rotatedBounds) / 2) yBy:- (NSHeight(rotatedBounds) / 2)];
 
 [rotatedImage lockFocus];
 [transform concat];
 
 [image drawInRect:imageBounds fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0] ;
 
 [rotatedImage unlockFocus];
 [ imageView setImage : rotatedImage ];
 
 // [rotatedImage autorelease];

}
*/
 
HB_FUNC( IMAGETODESKTOPWALLPAPER ) 
{
   #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060
      NSString * path = hb_NSSTRING_par( 1 );
      NSURL * imageURL = [ [ NSURL alloc ] initFileURLWithPath: path ];
      NSError * error;
      NSDictionary * options = [ NSDictionary dictionaryWithObjectsAndKeys: [ NSNumber numberWithBool:NO], NSWorkspaceDesktopImageAllowClippingKey, [NSNumber numberWithInteger:NSImageScaleProportionallyUpOrDown], NSWorkspaceDesktopImageScalingKey, nil ];
      BOOL result = [ [ NSWorkspace sharedWorkspace ] setDesktopImageURL: imageURL 
      	            forScreen: [ [ NSScreen screens ] lastObject ] options: options 
      	            error: &error ];
    
      if( ! result ) 
      {
         [ NSApp presentError: error ];
      }
   #endif	
}
