//
//  DOTCEmulationViewController.h
//  iAmiga
//
//  Created by Stuart Carnie on 7/11/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEmulationViewController.h"
#import "AnimatedImageSequenceView.h"
#import "SettingsController.h"

@class VirtualKeyboard;

@interface MainEmulationViewController : BaseEmulationViewController<AnimatedImageSequenceDelegate, UIWebViewDelegate> {
    VirtualKeyboard				*vKeyboard;
}

@property (readonly) CGFloat screenHeight;
@property (readonly) CGFloat screenWidth;

- (IBAction)restart:(id)sender;
- (void) settings;

@end
