//
//  DOTCEmulationViewController.h
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
- (void) initializeKeyboard:(UITextField *)p_dummy_textfield dummytextf:(UITextField *)p_dummy_textfield_f dummytexts:(UITextField *)p_dummy_textfield_s;
- (void)initializeFullScreenPanel:(int)barwidth barheight:(int)barheight iconwidth:(int)iconwidth iconheight:(int)iconheight;
- (void)initializeJoypad:(InputControllerView *)joyController;

@end
