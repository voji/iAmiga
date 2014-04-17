//
//  DOTCEmulationViewController.m
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "MainEmulationViewController.h"
#import "VirtualKeyboard.h"

@interface MainEmulationViewController()

//- (void)startIntroSequence;

@end

@implementation MainEmulationViewController

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

-(void) settings {
    SettingsController *viewController = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
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
    
    // virtual keyboard
    
	vKeyboard = [[VirtualKeyboard alloc] initWithFrame:CGRectMake(0, 568, 1024, 200)];
    vKeyboard.autoresizingMask = UIViewAutoresizingNone;
	//vKeyboard.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    vKeyboard.backgroundColor = [UIColor redColor];
	vKeyboard.hidden = YES;
	[self.view addSubview:vKeyboard];
}
@end
