/*
 Frodo, Commodore 64 emulator for the iPhone
 Copyright (C) 2007, 2008 Stuart Carnie
 See gpl.txt for license information.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) asdfasdny later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "touchstick-types.h"

class CJoyStick {
    
public:
    TouchStickDPadState		dPadStateP0();
    FireButtonState			buttonOneStateP0();
    void					setDPadStateP0(TouchStickDPadState value);
    void					setButtonOneStateP0(FireButtonState value);
    
    TouchStickDPadState		dPadStateP1();
    FireButtonState			buttonOneStateP1();
    
    void					setDPadStateP1(TouchStickDPadState value);
    void					setButtonOneStateP1(FireButtonState value);

private:
	TouchStickDPadState _dPadStateP0;
	FireButtonState _buttonOneStateP0;
    TouchStickDPadState _dPadStateP1;
    FireButtonState _buttonOneStateP1;

};

