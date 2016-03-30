 //
//  MultiPeerConnectivityController.m
//  iUAE
//
//  Created by mithrendil on 24.02.2016.
//
//

#import "MultiPeerConnectivityController.h"
#import "MPCConnectionStates.h"
#import "SVProgressHUD.h"
#import "JoypadKey.h"

static MultiPeerConnectivityController *_instance;
extern CJoyStick g_touchStick;

@implementation MultiPeerConnectivityController {
    Settings *_settings;
    double _lasttime;
}

extern MPCStateType mainMenu_servermode;
extern unsigned int mainMenu_joy0dir;
extern int mainMenu_joy0button;
extern unsigned int mainMenu_joy1dir;
extern int mainMenu_joy1button;
static NSString * const XXServiceType = @"svc-iuae";
CJoyStick *theJoystick = &g_touchStick;
MCPeerID *localPeerID = nil;
MCSession *session = nil;
MCNearbyServiceBrowser *browser = nil;
MCBrowserViewController *browserViewController = nil;
MPCStateType lastServerMode=kConnectionIsOff;
bool bConnectionToServerJustEstablished = false;

+ (MultiPeerConnectivityController *)getinstance
{
    return _instance;
}

- (id) init
{
    [super init];
    
    _instance = self;
    
    return self;
}

- (void)configure: (MainEmulationViewController *) mainEmuViewCtrl {
    
    _mainEmuViewController = mainEmuViewCtrl;
    _instance = self;
    _settings = [[Settings alloc] init];
    
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
            [self activateJoyPad];
        }
    }
    
    
    lastServerMode = mainMenu_servermode;
}

- (void)activateJoyPad {
    if(_mainEmuViewController.btnJoypad.selected == FALSE)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainEmuViewController toggleControls:_mainEmuViewController.btnJoypad];

        });
    }
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
        
         [self activateJoyPad];
    });
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_mainEmuViewController dismissViewControllerAnimated:YES completion:nil];
    mainMenu_servermode=kConnectionIsOff; //disable client mode
}

- (void)sendJoystickDataForDirection:(int)direction buttontoreleasehorizontal:(int)buttontoreleasehorizontal buttontoreleasevertical:(int)buttontoreleasevertical
{
    if(session == nil || session.connectedPeers.count == 0)
    {
    }
    else
    {
        unsigned int iJoystickPort = 0;  // 0 or 1
        if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0)
            iJoystickPort=0;
        else if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1)
            iJoystickPort=1;
        
        
        int aints[6]= { (unsigned int) iJoystickPort,  (unsigned int)direction, (unsigned int)0, BTN_INVALID, buttontoreleasehorizontal, buttontoreleasevertical};
        
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
- (void)sendJoystickDataForButtonID:(int)buttonid buttonstate:(int)buttonstate {
 
    if(session == nil || session.connectedPeers.count == 0)
    {
        
    }
    else
    {
        unsigned int iJoystickPort = 0;  // 0 or 1
        if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort0)
            iJoystickPort=0;
        else if(mainMenu_servermode == kSendJoypadSignalsToServerOnJoystickPort1)
            iJoystickPort=1;
        
        
        int aints[6]= { (unsigned int)iJoystickPort,  (unsigned int) 0, (unsigned int)buttonstate, (unsigned int) buttonid, (unsigned int) 0, (unsigned int) 0};
        
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
- (void)showMessage: (NSString *)sTitel withMessage:(NSString *)sMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setInfoImage:nil];
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@\n\n%@", sTitel, sMessage]];
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
    
    unsigned int aJoyData[6];
    [data getBytes: &aJoyData length: sizeof(aJoyData)];
    
    //Attenttion!! Code Ignores Port at the Moment and always uses port 1
    int iJoystickPort = (int) aJoyData[0];  // 0 or 1
    TouchStickDPadState joydir = (TouchStickDPadState)aJoyData[1];
    int joybtnstat = (int) aJoyData[2];
    int joybtn = (int) aJoyData[3];
    int btntoreleasehor = (int) aJoyData[4];
    int btntoreleasever = (int) aJoyData[5];
    
    if(joybtn != BTN_INVALID)
    {

        if(CACurrentMediaTime() - _lasttime < (double) 0.02)
        {
            dispatch_time_t waittime = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
            
            dispatch_after(waittime, dispatch_get_main_queue(),
            ^void{
                [self sendinputbuttons:joybtn buttonstate:joybtnstat port:iJoystickPort];
            });
        }
        else
        {
             [self sendinputbuttons:joybtn buttonstate:joybtnstat port:iJoystickPort];
        }
        
        _lasttime = CACurrentMediaTime();
    }
    else
    {
        [self sendinputdirections:joydir buttontoreleasevertical:btntoreleasever buttontoreleasehorizontal:btntoreleasehor port:iJoystickPort];
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

- (void)sendinputdirections:(TouchStickDPadState)hat_state buttontoreleasevertical:(int)buttontoreleasevertical buttontoreleasehorizontal: (int)buttontoreleasehorizontal
{
    [self sendinputdirections:hat_state buttontoreleasevertical:buttontoreleasevertical buttontoreleasehorizontal:buttontoreleasehorizontal port:1];
}


- (int)sendinputbuttons:(int)buttonid buttonstate:(int)buttonstate
{
    int returnvalue = [self sendinputbuttons:buttonid buttonstate:buttonstate port:1];
    return returnvalue;
}


- (int)sendinputbuttons:(int)buttonid buttonstate:(int)buttonstate port:(int)port {
    
    buttonstate = !buttonstate;
    
    NSString *configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", buttonid]];
    
    if([configuredkey  isEqual: @"Joypad"])
    {
        if(buttonstate) {
            if(port == 0) theJoystick->setButtonOneStateP0(FireButtonDown);
            else theJoystick->setButtonOneStateP1(FireButtonDown);
        }
        else {
            if(port == 0) theJoystick->setButtonOneStateP0(FireButtonUp);
             else theJoystick->setButtonOneStateP1(FireButtonUp);
        }
    }
    else
    {
        int asciicode = [[configuredkey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
        
        if(buttonstate)
        {
            SDL_Event ed = { SDL_KEYDOWN };
            ed.key.keysym.sym = (SDLKey) asciicode;
            SDL_PushEvent(&ed);
        }
        else
        {
            SDL_Event eu = { SDL_KEYUP };
            eu.key.keysym.sym = (SDLKey) asciicode;
            SDL_PushEvent(&eu);
        }
    }
    
    return buttonstate;
    
}

- (void)sendinputdirections:(TouchStickDPadState)hat_state buttontoreleasevertical:(int)buttontoreleasevertical buttontoreleasehorizontal: (int)buttontoreleasehorizontal port:(int)port
{
    
    NSString *configuredkeyhorizontal = NULL;
    NSString *configuredkeyvertical = NULL;
    int asciicodehorizontal = NULL;
    int asciicodevertical = NULL;
    NSString *configuredkeytoreleasehorizontal = NULL;
    int asciicodekeytoreleasehorizontal = NULL;
    NSString *configuredkeytoreleasevertical = NULL;
    int asciicodekeytoreleasevertical = NULL;
    
    if([self dpadstatetojoypadkey: @"horizontal" hatstate:hat_state])
    {
        
        configuredkeyhorizontal = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: @"horizontal" hatstate:hat_state]]];
        asciicodehorizontal = [[configuredkeyhorizontal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if([self dpadstatetojoypadkey: @"vertical" hatstate:hat_state])
    {
        configuredkeyvertical = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: @"vertical" hatstate:hat_state]]];
        asciicodevertical = [[configuredkeyvertical stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if(buttontoreleasehorizontal)
    {
        configuredkeytoreleasehorizontal = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", buttontoreleasehorizontal]];
        asciicodekeytoreleasehorizontal = [[configuredkeytoreleasehorizontal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if(buttontoreleasevertical)
    {
        configuredkeytoreleasevertical = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", buttontoreleasevertical]];
        asciicodekeytoreleasevertical = [[configuredkeytoreleasevertical stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if(asciicodekeytoreleasehorizontal)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) asciicodekeytoreleasehorizontal;
        SDL_PushEvent(&ed);
    }
    
    if(asciicodekeytoreleasevertical)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) asciicodekeytoreleasevertical;
        SDL_PushEvent(&ed);
    }
    
    if(hat_state == DPadCenter)
    {
        if(port == 0) theJoystick->setDPadStateP0(hat_state);
        else theJoystick->setDPadStateP1(hat_state);
        return;
    }
    
    if([configuredkeyhorizontal  isEqual: @"Joypad"] && [configuredkeyvertical isEqual:@"joypad"])
    {
        if(port == 0) theJoystick->setDPadStateP0(hat_state);
        else theJoystick->setDPadStateP1(hat_state);
        return;
    }
    
    if([configuredkeyhorizontal isEqual: @"Joypad"])
    {
        if(port == 0) theJoystick->setDPadStateP0(hat_state);
        else theJoystick->setDPadStateP1(hat_state);
    }
    else if(configuredkeyhorizontal)
    {
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodehorizontal;
        SDL_PushEvent(&ed);
    }
    
    
    if([configuredkeyvertical isEqual: @"Joypad"])
    {
        if(port == 0) theJoystick->setDPadStateP0(hat_state);
        else theJoystick->setDPadStateP1(hat_state);
    }
    else if (configuredkeyvertical)
    {
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodevertical;
        SDL_PushEvent(&ed);
    }
}


- (int) dpadstatetojoypadkey:(NSString *)direction hatstate:(TouchStickDPadState)hat_state
{
    if(hat_state == DPadUp)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return NULL;
    }
    else if(hat_state == DPadUpLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return BTN_LEFT;
    }
    else if(hat_state == DPadUpRight)
    {
        if([direction isEqual:@"horizontal"])
            return BTN_UP;
        else
            return BTN_RIGHT;
    }
    else if(hat_state == DPadDown)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return NULL;
    }
    else if (hat_state == DPadDownLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_LEFT;
    }
    else if (hat_state == DPadDownRight)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_RIGHT;
    }
    else if (hat_state == DPadLeft)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_LEFT;
    }
    else if (hat_state == DPadRight)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_RIGHT;
    }
    return NULL;
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
