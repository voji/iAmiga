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

#import "CoreSetting.h"
#import "Settings.h"

@interface CoreSettingsRegistry : NSObject

+ (CoreSettingsRegistry *)sharedRegistry;

@property (nonatomic, readonly) Settings *settings;
@property (nonatomic, readonly) NSMutableDictionary *settingToOriginalValue;

@end

@implementation CoreSetting {
    @private
    CoreSettingsRegistry *_registry;
    NSString *_settingName;
}

- (instancetype)initWithName:(NSString *)settingName {
    if (self = [super init]) {
        _registry = [CoreSettingsRegistry sharedRegistry];
        _settingName = [settingName retain];
    }
    return self;
}

- (void)toggleFromOldValue:(NSString *)oldValue toNewValue:(NSString *)newValue {
    if ([self eq:oldValue to:newValue]) {
        return;
    }
    NSString *originalValue = [_registry.settingToOriginalValue objectForKey:self];
    if (originalValue) {
        if ([self eq:newValue to:originalValue]) {
            [_registry.settingToOriginalValue removeObjectForKey:self];
        }
    } else {
        id o = oldValue ? oldValue : [NSNull null];
        [_registry.settingToOriginalValue setObject:o forKey:self];
    }
    [self persistValue:newValue];
}

- (BOOL)eq:(id)thing1 to:(id)thing2 {
    if (!thing1 && !thing2) return YES;
    if (!thing1 && thing2 == [NSNull null]) return YES;
    if (thing1 == [NSNull null] && !thing2) return YES;
    return [thing1 isEqual:thing2];
}

- (BOOL)hasUnappliedValue {
    return [_registry.settingToOriginalValue objectForKey:self] != nil;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self retain];
}

- (void)persistValue:(id)value {
    [NSException raise:@"Subclasses must implement" format:@"%@", NSStringFromSelector(_cmd)];
}

- (NSString *)description {
    return _settingName;
}

- (void)dealloc {
    [_settingName release];
    [super dealloc];
}

@end

@implementation RomCoreSetting

- (void)persistValue:(id)value {
    [CoreSettingsRegistry sharedRegistry].settings.romPath = value;
}

@end

@implementation CoreSettingsRegistry

+ (CoreSettingsRegistry *)sharedRegistry {
    static CoreSettingsRegistry *registry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registry = [[CoreSettingsRegistry alloc] init];
    });
    return registry;
}

- (instancetype)init {
    if (self = [super init]) {
        _settings = [[Settings alloc] init];
        _settingToOriginalValue = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end

@implementation CoreSettings

+ (void)onReset {
    [[CoreSettingsRegistry sharedRegistry].settingToOriginalValue removeAllObjects];
}

+ (RomCoreSetting *)romCoreSetting {
    static RomCoreSetting *romCoreSetting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        romCoreSetting = [[RomCoreSetting alloc] initWithName:@"ROM"];
    });
    return romCoreSetting;
}

@end
