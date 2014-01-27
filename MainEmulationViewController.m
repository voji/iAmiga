//
//  DOTCEmulationViewController.m
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "MainEmulationViewController.h"

@interface MainEmulationViewController()

//- (void)startIntroSequence;

@end

@implementation MainEmulationViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidLoad {
    //---------------------------------------------------
    // 12. Fullscreen Panel
    //---------------------------------------------------
    fullscreenPanel = [[FloatPanel alloc] initWithFrame:CGRectMake(0,0,700,47)];
    UIButton *btnExitFS = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,72,36)] autorelease];
    btnExitFS.center=CGPointMake(63, 18);
    [btnExitFS setImage:[UIImage imageNamed:@"exitfull~ipad.png"] forState:UIControlStateNormal];
    [btnExitFS addTarget:self action:@selector(toggleScreenSize) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenPanel.contentView addSubview:btnExitFS];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self startIntroSequence];
}

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

- (IBAction)controls:(id)sender {
    /*HeadViewController *headViewController = [[HeadViewController alloc] initWithNibName:@"HeadViewController" bundle:nil];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    [view addSubview:headViewController.vew];
    [self.view addSubview:view];*/
    
    //UIView *view = [[UIView alloc] initWithNibName:@"SettingsController" bundle:nil];
    SettingsController *viewController = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
    viewController.view.frame = CGRectMake(0, 0, 320, 120);
    [self.view addSubview:viewController.view];
    
    //view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
    //[view release];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *fn = [NSString stringWithFormat:@"setVersion('%@');", self.bundleVersion];
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:fn];
}

@end
