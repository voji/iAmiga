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

extern CJoyStick g_touchStick;

@implementation MFIControllerReaderView {
    CJoyStick							*_thejoystick;
    int _button[8];
    Settings *_settings;
    TouchStickDPadState _hat_statelast;
    TouchStickDPadState _hat_state;
    int _asciicodekeytoreleasehorizontal;
    int _asciicodekeytoreleasevertical;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _hat_state = DPadCenter;
    _buttonapressed = false;
    _thejoystick = &g_touchStick;
    _hat_statelast = DPadCenter;
    
    for(int i=0;i<=7;i++)
        _button[i] = 0;
    
    [self discoverController];
    _settings = [[Settings alloc] init];
    
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
        [self controllerDiscovered];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(discoverController)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
    }
}

- (void)controllerDiscovered {
    
    GCController *controller = [GCController controllers][0];
    
    controller.controllerPausedHandler = ^(GCController *controller) {
        _paused = (_paused == 1) ? 0 : 1;
    };
    
    controller.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement
                                               *element)
    {
        if(gamepad.buttonA.isPressed != _button[BTN_A])
            [self sendinputbuttons:BTN_A];
        else if(gamepad.buttonB.isPressed != _button[BTN_B])
            [self sendinputbuttons:BTN_B];
        else if(gamepad.buttonX.isPressed!= _button[BTN_X])
            [self sendinputbuttons:BTN_X];
        else if(gamepad.buttonY.isPressed != _button[BTN_Y])
            [self sendinputbuttons:BTN_Y];
        else if(gamepad.rightShoulder.isPressed != _button[BTN_R1])
            [self sendinputbuttons:BTN_R1];
        else if(gamepad.leftShoulder.isPressed != _button[BTN_L1])
            [self sendinputbuttons:BTN_L1];
        else if(gamepad.controller.extendedGamepad.rightTrigger.isPressed != _button[BTN_R2])
            [self sendinputbuttons:BTN_R2];
        else if(gamepad.controller.extendedGamepad.leftTrigger.isPressed != _button[BTN_L2])
            [self sendinputbuttons:BTN_L2];
        
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
            [self pushkey];
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

- (void)sendinputbuttons:(int)buttoncode {
    _button[buttoncode] = !_button[buttoncode];
    
    NSString *configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", buttoncode]];
    
    if([configuredkey  isEqual: @"Joypad"])
    {
        if(_button[buttoncode])
            _thejoystick->setButtonOneState(FireButtonDown);
        else
            _thejoystick->setButtonOneState(FireButtonUp);
    }
    else
    {
        int asciicode = [[configuredkey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
        
        if(_button[buttoncode])
        {
            SDL_Event ed = { SDL_KEYDOWN };
            ed.key.keysym.sym = (SDLKey) asciicode;
            SDL_PushEvent(&ed);
        }
        else
        {
            SDL_Event eu = { SDL_KEYUP };
            eu.key.keysym.sym = (SDLKey) asciicode;
            SDL_PushEvent(&eu);
        }
    }
}

- (void) pushkey {
    
    NSString *configuredkeyhorizontal = NULL;
    NSString *configuredkeyvertical = NULL;
    int asciicodehorizontal = NULL;
    int asciicodevertical = NULL;
    
    if([self dpadstatetojoypadkey: @"horizontal"])
    {
        
        configuredkeyhorizontal = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: @"horizontal"]]];
        asciicodehorizontal = [[configuredkeyhorizontal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if([self dpadstatetojoypadkey: @"vertical"])
    {
        configuredkeyvertical = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: @"vertical"]]];
        asciicodevertical = [[configuredkeyvertical stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if(_asciicodekeytoreleasehorizontal)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) _asciicodekeytoreleasehorizontal;
        SDL_PushEvent(&ed);
        _asciicodekeytoreleasehorizontal = NULL;
        
    }
    
    if(_asciicodekeytoreleasevertical)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) _asciicodekeytoreleasevertical;
        SDL_PushEvent(&ed);
        _asciicodekeytoreleasevertical = NULL;
    }
    
    if(_hat_state == DPadCenter)
    {
        _thejoystick->setDPadState(_hat_state);
        return;
    }
    
    if([configuredkeyhorizontal  isEqual: @"Joypad"] && [configuredkeyvertical isEqual:@"joypad"])
    {
        _thejoystick->setDPadState(_hat_state);
        return;
    }
    
    if([configuredkeyhorizontal isEqual: @"Joypad"])
    {
        _thejoystick->setDPadState(_hat_state);
    }
    else if(configuredkeyhorizontal)
    {
        _asciicodekeytoreleasehorizontal = asciicodehorizontal;
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodehorizontal;
        SDL_PushEvent(&ed);
    }
    
    
    if([configuredkeyvertical isEqual: @"Joypad"])
    {
        _thejoystick->setDPadState(_hat_state);
    }
    else if (configuredkeyvertical)
    {
        _asciicodekeytoreleasevertical = asciicodevertical;
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodevertical;
        SDL_PushEvent(&ed);
    }
    
}

- (int) dpadstatetojoypadkey:(NSString *)direction
{
    if(_hat_state == DPadUp)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return NULL;
    }
    else if(_hat_state == DPadUpLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return BTN_LEFT;
    }
    else if(_hat_state == DPadUpRight)
    {
        if([direction isEqual:@"horizontal"])
            return BTN_UP;
        else
            return BTN_RIGHT;
    }
    else if(_hat_state == DPadDown)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return NULL;
    }
    else if (_hat_state == DPadDownLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_LEFT;
    }
    else if (_hat_state == DPadDownRight)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_RIGHT;
    }
    else if (_hat_state == DPadLeft)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_LEFT;
    }
    else if (_hat_state == DPadRight)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_RIGHT;
    }
    return NULL;
}


@end

