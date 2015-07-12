#include <fivemac.h>
#import <Quartz/Quartz.h>

@interface MIKImageView : IKImageView  

   NSURL * selectedImageURL ;
 
//- (NSString*)fileName   ; 

- (NSURL*)selectedImageURL;
- (void)setSelectedImageURL: (NSURL*)url;	
    
@end

@implementation MIKImageView 

//---------------------------------------------------------------------------------------------------------------------- 
- (NSString*)fileName
{
    return [[[self selectedImageURL] path] lastPathComponent];
}

//---------------------------------------------------------------------------------------------------------------------- 
- (NSURL*)selectedImageURL
{
    return selectedImageURL;
}

//---------------------------------------------------------------------------------------------------------------------- 
- (void)setSelectedImageURL: (NSURL*)url
{
    [self willChangeValueForKey: @"fileName"];
    [selectedImageURL release];
    selectedImageURL = [url retain];
    [self didChangeValueForKey: @"fileName"];
}


- (void)pictureTakerDidEnd:(IKPictureTaker *)pictureTaker returnCode:(NSInteger)returnCode contextInfo:(void  *)contextInfo
{
    static int snapCount = 0;
    
    if(returnCode == NSOKButton){
        NSImage *image = [pictureTaker outputImage];
        
        NSString *outputPath = [NSString stringWithFormat:@"/tmp/snap%d.tiff", ++snapCount];
        
        [[image TIFFRepresentation] writeToFile:outputPath atomically:YES];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:outputPath ];
        [self  setImageWithURL:fileURL ]; 
        [self  setSelectedImageURL : fileURL ] ;
        
    }
}


// ---------------------------------------------------------------------------------------------------------------------


@end


HB_FUNC( PHOTOCAMLOAD )
{
    MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1);  
    IKPictureTaker *foto = [IKPictureTaker pictureTaker];
    
    [foto setValue:[NSNumber numberWithBool:YES] forKey:IKPictureTakerShowEffectsKey];
    [foto beginPictureTakerSheetForWindow: [vista window ] withDelegate: vista didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    
}


HB_FUNC( SIMAGECREATE )
{

   NSScrollView * sv = [ [ NSScrollView alloc ]
                   initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 4 ) ) ];


   [ sv setAutoresizingMask : NSViewWidthSizable | NSViewHeightSizable ];
   [ sv setHasVerticalScroller : YES ];
   [ sv setHasHorizontalScroller : YES ];
   [ sv setBorderType : NSBezelBorder ];

   MIKImageView  * vista = [ [ MIKImageView alloc ] initWithFrame : [ [ sv contentView ] frame ] ];


   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );

   [ sv setDocumentView : vista ];

   [ GetView( window ) addSubview : sv ];

  // [ GetView( window ) addSubview : vista ];


    hb_retnl( ( HB_LONG ) vista );
}


HB_FUNC( SIMAGEOPEN )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );
   NSString * path = hb_NSSTRING_par( 2 )
 
   NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];

   [vista  setImageWithURL:fileURL ];
   
    hb_retnl( ( HB_LONG )[fileURL path ] ); 
}

HB_FUNC( SIMAGEFIT )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista zoomImageToFit:vista ];

   }

HB_FUNC( SIMAGEZOOMIN )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista zoomIn:vista ];

}

HB_FUNC( SIMAGEROTALEFT )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista rotateImageLeft:vista ];

}

HB_FUNC( SIMAGEROTARIGHT )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista rotateImageRight:vista ];

}
HB_FUNC( SIMAGEZOOMOUT )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista zoomOut:vista ];

}
HB_FUNC( SIMAGEVFLIP )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista flipImageVertical:vista ];

}

HB_FUNC( SIMAGEEDIT )
{
   MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );

   [vista setCurrentToolMode: IKToolModeMove];
    [vista setDoubleClickOpensImageEditPanel: YES];
}


HB_FUNC( SIMAGEAUTORESIZE )
{

   MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
   [ vista setAutoresizes: hb_parl( 2 ) ];
}

HB_FUNC( SIMAGEGETAUTORESIZE )
{

   MIKImageView  * vista = ( MIKImageView  *) hb_parnl( 1 );
   hb_retl( ( BOOL ) [vista autoresizes ]);
}


HB_FUNC( SIMAGESETCROP )
{
     MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
   [ vista setCurrentToolMode: IKToolModeCrop ];
}


HB_FUNC( SIMAGESETROTATE )
{
  MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
   [ vista setCurrentToolMode: IKToolModeRotate ];
}

HB_FUNC( SIMAGESETNORMAL )
{
   MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
   [ vista setCurrentToolMode: IKToolModeNone ];
}

HB_FUNC( SIMAGESETHIDE )
{
    MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
    [ vista setHidden: YES ];
}

HB_FUNC( SIMAGESETSHOW )
{
    MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1 );
    [ vista setHidden: NO ];
}

HB_FUNC( CHOOSESHEETSIMAGE )
{
    MIKImageView * vista = ( MIKImageView *) hb_parnl( 1 );
    
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
        
    [panel setMessage:@"Importe el Archivo"];

    #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
    [panel beginSheetModalForWindow:[vista window ] completionHandler:^(NSInteger result)
	{
       if (result == NSFileHandlingPanelOKButton)
       {
          [ vista setHidden: NO ];
          [ vista setImageWithURL: [[panel URLs] objectAtIndex:0]  ];    
          [ vista setSelectedImageURL : [[panel URLs] objectAtIndex:0] ] ;
	   } 
	} ];
    #endif      
}
   
HB_FUNC( SIMAGESAVEAS )
{   
    MIKImageView * vista = ( MIKImageView  *) hb_parnl( 1);
     
    NSSavePanel *   savePanel;
    NSString *      utType;
    NSDictionary *  metaData;
    NSString *      fileName;
    IKSaveOptions *  saveOptions ;
    
    savePanel = [NSSavePanel savePanel];
    
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef) [vista selectedImageURL ] , NULL);     
    utType = (NSString*)CGImageSourceGetType(source);   
    
    if (utType)
    {
        
        metaData = [ vista imageProperties];
        fileName = [vista fileName]; 
        
        saveOptions  = [[IKSaveOptions alloc] initWithImageProperties: metaData imageUTType:  utType];
        
        [saveOptions  addSaveOptionsAccessoryViewToSavePanel: savePanel];
        
            
        [savePanel setNameFieldStringValue: [fileName stringByDeletingPathExtension] ];     
        [savePanel setMessage:@"Grabe el archivo"];         

        #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1060	
		[savePanel beginSheetModalForWindow:[ vista window ] completionHandler:^(NSInteger result)
        {
		   if (result == NSFileHandlingPanelOKButton) 
           {
                NSString * newUTType = [ saveOptions imageUTType];
                CGImageRef image = (CGImageRef) [vista image ];
                    
                if (image)
                {
                    NSURL * url  = [savePanel URL] ;
                    CGImageDestinationRef dest = CGImageDestinationCreateWithURL((CFURLRef) url, (CFStringRef)newUTType, 1, NULL);
                        
                    if (dest)
                    {
                        CGImageDestinationAddImage(dest, image, (CFDictionaryRef)[saveOptions imageProperties]);
                        CGImageDestinationFinalize(dest);
                        CFRelease(dest);
                    }
                 }
              }
              else
              {
                 NSLog(@"*** saveImageToPath - no image");
              }
        } ] ;
        #endif
	}
}
