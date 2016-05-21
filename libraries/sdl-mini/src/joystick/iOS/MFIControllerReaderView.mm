//  Created by Emufr3ak on 29.05.14.
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
// You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "MFIControllerReaderView.h"
#import <UIKit/UIKit.h>
#import "debug.h"
#import "touchstick.h"
#import "JoypadKey.h"
#import "Settings.h"
#import "SDL_events.h"
#import "MultiPeerConnectivityController.h"

@implementation MFIControllerReaderView {
    int _button[9];
    TouchStickDPadState _hat_statelast;
    TouchStickDPadState _hat_state;
    MultiPeerConnectivityController *mpcController;
    int _buttontoreleasehorizontal;
    int _buttontoreleasevertical;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _hat_state = DPadCenter;
    _buttonapressed = false;
    //_thejoystick = &g_touchStick;
    _hat_statelast = DPadCenter;
    mpcController = [MultiPeerConnectivityController getinstance];
    
    for(int i=0;i<=7;i++)
        _button[i] = 0;
    
    [self discoverController];
    //_settings = [[Settings alloc] init];
    
    return self;
}

- (void)discoverController {
    
    if ([[GCController controllers] count] == 0) {
        [GCController startWirelessControllerDiscoveryWithCompletionHandler:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDiscovered)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
    } else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(controllerDisconnected)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
    }
}

- (void)handleinputbuttons:(int)buttonid forGamepad:(GCGamepad *) gamepad
{
    _button[buttonid] = [mpcController handleinputbuttons:buttonid buttonstate:_button[buttonid] deviceid:[NSString stringWithFormat:@"%p", gamepad]];
    
    NSLog(@"Buttonstate: %d",_button[buttonid]);
}

- (void)controllerDisconnected:(NSNotification *)disconnectedNotification {
    
    GCController *controller = (GCController *)[disconnectedNotification object];
    [mpcController controllerDisconnected:[NSString stringWithFormat:@"%p", [controller gamepad]]];
}

- (void)controllerDiscovered:(NSNotification *)connectedNotification {
    
    GCController *controller = (GCController *)[connectedNotification object];
    
    controller.controllerPausedHandler = ^(GCController *controller) {
        _paused = (_paused == 1) ? 0 : 1;
    };
    
    controller.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement
                                               *element)
    {
        if(gamepad.buttonA.isPressed != _button[BTN_A])
            [self handleinputbuttons: BTN_A forGamepad:gamepad];
        else if(gamepad.buttonB.isPressed != _button[BTN_B])
               [self handleinputbuttons: BTN_B forGamepad:gamepad];
        else if(gamepad.buttonX.isPressed!= _button[BTN_X])
               [self handleinputbuttons: BTN_X forGamepad:gamepad];
        else if(gamepad.buttonY.isPressed != _button[BTN_Y])
               [self handleinputbuttons: BTN_Y forGamepad:gamepad];
        else if(gamepad.rightShoulder.isPressed != _button[BTN_R1])
               [self handleinputbuttons: BTN_R1 forGamepad:gamepad];
        else if(gamepad.leftShoulder.isPressed != _button[BTN_L1])
                [self handleinputbuttons: BTN_L1 forGamepad:gamepad];
        else if(gamepad.controller.extendedGamepad.rightTrigger.isPressed != _button[BTN_R2])
                [self handleinputbuttons: BTN_R2 forGamepad:gamepad];
        else if(gamepad.controller.extendedGamepad.leftTrigger.isPressed !=     _button[BTN_L2])
              [self handleinputbuttons: BTN_L2 forGamepad:gamepad];
        
        if(gamepad.dpad.left.pressed || gamepad.controller.extendedGamepad.leftThumbstick.left.pressed)
        {
            if(gamepad.dpad.up.pressed)
            {
                _hat_state = DPadUpLeft;
            }
            else if(gamepad.dpad.down.pressed || gamepad.controller.extendedGamepad.leftThumbstick.down.pressed)
            {
                _hat_state = DPadDownLeft;
            }
            else
            {
                _hat_state = DPadLeft;
            }
        }
        else if(gamepad.dpad.right.pressed || gamepad.controller.extendedGamepad.leftThumbstick.right.pressed)
        {
            if(gamepad.dpad.up.pressed || gamepad.controller.extendedGamepad.leftThumbstick.up.pressed)
            {
                _hat_state = DPadUpRight;
            }
            else if(gamepad.dpad.down.pressed || gamepad.controller.extendedGamepad.leftThumbstick.down.pressed)
            {
                _hat_state = DPadDownRight;
            }
            else
            {
                _hat_state = DPadRight;
            }
        }
        else if(gamepad.dpad.up.pressed || gamepad.controller.extendedGamepad.leftThumbstick.up.pressed)
        {
            _hat_state = DPadUp;
        }
        else if(gamepad.dpad.down.pressed || gamepad.controller.extendedGamepad.leftThumbstick.down.pressed)
        {
            _hat_state = DPadDown;
        }
        else
        {
            _hat_state = DPadCenter;
        }
        
        if (_hat_state != _hat_statelast) {
            _hat_statelast = _hat_state;
            
            int buttonvertical = [mpcController dpadstatetojoypadkey:@"vertical" hatstate:_hat_state];
            int buttonhorizontal = [mpcController dpadstatetojoypadkey:@"horizontal" hatstate: _hat_state];
            
            [mpcController handleinputdirections:_hat_state buttontoreleasevertical:_buttontoreleasevertical buttontoreleasehorizontal: _buttontoreleasehorizontal deviceid:[NSString stringWithFormat:@"%p", gamepad]];
            
            _buttontoreleasevertical = buttonvertical;
            _buttontoreleasehorizontal = buttonhorizontal;
        }

    };
    
    GCControllerDirectionPad *dpad = controller.gamepad.dpad;
    dpad.valueChangedHandler = ^ (GCControllerDirectionPad *directionpad,
                                  float xValue, float yValue) {
        NSLog(@"Changed xValue on dPad = %f yValue = %f" ,xValue, yValue);
    };
    
    dpad.xAxis.valueChangedHandler = ^(GCControllerAxisInput *xAxis,float value) {
        NSLog(@"X Axis changed value %f",value);
    };
    
}

-(void)dealloc
{
    [super dealloc];
}

@end

