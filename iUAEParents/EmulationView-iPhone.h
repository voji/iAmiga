//
//  EmulationViewiPhone.h
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
    IBOutlet UITextField *dummy_textfield_f; //dummy textfield used to display the keyboard with
    IBOutlet UITextField *dummy_textfield_s; //dummy textfield for special key like right shift numlock etc .....
    InputControllerView *joyController;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIView *mouseHandler;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;
@property (retain, nonatomic) IBOutlet InputControllerView *joyController;



@end
