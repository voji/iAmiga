//
//  MultiPeerConnectivityController.h
//  iUAE
//  Created by mithendral on 24.02.16.
//
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

#ifndef MultiPeerConnectivityController_h
#define MultiPeerConnectivityController_h

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MainEmulationViewController.h"


@interface MultiPeerConnectivityController : NSObject<MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate> {
 }
    @property (readwrite, retain) MainEmulationViewController *mainEmuViewController;

- (void)configure: (MainEmulationViewController *) mainEmuViewCtrl ;
+ (MultiPeerConnectivityController *)getinstance;
- (void)sendinputdirections:(TouchStickDPadState)hat_state buttontoreleasevertical:(int)buttontoreleasevertical buttontoreleasehorizontal: (int)buttontoreleasehorizontal;
- (int)sendinputbuttons:(int)buttonid buttonstate:(int)buttonstate;
- (int) dpadstatetojoypadkey:(NSString *)direction hatstate:(TouchStickDPadState)hat_state;
- (void)sendJoystickDataForDirection:(int)direction buttontoreleasehorizontal:(int)buttontoreleasehorizontal buttontoreleasevertical:(int)buttontoreleasevertical;
- (void)sendJoystickDataForButtonID:(int)buttonid buttonstate:(int)buttonstate;

@end

#endif /* MultiPeerConnectivityController_h */
