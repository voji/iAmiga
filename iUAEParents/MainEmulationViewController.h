//
//  DOTCEmulationViewController.h
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "BaseEmulationViewController.h"
#import "AnimatedImageSequenceView.h"
#import "SettingsController.h"
#import "FloatPanel.h"
#import "DynamicLandscapeControls.h"
#import "TouchHandlerViewClassic.h"
#import "InputControllerView.h"

@class VirtualKeyboard;

@interface MainEmulationViewController : BaseEmulationViewController<AnimatedImageSequenceDelegate, UIWebViewDelegate> {
    VirtualKeyboard				*vKeyboard;
    FloatPanel *fullscreenPanel;
    bool keyboardactive;
    bool joyactive;
    UIButton *btnKeyboard;
    UIButton *btnJoypad;
    //JoystickViewLandscape *joyControllerMain;
    UIView *mouseHandlermain;
}

@property (readwrite) bool keyboardactive;
@property (readonly) CGFloat screenHeight;
@property (readonly) CGFloat screenWidth;
@property (readwrite) UIButton *btnKeyboard;
@property (nonatomic, retain) InputControllerView *joyControllerMain;


- (IBAction)restart:(id)sender;
- (void) settings;
- (void) initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:p_dummy_textfield_f;
- (void)initializeFullScreenPanel:(int)barwidth barheight:(int)barheight iconwidth:(int)iconwidth iconheight:(int)iconheight;
- (void)initializeJoypad:(InputControllerView *)joyController;

@end
