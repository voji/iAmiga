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

- (void)viewWillAppear:(BOOL)animated {
    //[self startIntroSequence];
}

extern void uae_reset();

- (IBAction)restart:(id)sender {
        uae_reset();
}

- (IBAction)controls:(id)sender {

    SettingsController *viewController = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
    viewController.view.frame = CGRectMake(0, 0, self.screenHeight, self.screenWidth);
    //[self.view addSubview:viewController.view];
    [self.navigationController pushViewController:viewController animated:YES];
     //view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
    //[view release];

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

@end
