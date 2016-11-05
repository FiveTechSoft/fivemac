#include <fivemac.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090	
 
 #import <AVFoundation/AVFoundation.h>
 #import <AVKit/AVKit.h>
 #import <CoreMedia/CMTime.h>

#else
   #import <QTKit/QTKit.h>

#endif

void MsgAlert( NSString *, NSString * messageText );


#ifdef DEBUG
#   define Log(...) NSLog(__VA_ARGS__)
#else
#   define Log(...)
#endif

#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureOutput.h>

@interface RecordingDelegate : NSObject <AVCaptureFileOutputDelegate,AVCaptureFileOutputRecordingDelegate>
@end

@interface RecordingDelegate () <AVCaptureFileOutputRecordingDelegate>
@end

@implementation RecordingDelegate

#pragma mark AVCaptureFileOutputRecordingDelegate

// This is never called.

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    Log(@"didFinishRecordingToOutputFileAtURL!");
    if (error) { Log(@"Error: %@", [error localizedDescription]); }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
   Log(@"willFinishRecordingToOutputFileAtURL!");
   // "Error: Recording Stopped"
   if (error) { Log(@"Error: %@", [error localizedDescription]); }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections; {
   
    Log(@"Recording started!");
}

#pragma mark AVCaptureFileOutputDelegate

- (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput {
   
    return NO;
}

@end

HB_FUNC( AVCAPTUREVIEWCREATE )
{
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ),hb_parnl( 3 ), hb_parnl( 4 ) ) ;
    
    NSWindow * window = ( NSWindow * ) hb_parnl( 5 );
    NSView * backView = [[NSView alloc] initWithFrame: NSMakeRect( hb_parnl( 2 ), hb_parnl( 1 ),hb_parnl( 3 ), hb_parnl( 4 ) ) ] ;
    backView.wantsLayer = YES ;
    backView.layer = previewLayer ;
    [ GetView( window ) addSubview : backView ] ;
    
    hb_retnl( ( HB_LONG ) previewLayer );
}

HB_FUNC( CREATECAPSESSION )
{
 AVCaptureSession *mCaptureSession = [[AVCaptureSession alloc] init];      
 hb_retnl( ( HB_LONG ) mCaptureSession  );  
}

HB_FUNC( CREATECAPSCREENINPUT )
{
   AVCaptureScreenInput *mCaptureDeviceInput = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
   mCaptureDeviceInput.capturesMouseClicks = YES ;
           
   hb_retnl( ( HB_LONG ) mCaptureDeviceInput );   
}

HB_FUNC( SETCAPSCREENCROP )
{
 AVCaptureScreenInput *mCaptureDeviceInput  = ( AVCaptureScreenInput *) hb_parnl( 1 );
 mCaptureDeviceInput.cropRect = CGRectMake(hb_parnl(2),hb_parnl(3),hb_parnl(4), hb_parnl(5) );    
}

HB_FUNC( SETCAPSCREENFACTOR )
{
 AVCaptureScreenInput *mCaptureDeviceInput  = ( AVCaptureScreenInput *) hb_parnl( 1 );
 mCaptureDeviceInput.scaleFactor = hb_parnl( 2 );
}

HB_FUNC( SETCAPSCREENMOUSECLICK )
{
 AVCaptureScreenInput *mCaptureDeviceInput  = ( AVCaptureScreenInput *) hb_parnl( 1 );
 mCaptureDeviceInput.capturesMouseClicks =  hb_parl( 2 );
}

HB_FUNC( CREATECAPDEFDEVINPUTVIDEO )
{
   // camara de video default
   AVCaptureDevice *device =  [ AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo ];
    hb_retnl( ( HB_LONG ) device );
 }   

HB_FUNC( CREATECAPDEFDEVINPUTAUDIO )
{
   // micro audio default
   AVCaptureDevice *device =  [ AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeAudio ];
    hb_retnl( ( HB_LONG ) device );
 }   

HB_FUNC( CREATECAPDEVINPUT )
{

  NSError * error = NULL;
  
  AVCaptureDevice * device = ( AVCaptureDevice *) hb_parnl( 1 );
 
  if(!device) {
       MsgAlert(@"Error camara no encontrada", @"Atention" ) ;
       return  hb_retl( false );
    }
        
   // AÒadimos la camara como dispositivo de entrada
    AVCaptureDeviceInput * mCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
   hb_retnl( ( HB_LONG ) mCaptureDeviceInput );   
}

HB_FUNC( AVCAPTURESETSESSION )
{

  AVCaptureVideoPreviewLayer * vista = ( AVCaptureVideoPreviewLayer *) hb_parnl( 1 );
  AVCaptureSession * mCaptureSession = ( AVCaptureSession * ) hb_parnl( 2 );
  // Asociamos la vista de captura con la sesiÛn
    vista.session = mCaptureSession ;
 }

HB_FUNC( AVCAPTURESETINPUT )
{

  AVCaptureSession * mCaptureSession = ( AVCaptureSession * ) hb_parnl( 1 );
  AVCaptureDeviceInput * mCaptureDeviceInput = (  AVCaptureDeviceInput * ) hb_parnl( 2 );
  
  [mCaptureSession addInput:mCaptureDeviceInput];
  
 }

HB_FUNC( AVCAPTURESETOUTPUT )
{

  AVCaptureSession * mCaptureSession = ( AVCaptureSession * ) hb_parnl( 1 );
  AVCaptureMovieFileOutput *out  = (   AVCaptureMovieFileOutput * ) hb_parnl( 2 );
    
   if ( [ mCaptureSession canAddOutput: out ] ){
        [ mCaptureSession addOutput: out ];
    }
    
 }

/*
HB_FUNC( CAPTURECAM )
{
    
   NSError * error = NULL;
   
   AVCaptureVideoPreviewLayer * vista = ( AVCaptureVideoPreviewLayer *) hb_parnl( 1 );
    
   
   // Buscar una camara de video
   AVCaptureDevice *device =  [ AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo ];
    
   if(!device) {
       MsgAlert(@"Error camara no encontrada", @"Atention" ) ;
       return  hb_retl( false );
    }
        
    // AÒadimos la camara como dispositivo de entrada
    AVCaptureDeviceInput * mCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    // Nueva Sesion de captura
    
   // configuramos la sesion de captura ( por probar aun ) 
   // [ mCaptureSession beginConfiguration];
   //   mCaptureSession.sessionPreset = AVCaptureSessionPresetHigh;
   // [ mCaptureSession addInput:mCaptureDeviceInput];
   // [ mCaptureSession addInput:self.audioInput];
   // [ mCaptureSession addOutput:self.movieOutput];
   // [ mCaptureSession addOutput:self.stillImageOutput];
   // [ mCaptureSession commitConfiguration];
    
    
   // a¤adimos a la sesion el dispositivo de entrada
   if(mCaptureDeviceInput){
        [mCaptureSession addInput:mCaptureDeviceInput];
    }
    else{
        NSLog(@"Input Error:%@", error);
    }
    
          
    // Asociamos la vista de captura con la sesiÛn
     vista.session = mCaptureSession ;
        
   hb_retnl( ( HB_LONG ) mCaptureSession  );
}
*/

HB_FUNC( CREATECAPDEVOUTPUT )
{

    NSString * string =hb_NSSTRING_par( 1 ) ;
  
    NSURL * destPath = [NSURL fileURLWithPath: string ] ;
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
           // MsgInfo(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
      
   AVCaptureMovieFileOutput *out = [[AVCaptureMovieFileOutput alloc] init];
    
   hb_retnl( ( HB_LONG ) out );
}

HB_FUNC( CAPTURESTART )
{
    
  AVCaptureSession * mCaptureSession = ( AVCaptureSession * ) hb_parnl( 1 );
  AVCaptureMovieFileOutput *out = ( AVCaptureMovieFileOutput * ) hb_parnl( 2 );
  NSString * string = hb_NSSTRING_par( 3 ) ;
    
    NSURL * destPath = [NSURL fileURLWithPath: string ] ;
    
  [mCaptureSession startRunning];
   
    RecordingDelegate* delegate = [[RecordingDelegate alloc] init];
    [out setDelegate: delegate ];
    
  [ out startRecordingToOutputFileURL:destPath recordingDelegate: delegate ] ;
    
  hb_retnl( ( HB_LONG ) out );
    
}

HB_FUNC( CAPTURESTOP )
{
 AVCaptureSession * mCaptureSession = ( AVCaptureSession * ) hb_parnl( 1 );
    

  AVCaptureFileOutput *out = ( AVCaptureFileOutput *) hb_parnl( 2 );
    
  [ out stopRecording ] ;
    
 
[mCaptureSession removeOutput:out];
[mCaptureSession stopRunning];

}

HB_FUNC( CAPTUREPAUSERESUME )
{
 AVCaptureFileOutput *out = ( AVCaptureFileOutput *) hb_parnl( 1 );
 
 if ( out.recordingPaused ) {
    [ out resumeRecording ];
    return hb_retl( ( BOOL ) YES  );
  }

  [ out pauseRecording];
   return hb_retl( ( BOOL ) NO  );

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

