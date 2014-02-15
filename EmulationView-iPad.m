//
//  EmulationViewiPad.m
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "EmulationView-iPad.h"

@implementation EmulationViewiPad
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
    
    //Middle of the Screen assuming fullScreenPanel has a width of 700
    CGFloat result = (self.screenHeight / 2) - 350;
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;

    //---------------------------------------------------
    // 12. Fullscreen Panel
    //---------------------------------------------------
    CGFloat xPos = [self XposFloatPanel];
    
    fullscreenPanel = [[FloatPanel alloc] initWithFrame:CGRectMake(xPos,0,700,47)];
    UIButton *btnExitFS = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    btnExitFS.center=CGPointMake(63, 18);
    [btnExitFS setImage:[UIImage imageNamed:@"exitfull~ipad.png"] forState:UIControlStateNormal];
    [btnExitFS addTarget:self action:@selector(toggleScreenSize) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenPanel.contentView addSubview:btnExitFS];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:16];
    
    UIButton *btnOpt = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    [btnOpt setImage:[UIImage imageNamed:@"options.png"] forState:UIControlStateNormal];
    [btnOpt addTarget:self action:@selector(controls:) forControlEvents:UIControlEventTouchUpInside];
    [items addObject:btnOpt];
    
    [fullscreenPanel setItems:items];
    
    [self.view addSubview:fullscreenPanel];
    [fullscreenPanel showContent];
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


@end
