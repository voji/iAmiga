//
//  EmulationViewiPad.m
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "EmulationView-iPhone.h"

@implementation EmulationViewiPhone
//@synthesize menuView;
@synthesize webView;
//@synthesize menuButton;
@synthesize closeButton;
@synthesize mouseHandler;
@synthesize restartButton;

#pragma mark - View lifecycle

- (CGFloat) XposFloatPanel {
    
    CGRect screenRect = CGRectZero;
    screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = screenRect.size.height;
    
    CGFloat result = (self.screenHeight / 2) - 240;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;
    
    [self initializeFullScreenPanel];
    [super initializeKeyboard:dummy_textfield dummytextf:dummy_textfield_f];
}

- (void)dealloc {
    //[menuButton release];
    [closeButton release];
    //[menuView release];
    [mouseHandler release];
    [webView release];
    [restartButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    //[self setMenuButton:nil];
    [self setCloseButton:nil];
    //[self setMenuView:nil];
    [self setMouseHandler:nil];
    [self setWebView:nil];
    [self setRestartButton:nil];
    [super viewDidUnload];
}

- (void)initializeFullScreenPanel {

    [super initializeFullScreenPanel:480 barheight:32 iconwidth:48 iconheight:24];

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


@end
