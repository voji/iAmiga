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

@interface MainEmulationViewController : BaseEmulationViewController<AnimatedImageSequenceDelegate, UIWebViewDelegate> {
    //BOOL _introSequenceRunning;
}

@property (readonly) CGFloat screenHeight;
@property (readonly) CGFloat screenWidth;

- (IBAction)restart:(id)sender;
- (IBAction)controls:(id)sender;

@end
