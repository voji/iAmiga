//
//  EmulationViewiPad.h
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmulationViewController.h"

<<<<<<< HEAD
@class DynamicLandscapeControls;

@interface EmulationViewiPad : EmulationViewController <UIWebViewDelegate> {
=======
@interface EmulationViewiPad : EmulationViewController {
>>>>>>> parent of fa960e3... Configurable onscreen mouse buttons
    
    UIButton *menuButton;
    UIButton *closeButton;
    UIView *mouseHandler;
    UIButton *restartButton;
    UIView *menuView;
    UIWebView *webView;
}
- (IBAction)hideMenu:(id)sender;
- (IBAction)showMenu:(id)sender;

@property (nonatomic, retain) IBOutlet UIView *menuView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIView *mouseHandler;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;

@end
