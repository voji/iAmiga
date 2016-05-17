//  Created by Simon Toens on 11.05.16
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
 * A special setting (property/switch/toggle) that requires an emulator reset to take effect.  For example, the rom being used.
 *
 * This is an abstract class.
 */
@interface CoreSetting : NSObject <NSCopying>

/**
 * Updates the value of this setting (persists the new value).
 */
- (void)toggleFromOldValue:(NSString *)oldValue toNewValue:(NSString *)newValue;

/**
 * Returns YES if the setting has a new value, but a reset has not happened yet (ie the value has not taken effect).
 */
- (BOOL)hasUnappliedValue;

- (instancetype)init __unavailable;

@end

@interface RomCoreSetting : CoreSetting

@end


@interface CoreSettings : NSObject

/**
 * Notifies that the emulator has been reset.
 */
+ (void)onReset;

+ (RomCoreSetting *)romCoreSetting;

@end
