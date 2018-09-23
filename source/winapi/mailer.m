#import <CoreServices/CoreServices.h>
#import <ScriptingBridge/SBApplication.h>
#import "Mail.h"
#include <fivemac.h>


@interface Mailer: NSObject <SBApplicationDelegate>//<NSSharingServiceDelegate>
{
    NSMutableArray *afilesAttachment;
}

@property(retain, readwrite) NSString * toField;
@property(retain, readwrite) NSString *fromField;
@property(retain, readwrite) NSString *subjectField;
@property(retain, readwrite) NSString *fileAttachmentField;
@property(retain, readwrite) NSString *messageContent;

- (IBAction)sendEmailMessage:(id)sender;

@end

@implementation Mailer

@synthesize toField, fromField, subjectField, messageContent, fileAttachmentField ;

- (void)inicial
{
	//Allocate some space for the data source
    afilesAttachment = [NSMutableArray new];
  //--- old---	afilesAttachment = [[NSMutableArray alloc] initWithObjects:nil];
      
}

- (void)addAttach : (NSString *)attach
{
 [ afilesAttachment addObject: attach ] ;    
}



//- (void)awakeFromNib {
   
//    [self.messageContent setFont:[NSFont fontWithName:@"Courier" size:12]];
    
//}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


- (id)eventDidFail:(const AppleEvent *)event withError:(NSError *)error
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    alert.messageText = @"Error" ;
    alert.informativeText = [error localizedDescription] ;
    alert.alertStyle = NSAlertStyleWarning ;
    
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    
    return nil;
}



- (IBAction)sendEmailMessage:(id)sender {
    
     int i, n;
  
   
 /*
    
    NSSharingService *service = [NSSharingService sharingServiceNamed:NSSharingServiceNameComposeEmail];
    service.delegate = self;
    
    NSArray* shareRecipients = @[ [self toField ] ];
    
    [service setRecipients: shareRecipients  ];
    [service setSubject:[ self subjectField ]];
    
     NSString* textAttributedString = [self messageContent ] ;
//    NSAttributedString* textAttributedString = [self messageContent ] ;
    NSURL* tempFileURL ;
    
    NSString *attachmentFilePath ;
    
    n = [ afilesAttachment count ] ;
    
    NSMutableArray *shareItems = [[NSMutableArray alloc] init];
    
   [ shareItems addObject : textAttributedString ] ;
    
    for(i=0; i<n; i++)
    {
        
        attachmentFilePath = [afilesAttachment objectAtIndex:i ]  ;
        
        //  NSRunAlertPanel( attachmentFilePath ,@"yo", @"view",  attachmentFilePath, NULL );
        
        //  NSLog( @"%@", attachmentFilePath  );
        
        if ( [attachmentFilePath length] > 0 ) {
            
            tempFileURL = [NSURL fileURLWithPath: attachmentFilePath ];
            
            [ shareItems addObject : tempFileURL ] ;
        }
        
    }
    
  //  NSArray* shareItems = @[textAttributedString,tempFileURL];
    
    [service performWithItems:shareItems];
  
  */
    

    
  
    
    /* create a Scripting Bridge object for talking to the Mail application */
    MailApplication *mail = [SBApplication applicationWithBundleIdentifier:@"com.apple.Mail"];
    
    /* set ourself as the delegate to receive any errors */
    mail.delegate = self;
    
    /* create a new outgoing message object */
    MailOutgoingMessage *emailMessage = [[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [ self subjectField ] , @"subject",
                                          [self messageContent ], @"content",
                                          nil]];
    
    /* add the object to the mail app  */
    
    //  NSLog( @"%@", [self subjectField ]  );
    
    
    [[mail outgoingMessages] addObject: emailMessage];
    
    /* set the sender, show the message */
   emailMessage.sender = [self fromField ];
  emailMessage.visible = YES;
    
    /* Test for errors */
    if ( [mail lastError] != nil )
        return;
    
    /* create a new recipient and add it to the recipients list */
    MailToRecipient *theRecipient = [[[mail classForScriptingClass:@"to recipient"] alloc] initWithProperties:
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                      [self toField ], @"address",
                                      nil]];
    [emailMessage.toRecipients addObject: theRecipient];
    [theRecipient release];
    
    
    /* Test for errors */
    if ( [mail lastError] != nil )
        return;
    
    /* add an attachment, if one was specified */
    
    MailAttachment *theAttachment ;
    
    NSString *attachmentFilePath ;
    
    n = [ afilesAttachment count ] ;
    
    for(i=0; i<n; i++)
    {
        
         
        attachmentFilePath = [afilesAttachment objectAtIndex:i ]  ;
        
       // NSRunAlertPanel( attachmentFilePath ,@"yo", @"view",  attachmentFilePath, NULL );
        
      //  NSLog( @"%@", attachmentFilePath  );
        
        if ( [attachmentFilePath length] > 0 ) {
            
            /* create an attachment object */
            theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc]
                                             initWithProperties: @{@"fileName": [NSURL URLWithString:attachmentFilePath]}];
            
           
         //   theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:
         //                    [NSDictionary dictionaryWithObjectsAndKeys:
         //                     [NSURL URLWithString:attachmentFilePath], @"fileName",
         //                     nil]];
            
            // add it to the list of attachments
            [[emailMessage.content attachments] addObject: theAttachment];
            
         //   [[emailMessage.content paragraphs] addObject: theAttachment];
            
            [theAttachment release];
            
          
            
            /* Test for errors */
            if ( [mail lastError] != nil )
                return;
        }
       
  
    }
  
    
    
    
 /*  NSString *attachmentFilePath = [self fileAttachmentField ];
       

    if ( [attachmentFilePath length] > 0 ) {
            
       theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc]
                                         initWithProperties:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          attachmentFilePath, @"fileName",
                                          nil]];        
        
      
        [ [ emailMessage.content  attachments] addObject: theAttachment];
        
        [theAttachment release];
        
        
        if ( [mail lastError] != nil )
            return;
   }
  
  */
    
    /* send the message */
    
  
    
    
  
 //   [emailMessage send];
    
    
 //   [emailMessage release];
}

@end


HB_FUNC( MAILCREATE )
{
   Mailer * mimailer =  [[ Mailer alloc ] init ] ;
   [mimailer inicial ] ; 
   hb_retnl( ( HB_LONG ) mimailer );
}


HB_FUNC( MAILSETTO )
{
   Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
   NSString * setTo = hb_NSSTRING_par( 2 ); 
   [ mimailer setToField  : setTo ] ;  
}

HB_FUNC( MAILSETSUBJECT )
{
  Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
  NSString * subj = hb_NSSTRING_par( 2 ); 
  [ mimailer setSubjectField  : subj ] ;   
}

HB_FUNC( MAILSETMSG )
{
    Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
    NSString * msg = hb_NSSTRING_par( 2 ); 
    [ mimailer setMessageContent  : msg ] ;  
}

HB_FUNC( MAILSETFROM )
{
    Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
    NSString * from = hb_NSSTRING_par( 2 ); 
   [ mimailer setFromField  : from ] ; 
}

HB_FUNC( MAILADDATTACH )
{
    Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
    NSString * attach = hb_NSSTRING_par( 2 ); 
    [ mimailer addAttach : attach ] ; 
 }

HB_FUNC( MAILSEND )
{
   Mailer * mimailer =  ( Mailer *) hb_parnl( 1 );    
   [ mimailer sendEmailMessage :mimailer ] ;
}



