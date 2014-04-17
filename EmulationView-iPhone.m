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

bool keyboardactive;

UIButton *btnKeyboard;
UIButton *btnSettings;

UIView *FkeyView;
UIView *Accviewmain;
IOSKeyboard *ioskeyboard;

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
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;
    
    [self initializeFullScreenPanel];
    [self initializeKeyboard];
}

- (void) initializeKeyboard {
    
    keyboardactive = FALSE;
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:dummy_textfield fieldf:dummy_textfield_f];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardDidHide:)
                                                   name:UIKeyboardDidHideNotification
                                                 object:nil];
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

- (IBAction)toggleControls:(id)sender {
    
    bool keyboardactiveonstart = keyboardactive;
    
    UIButton *button = (UIButton *) sender;
    
    keyboardactive = (button == btnKeyboard) ? !keyboardactive : FALSE;
    
    btnKeyboard.selected = (button == btnKeyboard) ? !btnKeyboard.selected : FALSE;
    
    if (keyboardactive != keyboardactiveonstart) { [ioskeyboard toggleKeyboard]; }
    if (button == btnSettings) { [self settings]; }
    
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
    CGFloat xPos = [self XposFloatPanel];
    
    fullscreenPanel = [[FloatPanel alloc] initWithFrame:CGRectMake(xPos,0,700,47)];
    UIButton *btnExitFS = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    btnExitFS.center=CGPointMake(63, 18);
    [btnExitFS setImage:[UIImage imageNamed:@"exitfull~ipad.png"] forState:UIControlStateNormal];
    [btnExitFS addTarget:self action:@selector(toggleScreenSize) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenPanel.contentView addSubview:btnExitFS];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:16];
    
    btnSettings = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    [btnSettings setImage:[UIImage imageNamed:@"options.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnSettings];
    
    btnKeyboard = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    [btnKeyboard setImage:[UIImage imageNamed:@"modekeyoff.png"] forState:UIControlStateNormal];
    [btnKeyboard setImage:[UIImage imageNamed:@"modekeyon.png"] forState:UIControlStateSelected];
    [btnKeyboard addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnKeyboard];
    
    [fullscreenPanel setItems:items];
    
    [self.view addSubview:fullscreenPanel];
    [fullscreenPanel showContent];
}

@end
