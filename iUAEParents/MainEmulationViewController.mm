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
/*#import "EMUROMBrowserViewController.h"
#import "EmulationViewController.h"
#import "SelectEffectController.h"
#import "EMUFileInfo.h"*/
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"
#import "Settings.h"

@interface MainEmulationViewController()

//- (void)startIntroSequence;

@end

@implementation MainEmulationViewController {
    
    bool showalert;
    NSTimer *timer;
    bool firstappearance;
    Settings *settings;
}


UIButton *btnSettings;
IOSKeyboard *ioskeyboard;

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *fn = [NSString stringWithFormat:@"setVersion('%@');", self.bundleVersion];
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:fn];
}

- (CGFloat) screenHeight {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

- (CGFloat) screenWidth {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:TRUE];
    
    settings = [[Settings alloc] init];
    
    [self showpopupfirstlaunch];
    
    [_btnJoypad setImage: [_btnJoypad.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                    forState:UIControlStateNormal];
    [_btnJoypad setTintColor: [UIColor blackColor]];
    
    
    [_btnPin setImage: [_btnPin.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                forState:UIControlStateNormal];
    [_btnPin setTintColor: [UIColor blackColor]];
    
    timer=[[ NSTimer scheduledTimerWithTimeInterval:0.020 target:self
                                           selector:@selector(timerEvent:) userInfo:nil repeats:YES ] retain];
    
    firstappearance = true;
}

- (void)showpopupfirstlaunch {
    //Popup MFI Controller
    
    if([settings boolForKey:@"appvariableinitializied"])
    {
        showalert = FALSE;
    }
    else
    {
        showalert = TRUE;
    }

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    set_joystickactive();
    [settings initializeSettings];
    
    if(showalert)
    {
        showalert = FALSE;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MFI Game Controllers"
                                                        message:@"This version supports MFI Game Controllers. I have no Idea if it works, because I don't own one. Feedback very welcome at emufr3ak@icloud.com or on my website www.iuae-emulator.net"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}

-(void)initializeJoypad:(InputControllerView *)joyController {
    _joyController.hidden = TRUE;
    joyactive = FALSE;
}

- (CGFloat) XposFloatPanel:(int)barwidth {
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = screenRect.size.height;
    
    CGFloat result;
    
    if(self.screenWidth > self.screenHeight)
    {
        result = (self.screenWidth / 2) - (barwidth/2);
    }
    else
    {
        result = (self.screenHeight / 2) - (barwidth/2);
    }
        
    return result;
}

- (IBAction)toggleControls:(id)sender {
    
    bool keyboardactiveonstart = keyboardactive;
    
    UIButton *button = (UIButton *) sender;
    
    keyboardactive = (button == _btnKeyboard) ? !keyboardactive : FALSE;
    joyactive = (button == _btnJoypad) ? !joyactive : FALSE;
    
    _btnKeyboard.selected = (button == _btnKeyboard) ? !_btnKeyboard.selected : FALSE;
    _btnJoypad.selected = (button == _btnJoypad) ? !_btnJoypad.selected : FALSE;
    
    _btnJoypad.tintColor = _btnJoypad.selected ? [UIColor blueColor] : [UIColor blackColor];
    
    _joyController.hidden = !joyactive;
    _mouseHandler.hidden = joyactive;

    
    if (keyboardactive != keyboardactiveonstart) { [ioskeyboard toggleKeyboard]; }
    
    if (keyboardactive != keyboardactiveonstart && !keyboardactive) { set_joystickactive(); }
    
    if (button == btnSettings) { [self settings]; }
    
}

-(IBAction)togglePinstatus:(id)sender {
    
    _btnPin.selected = !_btnPin.selected;
    _btnPin.tintColor = _btnPin.selected ? [UIColor blueColor] : [UIColor blackColor];
    _mouseHandler.clickedscreen = false;
    _joyController.clickedscreen = false;
}

- (void) initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:(UITextField *)p_dummy_textfield_f dummytexts:(UITextField *)p_dummy_textfield_s {
    
    keyboardactive = FALSE;
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:p_dummy_textfield fieldf:p_dummy_textfield_f fieldspecial:p_dummy_textfield_s];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardDidHide:)
                                                   name:UIKeyboardDidHideNotification
                                                 object:nil];
}

-(IBAction)enableMenuBar:(id)sender {
    _menuBar.hidden = false;
    _menuBarEnabler.hidden = true;
    _mouseHandler.clickedscreen = false;
    _joyController.clickedscreen = false;
    timer=[[ NSTimer scheduledTimerWithTimeInterval:0.020 target:self
                                           selector:@selector(timerEvent:) userInfo:nil repeats:YES ] retain];
}

-(void)timerEvent:(NSTimer*)timer{
    if((_mouseHandler || _joyController) && !_btnPin.selected && _menuBar.hidden == false)
    {
        if(_mouseHandler.clickedscreen || _joyController.clickedscreen)
        {
            _mouseHandler.clickedscreen = false;
            _joyController.clickedscreen = false;
            _menuBar.hidden = true;
            _menuBarEnabler.hidden = false;
            [timer invalidate];
        }
    }
}

- (void)dealloc
{
    [_btnKeyboard release];
    [_menuBar release];
    [_btnJoypad release];
    [_btnPin release];
    [_mouseHandler release];
    [_menuBarEnabler release];
    [Settings release];
    
    [super dealloc];
}

@end
