//  Created by Simon Toens on 10.07.15
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
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import <Foundation/Foundation.h>

/**
 * Tracks enabled/disabled state of drives.
 *
 * This is a convenience class to group the state of all drives in one place - updating the properties does not affect the actual drive states!
 */
@interface DriveState : NSObject

/**
 * Returns a DriveState instace with all drives enabled.
 */
+ (DriveState *)getAllEnabled;

@property (nonatomic, assign) BOOL df1Enabled;
@property (nonatomic, assign) BOOL df2Enabled;
@property (nonatomic, assign) BOOL df3Enabled;

@end