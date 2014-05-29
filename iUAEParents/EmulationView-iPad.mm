//
//  EmulationViewiPad.m
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
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

#import "EmulationView-iPad.h"

@implementation EmulationViewiPad
//@synthesize menuView;
@synthesize webView;
//@synthesize menuButton;
@synthesize closeButton;
@synthesize mouseHandler;
@synthesize restartButton;
@synthesize joyController;

#pragma mark - View lifecycle

bool keyboardactive;

UIButton *btnKeyboard;

- (CGFloat) XposFloatPanel {
    
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = screenRect.size.height;
    
    
    
    //Middle of the Screen assuming fullScreenPanel has a width of 700
    CGFloat result = (self.screenHeight / 2) - 350;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mouseHandlermain = mouseHandler;
    [self initializeJoypad:joyController];
    
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;
    
    [self initializeFullScreenPanel];
    [super initializeKeyboard:dummy_textfield dummytextf:dummy_textfield_f];
}

- (void)dealloc {
    [closeButton release];
    [mouseHandler release];
    [webView release];
    [restartButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [self setMouseHandler:nil];
    [self setWebView:nil];
    [self setRestartButton:nil];
    [super viewDidUnload];
}

- (IBAction)keyboardDidHide:(id)sender
//Keyboards dismissed by other Means than Fullscreenpanel
{
    //Simulate Button press in Fullscreenpanel if Keyboard was closed by Keyboardclosebutton in Keyboard
    if(keyboardactive == TRUE //Keyboard was closed by regular button in Fullscreenpanel
            && dummy_textfield.isFirstResponder == FALSE //Fkeypanel was deactivated this triggered the event
            && dummy_textfield_f.isFirstResponder == FALSE //Fkeypanel was activated this triggered the event
       )
    {
        [btnKeyboard sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)initializeFullScreenPanel {
    
    [super initializeFullScreenPanel:700 barheight:47 iconwidth:72 iconheight:36];
    
}

@end
