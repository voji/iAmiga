//
//  MultiPeerConnectivityController.m
//  iUAE
//
//  Created by mithrendil on 24.02.2016.
//
//

#import "MultiPeerConnectivityController.h"
#import "MPCConnectionStates.h"

@implementation MultiPeerConnectivityController {
  
}

extern void set_MPCController(MultiPeerConnectivityController *m);
extern MPCStateType mainMenu_servermode;
extern unsigned int mainMenu_joy0dir;
extern int mainMenu_joy0button;
extern unsigned int mainMenu_joy1dir;
extern int mainMenu_joy1button;
static NSString * const XXServiceType = @"svc-iuae";
MCPeerID *localPeerID = nil;
MCSession *session = nil;
MCNearbyServiceBrowser *browser = nil;
MCBrowserViewController *browserViewController = nil;
MPCStateType lastServerMode=kConnectionIsOff;
bool bConnectionToServerJustEstablished = false;

- (void)configure: (MainEmulationViewController *) mainEmuViewCtrl {
    _mainEmuViewController = mainEmuViewCtrl;
    set_MPCController(self);


    if(mainMenu_servermode == kConnectionIsOff)
    {
        if(advertiser!=nil)
        {//stop server
            [self stopServer];
        }
        if(session != nil )
        {//close session connection
            [session disconnect];
            session = nil;
            [self showMessage: @"closed connection" withMessage: @"to the server"];
        }
        //the device should go to sleep after some idle time
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    else if(mainMenu_servermode == kServeAsHostForIncomingJoypadSignals)
    {
        if(lastServerMode == kSendJoypadSignalsToServerOnJoystickPort0 ||
           lastServerMode == kSendJoypadSignalsToServerOnJoystickPort1)
        {
            [session disconnect]; // close client session
            session = nil;
        }
        
        if(advertiser == nil)
        {
            [self startServer];
            
            //the device should NOT go to sleep after some idle time
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    }
    else if(
        mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0 ||
        mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1
       )
    {
        if(lastServerMode == kServeAsHostForIncomingJoypadSignals)
        {
            if(advertiser!=nil)
            {
                [self stopServer];
            }
        }
        
        if(session == nil|| session.connectedPeers.count == 0)
        {
            bConnectionToServerJustEstablished = true;
            [self startClient];
            
            //the device should go to sleep after some idle time
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        else
        {
            if(!bConnectionToServerJustEstablished)
            {
                if( mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0)
                    [self showMessage: @"use existing connection" withMessage: @"send to joystick port 0"];
                else if ( mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1)
                    [self showMessage: @"use existing connection" withMessage:  @"send to joystick port 1"];
            }
            bConnectionToServerJustEstablished = false;
            if(_mainEmuViewController.btnJoypad.selected == FALSE)
            {
                [_mainEmuViewController toggleControls:_mainEmuViewController.btnJoypad];
            }
        }
    }
    
    
    lastServerMode = mainMenu_servermode;
}



/*  CLIENT part */
- (void)startClient {
    if(localPeerID == nil)
    {
        localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    }
    session = [[MCSession alloc] initWithPeer:localPeerID
                             securityIdentity:nil
                         encryptionPreference:MCEncryptionNone];
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:XXServiceType];
    browser.delegate = self;
    browserViewController = [[MCBrowserViewController alloc] initWithBrowser:browser
                                                                     session:session];
    browserViewController.delegate = self;
    [_mainEmuViewController presentViewController:browserViewController
                       animated:YES
                     completion:
     ^{
         [browser startBrowsingForPeers];
     }];
}

- (void)browser:(MCNearbyServiceBrowser *)browser
      foundPeer:(MCPeerID *)peerID
withDiscoveryInfo:(NSDictionary<NSString *,
                   NSString *> *)info
{
    NSLog(@"found peer");
    if(![peerID isEqual:localPeerID])
        [browser invitePeer:peerID toSession:session withContext:nil timeout:30];
    
}
- (void)browser:(MCNearbyServiceBrowser *)browser
       lostPeer:(MCPeerID *)peerID
{}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [_mainEmuViewController  dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if( mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0)
            [self showMessage: @"new connection established" withMessage: @"send to joystick port 0"];
        else if ( mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1)
            [self showMessage: @"new connection established" withMessage:  @"send to joystick port 1"];
        
        if(_mainEmuViewController.btnJoypad.selected == FALSE)
        {
            [_mainEmuViewController toggleControls:_mainEmuViewController.btnJoypad];
        }
    });
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_mainEmuViewController dismissViewControllerAnimated:YES completion:nil];
    mainMenu_servermode=kConnectionIsOff; //disable client mode
}



// C "trampoline" function to invoke Objective-C method
void sendJoystickDataToServer (void *self)
{
    // Call the Objective-C method using Objective-C syntax
    [(id) self sendJoystickData];
}


unsigned int lastdir =0;
int lastbutton =0;
- (void)sendJoystickData
{
    if(session == nil || session.connectedPeers.count == 0)
    {
    }
    else if(mainMenu_joy1dir != lastdir || mainMenu_joy1button != lastbutton)
    {
        lastdir = mainMenu_joy1dir;
        lastbutton = mainMenu_joy1button;
        
        unsigned int iJoystickPort = 0;  // 0 or 1
        if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0)
            iJoystickPort=0;
        else if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1)
            iJoystickPort=1;
        
        
        unsigned int aints[3]= { iJoystickPort,  mainMenu_joy1dir, (unsigned int)mainMenu_joy1button};
        
        NSData *data = [NSData dataWithBytes: &aints length: sizeof(aints)];
        
        
        NSError *error = nil;
        if (![session sendData:data
                       toPeers:session.connectedPeers
                      withMode:MCSessionSendDataReliable
                         error:&error]) {
            NSLog(@"[Error] %@", error);
        }
    }
    
}


-(void)autoClickOnCancel:(UIAlertView*)theAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        [theAlert dismissWithClickedButtonIndex:-1 animated:YES];
    });
}

- (void)showMessage: (NSString *)sTitel withMessage:(NSString *)sMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: sTitel
                                                        message: sMessage
                                                       delegate:nil
                                              cancelButtonTitle:@""
                                              otherButtonTitles:nil];
        [alert show];
        
        [self performSelector:@selector(autoClickOnCancel:) withObject:alert afterDelay:2];
        [alert release];
        // NSLog(@"received: dir=%d, but=%d", mainMenu_joydir, mainMenu_joybutton);
    });
    
}




- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if(state == MCSessionStateConnected)
        [self showMessage: peerID.displayName withMessage: @"connected"];
    else if(state == MCSessionStateNotConnected)
        [self showMessage: peerID.displayName withMessage: @"not connected"];
    else if(state == MCSessionStateConnecting)
        [self showMessage: peerID.displayName withMessage: @"connecting..."];
    
}
/* server part */
MCNearbyServiceAdvertiser *advertiser=nil;


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    unsigned int aJoyData[3];
    [data getBytes: &aJoyData length: sizeof(aJoyData)];
    
    
    unsigned int iJoystickPort = aJoyData[0];  // 0 or 1
    if(iJoystickPort == 0)
    {
        mainMenu_joy0dir = aJoyData[1];
        mainMenu_joy0button =(int)aJoyData[2];
        
        //when joy0 signals come in
        //we have to activate joypad, otherwise the last mouse movements will overwrite/disturb
        //the remote joystick ddirection
        if(_mainEmuViewController.btnJoypad.selected == FALSE)
        {
            [_mainEmuViewController toggleControls:_mainEmuViewController.btnJoypad];
        }
    }
    else if(iJoystickPort == 1)
    {
        mainMenu_joy1dir = aJoyData[1];
        mainMenu_joy1button =(int)aJoyData[2];
    }
}


- (void) startServer {
    if(localPeerID == nil)
    {
        localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    }
    advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID
                                      discoveryInfo:nil
                                        serviceType:XXServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
    [self showMessage: @"server" withMessage: @"started on this device"];
}


- (void) stopServer {
    
    [advertiser stopAdvertisingPeer];
    [session disconnect];
    session = nil;
    advertiser = nil;
    [self showMessage: @"server" withMessage: @"stopped on this device"];
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    session = [[MCSession alloc] initWithPeer:localPeerID
                             securityIdentity:nil
                         encryptionPreference:MCEncryptionNone];
    session.delegate = self;
    
    invitationHandler(YES, session);
}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName
       fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
    /*
     stream.delegate = self;
     [stream scheduleInRunLoop:[NSRunLoop mainRunLoop]
     forMode:NSDefaultRunLoopMode];
     [stream open];
     */
}



// Start receiving a resource from remote peer.
- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress
{}

// Finished receiving a resource from remote peer and saved the content
// in a temporary location - the app is responsible for moving the file
// to a permanent location within its sandbox.
- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error
{}


@end
