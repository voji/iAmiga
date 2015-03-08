//
//  GCControllerReader.m
//  iUAE
//
//  Created by Urs on 09.11.14.
//
//

#import "MFIControllerReaderView.h"

@implementation MFIControllerReaderView {
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _hat_state = SDL_HAT_CENTERED;
    _buttonpressed = false;
    
    [self discoverController];
    
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
    
    controller.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement
                                               *element)
    {
        _buttonpressed = gamepad.buttonA.isPressed != _buttonpressed ? !_buttonpressed : _buttonpressed; //If value for Button pressed changes invert control value;
        
        if(gamepad.dpad.left.pressed)
        {
            if(gamepad.dpad.up.pressed)
            {
                _hat_state = SDL_HAT_LEFTUP;
            }
            else if(gamepad.dpad.down.pressed)
            {
                _hat_state = SDL_HAT_LEFTDOWN;
            }
            else
            {
                _hat_state = SDL_HAT_LEFT;
            }
        }
        else if(gamepad.dpad.right.pressed)
        {
            if(gamepad.dpad.up.pressed)
            {
                _hat_state = SDL_HAT_RIGHTUP;
            }
            else if(gamepad.dpad.down.pressed)
            {
                _hat_state = SDL_HAT_RIGHTDOWN;
            }
            else
            {
                _hat_state = SDL_HAT_RIGHT;
            }
        }
        else if(gamepad.dpad.up.pressed)
        {
            _hat_state = SDL_HAT_UP;
        }
        else if(gamepad.dpad.down.pressed)
        {
            _hat_state = SDL_HAT_DOWN;
        }
        else
        {
            _hat_state = SDL_HAT_CENTERED;
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

@end

