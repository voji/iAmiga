//
//  SDL_sysjoystick.m
//  iAmiga
//
//  Created by Stuart Carnie on 6/5/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//
//  Changed by Emufr3ak on 24.06.15.
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

#include "SDL_events.h"
#include "SDL_joystick.h"
#include "SDL_sysjoystick.h"
#include "SDL_joystick_c.h"
#include "SDL_compat.h"
#import "SDLUIAccelerationDelegate.h"
#import "iControlPadReaderView.h"
#import "iCadeReaderView.h"
#import "ButtonStates.h"
#import "SDL_NSObject+Blocks.h"
#import "MFIControllerReaderView.h"
#import "Settings.h"
#import "JoypadKey.h"

extern UIView *GetSharedOGLDisplayView();

#define kTouchStick     0
#define kAccelerometer  1
#define kiControlPad    2
#define kiCade          3
#define kOfficial       4

const char *accelerometerName = "iPhone accelerometer";
const char *iControlPadName = "iControlPad";
const char *iCadeName = "iCADE";
const char *officialName = "Official";

typedef struct joystick_hwdata {
    UIView *view;
} joystick_hwdata;

inline
static int icp_getState(int button);

Settings *settingsforjoystick;

int SDL_SYS_JoystickInit(void) {
    return 5;
}

/* Function to get the device-dependent name of a joystick */
const char *SDL_SYS_JoystickName(int index) {
    switch (index) {
        case kTouchStick:
            return "iPhone touch";
        
        case kAccelerometer:
            return accelerometerName;
            
        case kiControlPad:
            return iControlPadName;
            
        case kiCade:
            return iCadeName;
        
        case kOfficial:
            return officialName;
        default:
			SDL_SetError("No joystick available with t index");
			return NULL;
    }
}

/* Function to open a joystick for use.
 The joystick to open is specified by the index field of the joystick.
 This should fill the nbuttons and naxes fields of the joystick structure.
 It returns 0, or -1 if there is an error.
 */
int
SDL_SYS_JoystickOpen(SDL_Joystick * joystick)
{
    settingsforjoystick = [[Settings alloc] init];
    [settingsforjoystick initializeSettings];
    
    
    if (joystick->index == kiControlPad) {
        joystick->naxes = 0;
        joystick->nhats = 1;
        joystick->nballs = 0;
        joystick->nbuttons = 8;
        joystick->name = iControlPadName;
        joystick->hwdata = (joystick_hwdata *)SDL_malloc(sizeof(joystick_hwdata));
        UIView *view = [[iControlPadReaderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        SDL_Surface *surface = SDL_GetVideoSurface();
        UIView *display = (UIView *)surface->userdata;
        [display performBlock:^(void) {
            // main thread
            [display addSubview:view];
            [view becomeFirstResponder];

        } afterDelay:0.0f];
        joystick->hwdata->view = view;
    } else if (joystick->index == kiCade) {
        joystick->naxes = 0;
        joystick->nhats = 1;
        joystick->nballs = 0;
        joystick->nbuttons = 8;
        joystick->name = iCadeName;
        joystick->hwdata = (joystick_hwdata *)SDL_malloc(sizeof(joystick_hwdata));
        iCadeReaderView *view = [[iCadeReaderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        SDL_Surface *surface = SDL_GetVideoSurface();
        UIView *display = (UIView *)surface->userdata;
    
        [display performBlock:^(void) {
            // main thread
            [display addSubview:view];
            view.active = YES;
        } afterDelay:0.0f];
        joystick->hwdata->view = view;
    } else if (joystick->index == kAccelerometer) {
		joystick->naxes = 3;
		joystick->nhats = 0;
		joystick->nballs = 0;
		joystick->nbuttons = 0;
		joystick->name  = accelerometerName;
		[[SDLUIAccelerationDelegate sharedDelegate] startup];
	}
    else if (joystick->index == kOfficial) {
        joystick->naxes = 0;
        joystick->nhats = 1;
        joystick->nballs = 0;
        joystick->nbuttons = 1;
        joystick->name = officialName;
        joystick->hwdata = (joystick_hwdata *)SDL_malloc(sizeof(joystick_hwdata));
        MFIControllerReaderView *view = [[MFIControllerReaderView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        SDL_Surface *surface = SDL_GetVideoSurface();
        UIView *display = (UIView *)surface->userdata;
        
        [display performBlock:^(void) {
            // main thread
            [display addSubview:view];
            
        } afterDelay:0.0f];
        joystick->hwdata->view = view;
    }
	else {
		SDL_SetError("No joystick available with that index");
		return (-1);
	}
	
    return 0;
}

int
MFI_JoystickUpdateButtons(SDL_Joystick * joystick) {
    
    // buttons
    MFIControllerReaderView *view = (MFIControllerReaderView *)joystick->hwdata->view;

    for (int i = 0; i<= 7;i++)
    {
        Uint8 pr;
        
        switch (i) {
            case 0:
                pr = view.buttonapressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 1:
                pr = view.buttonbpressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 2:
                pr = view.buttonxpressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 3:
                pr = view.buttonypressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 4:
                pr = view.buttonr1pressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 5:
                pr = view.buttonl1pressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 6:
                pr = view.buttonr2pressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            case 7:
                pr = view.buttonl2pressed == true ? SDL_PRESSED : SDL_RELEASED;
                break;
                
            default:
                break;
        }
        
        if (joystick->buttons[i] != pr)
        {
            NSString *configuredkey = [settingsforjoystick stringForKey:[NSString stringWithFormat: @"_BTN_%d", i]];
            
            if([configuredkey  isEqual: @"Joypad"])
            {
                SDL_PrivateJoystickButton(joystick, i, pr); // hasn't changed state, so don't pump and event
            }
            else
            {
                int asciicode = [[configuredkey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
                
                joystick->buttons[i] = pr;
                if(pr == SDL_PRESSED)
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
    }
    
    int paused = view.paused;
    
    if(joystick->paused != paused)
    {
        joystick->paused = paused;
    }
    
    Uint8 hat_state = [view hat_state];
    if (joystick->hats[0] != hat_state) {
        SDL_PrivateJoystickHat(joystick, 0, hat_state);
    }
    
}

/* Function to update the state of a joystick - called as a device poll.
 * This function shouldn't update the joystick structure directly,
 * but instead should call SDL_PrivateJoystick*() to deliver events
 * and update joystick device state.
 */
void
SDL_SYS_JoystickUpdate(SDL_Joystick * joystick)
{

	if (joystick->index == kAccelerometer) {
        Sint16 orientation[3];
        
        if ([[SDLUIAccelerationDelegate sharedDelegate] hasNewData]) {
            
            [[SDLUIAccelerationDelegate sharedDelegate] getLastOrientation: orientation];
            [[SDLUIAccelerationDelegate sharedDelegate] setHasNewData: NO];
            
            SDL_PrivateJoystickAxis(joystick, 0, orientation[0]);
            SDL_PrivateJoystickAxis(joystick, 1, orientation[1]);
            SDL_PrivateJoystickAxis(joystick, 2, orientation[2]);
            
        }
    } else if (joystick->index == kiControlPad) {
        
        // buttons
        for(int i = ICP_BUTTON_BEGIN; i <= ICP_BUTTON_END; i++) {
            SDL_PrivateJoystickButton(joystick, i-ICP_BUTTON_BEGIN, icp_getState(i));
        }
        
        // hat
        int hat_value = SDL_HAT_CENTERED;
        hat_value |= icp_getState(ICP_BUTTON_UP) ? SDL_HAT_UP : 0;
        hat_value |= icp_getState(ICP_BUTTON_RIGHT) ? SDL_HAT_RIGHT : 0;
        hat_value |= icp_getState(ICP_BUTTON_LEFT) ? SDL_HAT_LEFT : 0;
        hat_value |= icp_getState(ICP_BUTTON_DOWN) ? SDL_HAT_DOWN : 0;
        SDL_PrivateJoystickHat(joystick, 0, hat_value);
    } else if (joystick->index == kiCade) {
        
        // buttons
        iCadeReaderView *view = (iCadeReaderView *)joystick->hwdata->view;
        iCadeState state = view.iCadeState;
        
        for(int i=iCadeButtonFirst, btn=0; i <= iCadeButtonLast; i <<= 1, btn++) {
            Uint8 pr = ((i & state) != 0) ? SDL_PRESSED : SDL_RELEASED;

            if (joystick->buttons[btn] == pr) continue; // hasn't changed state, so don't pump and event
            SDL_PrivateJoystickButton(joystick, btn, pr);
        }
        
        Uint8 hat_state = (state & 0x0f);
        if (joystick->hats[0] != hat_state) {
            SDL_PrivateJoystickHat(joystick, 0, hat_state);
        }
    }
    else if (joystick->index == kOfficial) {
        MFI_JoystickUpdateButtons(joystick);
    }

}

/* Function to close a joystick after use */
void
SDL_SYS_JoystickClose(SDL_Joystick * joystick)
{
	if (joystick->index == kAccelerometer && [[SDLUIAccelerationDelegate sharedDelegate] isRunning]) {
		[[SDLUIAccelerationDelegate sharedDelegate] shutdown];
	} else if (joystick->index == kiControlPad) {
        [joystick->hwdata->view removeFromSuperview];
        [joystick->hwdata->view release];
        SDL_free(joystick->hwdata);
    } else if (joystick->index == kiCade) {
        [joystick->hwdata->view removeFromSuperview];
        [joystick->hwdata->view release];
        SDL_free(joystick->hwdata);
    }
    else if (joystick->index == kOfficial)
    {
        [joystick->hwdata->view removeFromSuperview];
        [joystick->hwdata->view release];
        SDL_free(joystick->hwdata);
    }
    else {
        SDL_SetError("No joystick open with that index");
    }
    
    [settingsforjoystick release];
    
    return;
}

/* Function to perform any system-specific joystick related cleanup */
void
SDL_SYS_JoystickQuit(void) {
    return;
}

void SDL_SYS_JoystickSetActive(SDL_Joystick * joystick) {
    if(joystick->hwdata->view)
    {
        [joystick->hwdata->view becomeFirstResponder];
    }
}

// iControlPad
static int LEFT_BYTE[] = {ICP_BUTTON_UP, ICP_BUTTON_RIGHT, ICP_BUTTON_LEFT, ICP_BUTTON_DOWN, ICP_BUTTON_L, ICP_BUTTON_SELECT};
static int RIGHT_BYTE[] = {ICP_BUTTON_START, ICP_BUTTON_Y, ICP_BUTTON_A, ICP_BUTTON_X, ICP_BUTTON_B, ICP_BUTTON_R};

static char buttons[ICP_MAX_BUTTON];
static char buffer[256];
static int pos = 0;

inline
static int icp_getState(int button) {
    return buttons[button];
}

inline
static void setState(int button, int value) {
    buttons[button] = value;
}

void icp_handle(char c) {
    char left;
    char right;
    
    buffer[pos++] = c;
    
    while(pos > 2 && buffer[0] != 'm')
    {
        for(int i=1; i<pos; i++) buffer[i-1] = buffer[i];
        
        pos--;
    }
    
    if(pos > 2 && buffer[0] == 'm')
    {
        left = buffer[1] - 32;
        right = buffer[2] - 32;
        
        for(int i=0; i<6; i++)
        {
            setState(LEFT_BYTE[i], (left & 0x01));
            left >>= 1;
        }
        
        for(int i=0; i<6; i++)
        {
            setState(RIGHT_BYTE[i], (right & 0x01));
            right >>= 1;
        }
        
        for(int i=3; i<pos; i++) buffer[i-3] = buffer[i];
        
        pos -= 3;
    }
    
    if(pos > 10) NSLog(@"Possible error - %i characters queued!", pos);
    if(pos >= 256) pos = 0;
}
