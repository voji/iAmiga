//  Created by Simon Toens on 07.03.15
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
 * Handles the details of where and how states are stored.
 */
@interface StateFileManager : NSObject

- (instancetype)init;

/**
 * Returns YES if a state file exists for the given state name, NO otherwise.
 */
- (BOOL)stateFileExistsForStateName:(NSString *)stateName;

/**
 * Returns the fully qualified path to the state file identified by the given state name.
 */
- (NSString *)getStateFilePathForStateName:(NSString *)stateName;

/**
 * Saves and associates the specified image with the given state path.
 */
- (void)saveStateImage:(UIImage *)image forStateFilePath:(NSString *)stateFilePath;

/**
 * Returns YES if the given state name does not contain any problematic characters, NO otherwise.
 */
- (BOOL)isValidStateName:(NSString *)stateName;

/**
 * Returns an array of all persisted State instances.
 */
- (NSArray *)loadStates;

/**
 * Deletes the specified state.
 */
- (void)deleteState:(State *)state;

@end