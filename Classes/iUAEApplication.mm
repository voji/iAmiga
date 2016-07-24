//  Created by Emufr3ak on 17.07.16.
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
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#define MENUBAR 123

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
    
    [super sendEvent:event];
    
    if(_firstClick && event.type == UIEventTypeTouches) {
        
        UITouch *touch = event.allTouches.anyObject;
        UIView *touchedview = [touch view];
        
        MultiPeerConnectivityController *mpcController = [MultiPeerConnectivityController getinstance];
        
        if(mpcController && ![touchedview isMemberOfClass:[UIButton class]]) {
            [mpcController enableControllerMode];
        }
        
        _firstClick = 0;
    }
}

@end
