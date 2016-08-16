//  Created by Simon Toens on 06.08.16
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
 * Handles scrolling to a previously specified UITableView row.
 */
@interface ScrollToRowHandler : NSObject

- (instancetype)init __unavailable;

/**
 * The given identity is used to uniquely identify the specified tableView.
 */
- (instancetype)initWithTableView:(UITableView *)tableView identity:(NSString *)identity;

/**
 * Sets a row to scroll to.  
 * 
 * The row set here is associated with the identity specified in the init method; the given indexPath is persisted
 * across instances of this class.
 */
- (void)setRow:(NSIndexPath *)indexPath;

/**
 * Returns the row that was previously set.
 */
- (NSIndexPath *)getRow;

/**
 * Clears the row that was previously set.
 */
- (void)clearRow;

/**
 * Scrolls to the previously set row.  If no row has been set, calling this method is a noop.
 * 
 * Returns the row scrolled to, or nil if no row has been set.
 */
- (NSIndexPath *)scrollToRow;

@end
