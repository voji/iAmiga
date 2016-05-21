/*
 Copyright (C) 2011 by Stuart Carnie
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "iCadeReaderView.h"
#import "JoypadKey.h"
#import "MultiPeerConnectivityController.h"
#import <ExternalAccessory/ExternalAccessory.h>

static const char *ON_STATES  = "wdxayhujikol";
static const char *OFF_STATES = "eczqtrfnmpgv";

@interface iCadeReaderView()

- (void)didEnterBackground;
- (void)didBecomeActive;

@end

@implementation iCadeReaderView {
    int _button[9];
    MultiPeerConnectivityController *_mpcController;
    Uint8 _controllerhatstate;
    int _buttontoreleasehorizontal;
    int _buttontoreleasevertical;
}

@synthesize iCadeState=_iCadeState, delegate=_delegate, active;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    inputView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    for(int i=0;i<=8;i++)
        _button[i] = 0;
    
    _mpcController = [MultiPeerConnectivityController getinstance];
    
    [self discoverController];
    
    return self;
}

- (void)discoverController {
    
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];    //we want to hear about accessories connecting and disconnecting
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerDidConnect:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerDidDisconnect:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];
}

- (void)controllerDidConnect:(NSNotification*)cNotification {
}

- (void)controllerDidDisconnect:(NSNotification*)cNotification {
    
    EAAccessory *cObject = [cNotification.userInfo objectForKey:EAAccessoryKey];
    
    NSString *mName = [cObject manufacturer];
    
    if([mName isEqualToString:@"iCade"])
    {
        [_mpcController controllerDisconnected:kiCadePad];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [super dealloc];
}

- (void)didEnterBackground {
    if (self.active)
        [self resignFirstResponder];
}

- (void)didBecomeActive {
    if (self.active)
        [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder { 
    return YES; 
}

- (void)setActive:(BOOL)value {
    if (active == value) return;
    
    active = value;
    if (active) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

//- (void) drawRect:(CGRect)rect 
//{
// This space intentionally left blank. Woot.
//}

- (UIView*) inputView {
    return inputView;
}

- (void)setDelegate:(id<iCadeEventDelegate>)delegate {
    _delegate = delegate;
    if (!_delegate) return;
    
    _delegateFlags.stateChanged = [_delegate respondsToSelector:@selector(stateChanged:)];
    _delegateFlags.buttonDown = [_delegate respondsToSelector:@selector(buttonDown:)];
    _delegateFlags.buttonUp = [_delegate respondsToSelector:@selector(buttonUp:)];
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
    return NO;
}

- (void)handleinputbuttons {
    
    for(int i=iCadeButtonFirst, btn=0; i <= iCadeButtonLast; i <<= 1, btn++) {
        
        int pr = ((i & _iCadeState) != 0) ? TRUE : FALSE;
        
        if (_button[btn] != pr)
        {
            int btn_pressed;
            
            _button[btn] = pr;
            
            switch (btn) {
                case 0:
                    btn_pressed = BTN_X;
                    break;
                    
                case 1:
                    btn_pressed = BTN_A;
                    break;
                    
                case 2:
                    btn_pressed = BTN_Y;
                    break;
                    
                case 3:
                    btn_pressed = BTN_B;
                    break;
                    
                case 4:
                    btn_pressed = BTN_L1;
                    break;
                    
                case 5:
                    btn_pressed = BTN_R1;
                    break;
                    
                case 6:
                    btn_pressed = BTN_L2;
                    break;
                    
                case 7:
                    btn_pressed = BTN_R2;
                    break;
                    
                default:
                    break;
            }
            
            _button[btn] = [_mpcController handleinputbuttons:btn_pressed buttonstate:_button[btn] deviceid:kiCadePad];
            
        }
        
        Uint8 hat_state = (_iCadeState & 0x0f);
        if (_controllerhatstate != hat_state) {
           
            
            int buttonvertical = [_mpcController dpadstatetojoypadkey:@"vertical" hatstate:hat_state];
            int buttonhorizontal = [_mpcController dpadstatetojoypadkey:@"horizontal" hatstate: hat_state];

            [_mpcController handleinputdirections:hat_state buttontoreleasevertical:_buttontoreleasevertical buttontoreleasehorizontal:_buttontoreleasehorizontal deviceid:kiCadePad];
            
            _controllerhatstate = hat_state;
            _buttontoreleasevertical = buttonvertical;
            _buttontoreleasehorizontal = buttonhorizontal;
        }
        
    }
}

- (void)insertText:(NSString *)text {
    
    char ch = [text characterAtIndex:0];
    if (ch >= 65 && ch < 91)
        ch+=32; // lowercase
    
    char *p = strchr(ON_STATES, ch);
    bool stateChanged = false;
    if (p) {
        int index = p-ON_STATES;
        _iCadeState |= (1 << index);
        stateChanged = true;
        if (_delegateFlags.buttonDown) {
            [_delegate buttonDown:(1 << index)];
        }
        
        [self handleinputbuttons];
    } else {
        p = strchr(OFF_STATES, ch);
        if (p) {
            int index = p-OFF_STATES;
            _iCadeState &= ~(1 << index);
            stateChanged = true;
            if (_delegateFlags.buttonUp) {
                [_delegate buttonUp:(1 << index)];
            }
            
            [self handleinputbuttons];
        }
    }

    if (stateChanged && _delegateFlags.stateChanged) {
        [_delegate stateChanged:_iCadeState];
    }
    
    static int cycleResponder = 0;
    if (++cycleResponder > 20) {
        // necessary to clear a buffer that accumulates internally
        cycleResponder = 0;
        [self resignFirstResponder];
        [self becomeFirstResponder];
    }
}

- (void)deleteBackward {
    // This space intentionally left blank to complete protocol. Woot.
}

@end
