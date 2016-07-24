//
//  touchstick.m
//  iUAE
//
//  Created by Urs on 21.05.16.
//
//

#include "touchstick.h"

TouchStickDPadState		CJoyStick::dPadStateP0() { return _dPadStateP0; }
FireButtonState			CJoyStick::buttonOneStateP0() { return _buttonOneStateP0; }

void					CJoyStick::setDPadStateP0(TouchStickDPadState value) { _dPadStateP0 = value; }
void					CJoyStick::setButtonOneStateP0(FireButtonState value) { _buttonOneStateP0 = value; }

TouchStickDPadState		CJoyStick::dPadStateP1() { return _dPadStateP1; }
FireButtonState			CJoyStick::buttonOneStateP1() { return _buttonOneStateP1; }

void					CJoyStick::setDPadStateP1(TouchStickDPadState value) { _dPadStateP1 = value; }
void					CJoyStick::setButtonOneStateP1(FireButtonState value) { _buttonOneStateP1 = value; }
