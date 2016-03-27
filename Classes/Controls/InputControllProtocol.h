//
//  InputControllProtocol.h
//  iUAE
//
//  Created by Urs on 26.03.16.
//
//

#import <Foundation/Foundation.h>

@protocol InputControllProtocol <NSObject>
- (void)didPushIOSJoystickButton:(int)buttonid;
@end