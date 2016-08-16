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

#import "ScrollToRowHandler.h"

@implementation ScrollToRowHandler {
    @private
    UITableView *_tableView;
    NSString *_identity;
}

- (instancetype)initWithTableView:(UITableView *)tableView identity:(NSString *)identity {
    if (self = [super init]) {
        _tableView = [tableView retain];
        _identity = [identity retain];
    }
    return self;
}

- (void)setRow:(NSIndexPath *)indexPath {
    [[ScrollToRowHandler dict] setObject:indexPath forKey:_identity];
}

- (NSIndexPath *)getRow {
    return [[ScrollToRowHandler dict] objectForKey:_identity];
}

- (void)clearRow {
    [[ScrollToRowHandler dict] removeObjectForKey:_identity];
}

- (NSIndexPath *)scrollToRow {
    NSIndexPath *row = [self getRow];
    if (row) {
        [_tableView scrollToRowAtIndexPath:row
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
    }
    return row;
}

- (void)dealloc {
    [_tableView release];
    [_identity release];
    [super dealloc];
}

+ (NSMutableDictionary *)dict {
    static NSMutableDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [[NSMutableDictionary alloc] init];
    });
    return dict;
}

@end
