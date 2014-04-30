//
//  EmulationViewiPhone.h
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainEmulationViewController.h"
#import "FloatPanel.h"
#import "IOSKeyboard.h"
#import "InputControllerView.h"

@interface EmulationViewiPhone : MainEmulationViewController {

    UIButton *closeButton;
    UIView *mouseHandler;
    UIButton *restartButton;
    UIWebView *webView;
    IBOutlet UITextField        *dummy_textfield; // dummy text field used to display the keyboard
    IBOutlet UITextField *dummy_textfield_f; //dummy textfield used to display the keyboard with function keys
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIView *mouseHandler;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;

@end
