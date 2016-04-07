//
//  VPadMotionController.h
//  iUAE
//
//  Created by MrStargazer on 27.03.16.
//
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

#ifndef VPadMotionController_h
#define VPadMotionController_h

#import <CoreMotion/CoreMotion.h>

@interface VPadMotionController : NSObject {
}


//+ (VPadMotionController*)motionController;

+ (void) startUpdating;
+ (void) stopUpdating;
+ (void) calibrate;
+ (CMAttitude*) getMotion;
+ (CMAttitude*) referenceAttitude;
+ (BOOL) isActive;
+ (void) setActive;
+ (void) disable;


@end

#endif /* VPadMotionController_h */
