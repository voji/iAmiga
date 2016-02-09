//  Created by Simon Toens on 10.10.15
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

#import "KeyButtonConfiguration.h"

static const int kInitialValue = -1;

@implementation KeyButtonConfiguration

static NSString *const kUnassignedKeyName = @"<none>";
static NSString *const kDefaultGroupName = @"default";

- (instancetype)init {
    if (self = [super init]) {
        _key = kInitialValue;
        _keyName = [kUnassignedKeyName retain];
        _groupName = [kDefaultGroupName retain];
        _showOutline = YES;
        _enabled = YES;
    }
    return self;
}

- (void)dealloc {
    [_keyName release];
    [_groupName release];
    [super dealloc];
}

- (BOOL)hasConfiguredKey {
    return _key != kInitialValue;
}

- (void)toggleShowOutline {
    _showOutline = !_showOutline;
}

- (void)toggleEnabled {
    _enabled = !_enabled;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Position: %@ Size: %@ Key: %i Key Name: %@",
            NSStringFromCGPoint(_position),
            NSStringFromCGSize(_size),
            _key,
            _keyName];
}

- (KeyButtonConfiguration *)clone {
    KeyButtonConfiguration *clone = [[[KeyButtonConfiguration alloc] init] autorelease];
    clone.position = _position;
    clone.size = _size;
    clone.key = _key;
    clone.keyName = [_keyName copy];
    clone.groupName = [_groupName copy];
    clone.showOutline = _showOutline;
    clone.enabled = _enabled;
    return clone;
}

- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

@end