//
//  InputController.h
//  iUAE
//
//  Created by Urs on 26.03.16.
//
//

#import <Foundation/Foundation.h>
#import "InputControllProtocol.h"

@interface InputController : NSObject<InputControllProtocol>
- (void)didPushIOSJoystickButton:(int)buttonid;
@end
