//  Created by Simon Toens on 22.05.16
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
#import "CoreSetting.h"

@interface UnappliedSettingLabelHandler : NSObject

/**
 * Adds a label to the specified cell; the label is associated with the given setting and shows a "requires emulator reset" type
 * message when the setting has an unapplied value.
 */
- (void)addResetWarningLabelForCell:(UITableViewCell *)cell forSetting:(CoreSetting *)setting;

/**
 * Adds a label to the specified cell; the label is associated with the given settings and shows a "requires emulator reset" type
 * message when the first setting found in the array has an unapplied value.
 */
- (void)addResetWarningLabelForCell:(UITableViewCell *)cell forSettings:(NSArray *)settings;

/**
 * Required to be called before the final view renders.
 */
- (void)layoutLabels;

/**
 * Enables/disables labels based on the state of their associated setting.
 */
- (void)updateLabelStates;

@end
