#include <fivemac.h>
 #import <QTKit/QTKit.h>
 
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090	
 
 #import <AVFoundation/AVFoundation.h>
 #import <AVKit/AVKit.h>
 #import <CoreMedia/CMTime.h>

#endif

void MsgAlert( NSString *, NSString * messageText );



HB_FUNC( QTCAPTUREVIEWCREATE )
{
    QTCaptureView * mview = [ [ QTCaptureView alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                                                                             hb_parnl( 3 ), hb_parnl( 4 ) ) ];
    NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
    
    [ GetView( window ) addSubview : mview ];   
    [ mview setPreservesAspectRatio :YES ]; 
       
    hb_retnl( ( HB_LONG ) mview );
}

HB_FUNC( CAPTURECAM )
{
    
    QTCaptureView * vista = ( QTCaptureView *) hb_parnl( 1 ); 
    
    // Nueva Sesion de captura
    QTCaptureSession *  mCaptureSession = [[QTCaptureSession alloc] init]; 
    
    BOOL success = NO;
    NSError *error;
    
    
    // Buscar una camara de video 
    
    QTCaptureDevice *device = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
    if(device) {
        success = [device open:&error];
        if(!success) {
            MsgAlert(@"Error camara no encontrada", @"Atention" ) ;
            //NSRunAlertPanel( @"Atention" ,@"Error camara no encontrada", @"ok", NULL , NULL );
             return  hb_retl( success );     
        }
        
        // AÒadimos la camara ‡ la sesiÛn
        
        QTCaptureDeviceInput * mCaptureDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:device];
        success = [mCaptureSession addInput:mCaptureDeviceInput error:&error];
        if(!success) {
            MsgAlert( @"Error no se pudo añadir la camara a la sesion", @"Atention" ) ;
           // NSRunAlertPanel( @"Atention" ,@"Error no se pudo añadir la camara a la sesion", @"ok", NULL , NULL );
            return hb_retl( success );                   
        }
        
        // Asociamos la vista de captura con la sesiÛn
        [ vista setCaptureSession:mCaptureSession];
        
        // empezamos la captura
        //[mCaptureSession startRunning];
        
    }
    
    hb_retnl( ( HB_LONG ) mCaptureSession  );   
}

HB_FUNC( CAPTUREFILEOUTPUT )
{
  BOOL success = NO;
  NSError *error;
    
  QTCaptureSession *  mCaptureSession =  ( QTCaptureSession *) hb_parnl( 1 );
  NSString * string =hb_NSSTRING_par( 2 ) ;
  
  QTCaptureMovieFileOutput *out = [[QTCaptureMovieFileOutput alloc] init];
  [out recordToOutputFileURL:[NSURL fileURLWithPath: string ]];
    
  success = [mCaptureSession addOutput: out error:&error];

  if (!success) {
      MsgAlert( @"Error no se pudo añadir archivo de salida" , @"Atención") ;

  // NSRunAlertPanel( @"Atention" ,@"Error no se pudo añadir archivo de salida", @"ok", NULL , NULL );
   return  hb_retl( success );   
  }
//mCaptureMovieFileOutput setDelegate:self];
 hb_retnl( ( HB_LONG ) out );  
}


HB_FUNC( CAPTURESTART )
{
  QTCaptureSession * mCaptureSession = ( QTCaptureSession * ) hb_parnl( 1 );   
  [mCaptureSession startRunning];    
    
}


HB_FUNC( CAPTURESTOP )
{
 QTCaptureSession * mCaptureSession = ( QTCaptureSession * ) hb_parnl( 1 );    
 QTCaptureMovieFileOutput *out = ( QTCaptureMovieFileOutput *) hb_parnl( 2 );       
    
[out recordToOutputFileURL:nil];

[mCaptureSession removeOutput:out];
[mCaptureSession stopRunning];

}

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090	


HB_FUNC( AVCREATE )
{
    AVPlayerView * mview = [ [ AVPlayerView alloc ] initWithFrame : NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ), 
                 hb_parnl( 3 ), hb_parnl( 4 ) ) ];
   
   NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
  [ GetView( window ) addSubview : mview ];
 
   hb_retnl( ( HB_LONG ) mview );
}

HB_FUNC( AVOPEN )
{
  
   AVPlayerView * mview = ( AVPlayerView * ) hb_parnl( 1 );
   NSURL * stringUrl = [ [ [ NSURL alloc ] initWithString : hb_NSSTRING_par( 2 ) ] autorelease ];
    
   AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL: stringUrl ];
   AVPlayer * videoPlayer = [AVPlayer playerWithPlayerItem: playerItem ];
   [ mview setPlayer: videoPlayer];
 
}


HB_FUNC( AVOPENPANEL )
{
   
   AVPlayerView * mview = ( AVPlayerView * ) hb_parnl( 1 );
   NSOpenPanel * openPanel = [ NSOpenPanel openPanel ];
    
    
   [ openPanel setCanChooseDirectories : NO ];
    
   if( [ openPanel runModal ] == NSModalResponseOK )
   {
     AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL: [[ openPanel URLs ] objectAtIndex: 0  ] ];
     AVPlayer * videoPlayer = [AVPlayer playerWithPlayerItem: playerItem ];
    [ mview setPlayer: videoPlayer];
       
     
   }
   else
       MsgAlert( @"Movie format not supported" , @"Stop") ;
}

 HB_FUNC( AVPLAY )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
	[[ vista player  ] play ] ;	
}


HB_FUNC( AVPAUSE )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
	[[ vista player  ] pause ] ;	
}

HB_FUNC( AVSHOWFULLBUTTON )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
	vista.showsFullScreenToggleButton = hb_parl( 2 )  ;
}

HB_FUNC( AVSHOWSHARINGBUTTON )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
	vista.showsSharingServiceButton = hb_parl( 2 ) ;
}

HB_FUNC( AVSHOWFRAMEGBUTTON )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
	vista.showsFrameSteppingButtons = hb_parl( 2 ) ;
}

HB_FUNC( SETAVCONTROLSTYLEFLOATING )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    vista.controlsStyle = AVPlayerViewControlsStyleFloating ;
}

HB_FUNC( SETAVCONTROLSTYLEMINIMAL )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    vista.controlsStyle = AVPlayerViewControlsStyleMinimal ;
}



HB_FUNC( SETAVCONTROLSTYLEDEFAULT )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    vista.controlsStyle = AVPlayerViewControlsStyleDefault ;
}

HB_FUNC( SETAVCONTROLSTYLENONE )
{
	AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    vista.controlsStyle = AVPlayerViewControlsStyleNone ;
}

HB_FUNC( AVSEEKTIME )
{
    
  AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
  CMTime nSecondsIn = CMTimeMake( hb_parnl( 2 ), 1);
  [[ vista player ] seekToTime:nSecondsIn ];
    
}

HB_FUNC( GETAVDURATION )
{
    AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    CMTime duration = vista.player.currentItem.asset.duration ;
    float secondsFload = CMTimeGetSeconds(duration);
    int seconds = (int) secondsFload ;
    hb_retnl(seconds ) ;
}

HB_FUNC( AVTRIMMMOVIE )
{
    NSString * string = hb_NSSTRING_par( 2 );
    
    
    AVPlayerView * vista = ( AVPlayerView *) hb_parnl( 1 );
    if ([vista canBeginTrimming])
    {
        

        // Show trim user interface.
        [vista beginTrimmingWithCompletionHandler:^(AVPlayerViewTrimResult result) {
            // Handle trim result.
            if ( result == AVPlayerViewTrimOKButton )
            {
                
                AVAsset *asset = vista.player.currentItem.asset ;
                NSArray *compatiblePresets = [AVAssetExportSession
                                             exportPresetsCompatibleWithAsset:asset];
                
                
                
                if ([compatiblePresets containsObject: AVAssetExportPresetAppleM4A ]) {
                    
                
                    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                                           initWithAsset:asset presetName:AVAssetExportPresetAppleM4A  ];
                    
                    
                    exportSession.outputURL = [NSURL fileURLWithPath:string ];
                    
                
                    exportSession.outputFileType = AVFileTypeQuickTimeMovie ;
                    
                                        
                    // Get trim in and out points.
                      CMTime inPoint = [vista.player.currentItem reversePlaybackEndTime];
                      CMTime outPoint = [vista.player.currentItem forwardPlaybackEndTime];
                    // Set time range on asset export session.
                      CMTimeRange timeRange = CMTimeRangeFromTimeToTime(inPoint, outPoint);
                    
                      [exportSession setTimeRange:timeRange];
                    
                      [exportSession exportAsynchronouslyWithCompletionHandler:^() {
                        switch (exportSession.status) {
                            case AVAssetExportSessionStatusCompleted:
                                NSLog(@"It's done...hallelujah");
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    
                    
                }
                else
                    MsgAlert( @"3", @"Alert" ) ;
                
            }
            else if (result == AVPlayerViewTrimCancelButton)
            {
                
            }
        }];
        
        
    }
  
}


#endif

