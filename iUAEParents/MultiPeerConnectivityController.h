//
//  MultiPeerConnectivityController.h
//  iUAE
//
//  Created by familie on 24.02.16.
//
//

#ifndef MultiPeerConnectivityController_h
#define MultiPeerConnectivityController_h

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MainEmulationViewController.h"


@interface MultiPeerConnectivityController : NSObject<MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate> {
 }
    @property (readwrite, retain) MainEmulationViewController *mainEmuViewController;

- (void)configure: (MainEmulationViewController *) mainEmuViewCtrl ;

@end

#endif /* MultiPeerConnectivityController_h */
