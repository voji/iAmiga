//  Created by Simon Toens on 08.17.16
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
 * A CoreSettingGroup receives lifecycle callbacks for a group of related CoreSettings.
 *
 * Protocol adopters must provide an implementation for - (id)copyWithZone:(nullable NSZone *)zone
 */
@protocol CoreSettingGroup <NSObject>

/**
 * Called after all CoreSetting instances that are part of this group have been reset.
 */
- (void)onResetAfterMembers:(NSSet *)groupMembers;

@end

/**
 * CoreSetting instances that are part of a CoreSettingGroup must adopt this protocol.
 */
@protocol CoreSettingGroupMember <NSObject>

- (Class)getGroup;

@end
