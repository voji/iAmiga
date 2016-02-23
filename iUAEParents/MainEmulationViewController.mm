//
//  DOTCEmulationViewController.m
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//
//  Changed by Emufr3ak on 29.05.14.
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Software Foundation, either version 2 of the
//  License, or (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  General Public License for more details.
//
// You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "MainEmulationViewController.h"
#import "VirtualKeyboard.h"
#import "IOSKeyboard.h"
#import "uae.h"
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"
#import "Settings.h"
#import "SettingsGeneralController.h"
#import "DiskDriveService.h"
#import <GameController/GameController.h>

extern SDL_Joystick *uae4all_joy0, *uae4all_joy1;
extern void init_joystick();

@interface MainEmulationViewController()
@end

@implementation MainEmulationViewController {
    DiskDriveService *_diskDriveService;
    NSTimer *_menuHidingTimer;
    Settings *_settings;
    NSTimer *_checkForPausedTimer;
    NSTimer *_checkForGControllerTimer;
}


UIButton *btnSettings;
IOSKeyboard *ioskeyboard;

extern void uae_reset();

- (IBAction)restart:(id)sender {
    uae_reset();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *fn = [NSString stringWithFormat:@"setVersion('%@');", self.bundleVersion];
    [webView stringByEvaluatingJavaScriptFromString:fn];
}

- (CGFloat)screenHeight {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

- (CGFloat)screenWidth {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _diskDriveService = [[DiskDriveService alloc] init];
    _settings = [[Settings alloc] init];
    
    [self.view setMultipleTouchEnabled:TRUE];
    
    [_btnJoypad setImage:[UIImage imageNamed:@"controller_selected.png"] forState:UIControlStateSelected];
    [_btnSettings setImage:[UIImage imageNamed:@"gear_selected.png"] forState: UIControlStateHighlighted];
    [_btnKeyboard setImage:[UIImage imageNamed:@"keyboard_selected.png"] forState:UIControlStateHighlighted];
    [_btnPin setImage:[UIImage imageNamed:@"sticky_selected.png"] forState:UIControlStateSelected];
    //[_btnJoypad setImage: [_btnJoypad.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    //forState:UIControlStateNormal];
    //[_btnJoypad setTintColor: [UIColor blackColor]];
    
    
    /*[_btnPin setImage: [_btnPin.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                forState:UIControlStateNormal];
    [_btnPin setTintColor: [UIColor blackColor]];*/
    
    [self initMenuBarHidingTimer];
    [self initCheckForPausedTimer];
    
    if (_settings.autoloadConfig)
    {
        // enabling things here uses timers because the disk subsystem of the emulator isn't initialized yet right here - we need to delay disk drive related tasks by a little bit
        [self initDriveSetupTimer:_settings.driveState];
        [self initDiskInsertTimer:_settings.insertedFloppies];
    }
    
    [self initializeControls];
    paused = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerStateChange)
                                                 name:GCControllerDidConnectNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerStateChange)
                                                 name:GCControllerDidDisconnectNotification
                                               object:nil];
    
    // we start out with the mouse activated
    [_mouseHandler onMouseActivated];

}

extern void set_MainView(MainEmulationViewController *m);
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self applyConfiguredEffect];
    set_joystickactive();
    set_MainView(self);
    
    [_mouseHandler reloadMouseSettings];
    [_joyController reloadJoypadSettings];
    
    
    if(mainMenu_servermode != 1)
    {
        if(advertiser!=nil)
        {//stop server
            [self stopServer];
        }
        else if(session != nil && mainMenu_servermode == 0)
        {//close client connection
            [session disconnect];
            session = nil;
            [self showMessage: @"closed connection" withMessage: @"to the server"];
            
        }
        //the device should go to sleep after some idle time
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    
    if(mainMenu_servermode == 1)
    {
        if(localPeerID==nil || session == nil)
        {
            [self startServer];
            
            //the device should NOT go to sleep after some idle time
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    }
    
    if(mainMenu_servermode > 1 )
    {
        if(localPeerID==nil || session == nil|| session.connectedPeers.count == 0)
        {
            [self startClient];
        }
        else
        {
            if( mainMenu_servermode == 2)
                [self showMessage: @"use existing connection" withMessage: @"send to joystick port 0"];
            else if ( mainMenu_servermode == 3)
                [self showMessage: @"use existing connection" withMessage:  @"send to joystick port 1"];
            
            if(_btnJoypad.selected == FALSE)
            {
                [self toggleControls:_btnJoypad];
            }
        }
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    UITabBarController *tabBarController = segue.destinationViewController;
    SettingsGeneralController *settingsController = [tabBarController.viewControllers objectAtIndex:0];
    settingsController.resetDelegate = self;
}

- (void)didSelectReset:(DriveState *)driveState {
    uae_reset();
    _settings.driveState = driveState;
    [self initDriveSetupTimer:driveState];
}

- (void)applyConfiguredEffect {
    SDL_Surface *video = SDL_GetVideoSurface();
    id<DisplayViewSurface> display = (id<DisplayViewSurface>)video->userdata;
    display.displayEffect = (DisplayEffect)_settings.selectedEffectIndex;
}

- (void)initializeJoypad:(InputControllerView *)joyController {
    /* Check if function is still needed */
    _joyController.hidden = TRUE;
    joyactive = FALSE;
}

- (void)initializeControls {
    joyactive = FALSE;
    _mouseHandler.hidden = FALSE;
    _joyController.hidden = TRUE;
}

extern  void mousehack_setdontcare_iuae ();
extern  void mousehack_setfollow_iuae ();
extern void togglemouse (void);
- (IBAction)toggleControls:(UIButton *)button {
    
    bool keyboardactiveonstart = keyboardactive;
    
    keyboardactive = (button == _btnKeyboard) ? !keyboardactive : FALSE;
    joyactive = (button == _btnJoypad) ? !joyactive : FALSE;
    
    _btnKeyboard.selected = (button == _btnKeyboard) ? !_btnKeyboard.selected : FALSE;
    _btnJoypad.selected = (button == _btnJoypad) ? !_btnJoypad.selected : FALSE;
    
    //_btnJoypad.tintColor = _btnJoypad.selected ? [UIColor blueColor] : [UIColor blackColor];
    
    _joyController.hidden = !joyactive;
    _mouseHandler.hidden = joyactive;

    if (joyactive)
    {
        [_joyController onJoypadActivated];
         mousehack_setdontcare_iuae();
    }
    else
    {
        [_mouseHandler onMouseActivated];
         mousehack_setfollow_iuae();
    }
    
    if (keyboardactive != keyboardactiveonstart)
    {
        [ioskeyboard toggleKeyboard];
    }    
}

- (IBAction)togglePinstatus:(id)sender {
    
    _btnPin.selected = !_btnPin.selected;
    //_btnPin.tintColor = _btnPin.selected ? [UIColor blueColor] : [UIColor blackColor];
    
    _mouseHandler.clickedscreen = false;
    _joyController.clickedscreen = false;
}

- (void)initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:(UITextField *)p_dummy_textfield_f dummytexts:(UITextField *)p_dummy_textfield_s {
    
    keyboardactive = FALSE;
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:p_dummy_textfield fieldf:p_dummy_textfield_f fieldspecial:p_dummy_textfield_s];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(IBAction)enableMenuBar:(id)sender {
    _menuBar.hidden = false;
    _menuBarEnabler.hidden = true;
    _mouseHandler.clickedscreen = false;
    _joyController.clickedscreen = false;
    [self initMenuBarHidingTimer];
}

-(void)checkForMenuBarHiding:(NSTimer*)timer {
    if((_mouseHandler || _joyController) && !_btnPin.selected && _menuBar.hidden == false)
    {
        if(_mouseHandler.clickedscreen || _joyController.clickedscreen)
        {
            _mouseHandler.clickedscreen = false;
            _joyController.clickedscreen = false;
            _menuBar.hidden = true;
            _menuBarEnabler.hidden = false;

            [_menuHidingTimer invalidate];
            [_menuHidingTimer release];
            _menuHidingTimer = nil;
        }
    }
}

-(void)checkForPaused:(NSTimer *)timer {
    
    //As emulator is paused this methods needs to be called to check for Joypad as it wont get called by the emulator
    if(paused) SDL_JoystickUpdate();
    
    int pausednew;
    pausednew = SDL_JoystickGetPaused(uae4all_joy0);
    
    if(pausednew != paused )
    {
        paused = pausednew;
        
        if(paused == 1)
        {
            [self pauseEmulator];
        }
        else
        {
            [self resumeEmulator];
        }
    }
}

-(void)controllerStateChange {
    init_joystick();
}

- (void)initDriveSetupTimer:(DriveState *)driveState {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupDrives:) userInfo:driveState repeats:NO];
}

- (void)initDiskInsertTimer:(NSArray *)insertedFloppies {
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(insertConfiguredDisks:) userInfo:insertedFloppies repeats:NO];
}

- (void)initMenuBarHidingTimer {
    if (_menuHidingTimer) {
        [_menuHidingTimer release];
    }
    _menuHidingTimer = [[NSTimer scheduledTimerWithTimeInterval:0.020 target:self
                                                       selector:@selector(checkForMenuBarHiding:) userInfo:nil repeats:YES] retain];
    _menuHidingTimer.tolerance = 0.0020;
}

- (void)initCheckForPausedTimer {
    if (_checkForPausedTimer) {
        [_checkForPausedTimer release];
    }
    
    _checkForPausedTimer = [[NSTimer scheduledTimerWithTimeInterval:0.020 target:self
                                                           selector:@selector(checkForPaused:) userInfo:nil repeats:YES] retain];
    
    _checkForPausedTimer.tolerance = 0.0020;
    
}

- (void)insertConfiguredDisks:(NSTimer *)timer {
    NSArray *insertedFloppies = timer.userInfo;
    if ([insertedFloppies count] > 0)
    {
        [_diskDriveService insertDisks:insertedFloppies];
        [_settings setFloppyConfigurations:insertedFloppies];
    }
}

- (void)setupDrives:(NSTimer *)timer {
    DriveState *driveState = timer.userInfo;
    [_diskDriveService setDriveState:driveState];
}

- (void)dealloc
{
    [_btnJoypad release];
    [_btnKeyboard release];
    [_btnPin release];
    [_diskDriveService release];
    [_mouseHandler release];
    [_menuBar release];
    [_menuBarEnabler release];
    [_menuHidingTimer invalidate];
    [_menuHidingTimer release];
    [_settings release];
    [super dealloc];
}

/******* START MCSESSION mithrendal ****/
extern int mainMenu_servermode;
extern unsigned int mainMenu_joy0dir;
extern int mainMenu_joy0button;
extern unsigned int mainMenu_joy1dir;
extern int mainMenu_joy1button;
static NSString * const XXServiceType = @"svc-iuae";
MCPeerID *localPeerID = nil;
MCSession *session = nil;
MCNearbyServiceBrowser *browser = nil;
MCBrowserViewController *browserViewController = nil;
/*  CLIENT teil */
- (void)startClient {
    localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    session = [[MCSession alloc] initWithPeer:localPeerID
                             securityIdentity:nil
                         encryptionPreference:MCEncryptionNone];
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:XXServiceType];
    browser.delegate = self;
    browserViewController = [[MCBrowserViewController alloc] initWithBrowser:browser
                                                                     session:session];
    browserViewController.delegate = self;
    [self presentViewController:browserViewController
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
    [browser invitePeer:peerID toSession:session withContext:nil timeout:30];
    
}
- (void)browser:(MCNearbyServiceBrowser *)browser
       lostPeer:(MCPeerID *)peerID
{}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if( mainMenu_servermode == 2)
            [self showMessage: @"connection established" withMessage: @"send to joystick port 0"];
        else if ( mainMenu_servermode == 3)
            [self showMessage: @"connection established" withMessage:  @"send to joystick port 1"];
    
        if(_btnJoypad.selected == FALSE)
        {
            [self toggleControls:_btnJoypad];
        }
    });
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    mainMenu_servermode=0; //disable client mode
}



// C "trampoline" function to invoke Objective-C method
void sendJoystickDataToServer (void *self, unsigned int aParameter)
{
    // Call the Objective-C method using Objective-C syntax
    [(id) self sendJoystickData:aParameter ];
}


unsigned int lastdir =0;
int lastbutton =0;
- (void)sendJoystickData: (unsigned int) joystickregister
{
    if(session == nil || session.connectedPeers.count == 0)
    {
    }
    else if(mainMenu_joy1dir != lastdir || mainMenu_joy1button != lastbutton)
    {
        lastdir = mainMenu_joy1dir;
        lastbutton = mainMenu_joy1button;
        
        unsigned int iJoystickPort = mainMenu_servermode-2;  // 0 or 1
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
/* server teil */
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
        if(_btnJoypad.selected == FALSE)
        {
            [self toggleControls:_btnJoypad];
        }
    }
    else if(iJoystickPort == 1)
    {
        mainMenu_joy1dir = aJoyData[1];
        mainMenu_joy1button =(int)aJoyData[2];
    }
}


- (void) startServer {
    localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    MCNearbyServiceAdvertiser *advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:localPeerID
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


/*** ENDE MCSession mithrendal */




@end
