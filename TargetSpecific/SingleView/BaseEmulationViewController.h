//
//  BaseEmulationViewController.h
//  iAmiga
//
//  Created by Stuart Carnie on 6/22/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//
//  Changed by Emufr3ak on 29.05.14.
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

#import <UIKit/UIKit.h>
#import "SDL.h"

@protocol DisplayViewSurface;

enum tagEmulatorState {
	EmulatorNotStarted,
	EmulatorPaused,
	EmulatorRunning
} ;

@interface BaseEmulationViewController : UIViewController {
    // Views: both orientations
	UIView<DisplayViewSurface>	*displayView;
		
	// Emulator
	NSThread					*emulationThread;
	enum tagEmulatorState		emulatorState;
		
	BOOL						_isExternal;
	UIWindow					*displayViewWindow;
	BOOL						_integralSize;
}

@property (nonatomic)			BOOL						integralSize;
@property (nonatomic, readonly) CGFloat                     displayTop;
@property (nonatomic, readonly) NSString                    *bundleVersion;

- (void)startEmulator;
- (void)runEmulator;
- (void)pauseEmulator;
- (void)resumeEmulator;
- (void)setDisplayViewWindow:(UIWindow*)window isExternal:(BOOL)isExternal;
- (void)sendKeys:(SDLKey*)keys count:(size_t)count keyState:(SDL_EventType)keyState afterDelay:(NSTimeInterval)delayInSeconds;

@end
