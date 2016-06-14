//
//  iUAEApplication.m
//  iUAE
//
//  Created by Urs on 02.06.16.
//
//

#import "iUAEApplication.h"
#import "MultiPeerConnectivityController.h"

@implementation iUAEApplication {
    int _firstClick;
}

-(id)init {
    _firstClick = 1;
    
    [super init];
    
    return self;
}

- (void)sendEvent:(UIEvent*)event {
    
    if(_firstClick && event.type == UIEventTypeTouches) {
        MultiPeerConnectivityController *mpcController = [MultiPeerConnectivityController getinstance];
        
        if(mpcController) {
            [mpcController enableControllerMode];
        }
        
        _firstClick = 0;
    }
    
    [super sendEvent:event];
}

@end
