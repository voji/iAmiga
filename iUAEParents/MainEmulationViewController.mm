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

@interface MainEmulationViewController()

//- (void)startIntroSequence;

@end

@implementation MainEmulationViewController {
    
    bool showalert;

}

@synthesize joyControllerMain;


UIButton *btnSettings;
IOSKeyboard *ioskeyboard;

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

-(void) settings {
    
    NSString *xibfile = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"SettingsController-ipad" : @"SettingsController";
    
    SettingsController *viewController = [[SettingsController alloc] initWithNibName:xibfile bundle:nil];
    
    viewController.view.frame = CGRectMake(0, 0, self.screenHeight, self.screenWidth);
    [self.navigationController pushViewController:viewController animated:YES];
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
    [self showpopupfirstlaunch];
}

- (void)showpopupfirstlaunch {
    //Popup MFI Controller
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    [filemgr changeCurrentDirectoryPath:docsDir];
    
    if ([filemgr fileExistsAtPath: @"firstlaunch.txt" ] == YES)
    {
        showalert = FALSE;
    }
    else
    {
        showalert = TRUE;
        
        NSMutableData *data;
        const char *bytestring = "1.0.7";
        
        data = [NSMutableData dataWithBytes:bytestring length:strlen(bytestring)];
        bool success = [filemgr createFileAtPath:@"./firstlaunch.txt" contents:data attributes:nil];
        
        [filemgr release];
    }

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    set_joystickactive();
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

- (void)initializeFullScreenPanel:(int)barwidth barheight:(int)barheight iconwidth:(int)iconwidth iconheight:(int)iconheight  {
    
    int xpos = [self XposFloatPanel:barwidth];
    
    fullscreenPanel = [[FloatPanel alloc] initWithFrame:CGRectMake(xpos,20,barwidth,barheight)];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:16];
    
    btnSettings = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [btnSettings setImage:[UIImage imageNamed:@"options.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnSettings];
    
    _btnKeyboard = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [_btnKeyboard setImage:[UIImage imageNamed:@"modekeyoff.png"] forState:UIControlStateNormal];
    [_btnKeyboard setImage:[UIImage imageNamed:@"modekeyon.png"] forState:UIControlStateSelected];
    [_btnKeyboard addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:_btnKeyboard];
    
    btnJoypad = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,iconwidth,iconheight)] autorelease];
    [btnJoypad setImage:[UIImage imageNamed:@"modejoy.png"] forState:UIControlStateNormal];
    [btnJoypad setImage:[UIImage imageNamed:@"modejoypressed.png"] forState:UIControlStateSelected];
    [btnJoypad addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnJoypad];
    
    [fullscreenPanel setItems:items];
    
    [self.view addSubview:fullscreenPanel];
    [fullscreenPanel showContent];
}

-(void)initializeJoypad:(InputControllerView *)joyController {
    joyControllerMain = joyController;
    self.joyControllerMain.hidden = TRUE;
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
    joyactive = (button == btnJoypad) ? !joyactive : FALSE;
    
    _btnKeyboard.selected = (button == _btnKeyboard) ? !_btnKeyboard.selected : FALSE;
    btnJoypad.selected = (button == btnJoypad) ? !btnJoypad.selected : FALSE;
    
    joyControllerMain.hidden = !joyactive;
    mouseHandlermain.hidden = joyactive;
    
    if (keyboardactive != keyboardactiveonstart) { [ioskeyboard toggleKeyboard]; }
    
    if (keyboardactive != keyboardactiveonstart && !keyboardactive) { set_joystickactive(); }
    
    if (button == btnSettings) { [self settings]; }
    
}

- (void) initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:(UITextField *)p_dummy_textfield_f dummytexts:(UITextField *)p_dummy_textfield_s {
    
    keyboardactive = FALSE;
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:p_dummy_textfield fieldf:p_dummy_textfield_f fieldspecial:p_dummy_textfield_s];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardDidHide:)
                                                   name:UIKeyboardDidHideNotification
                                                 object:nil];
}

- (void)dealloc
{
    [_btnKeyboard release];
    [btnJoypad release];
}

@end
