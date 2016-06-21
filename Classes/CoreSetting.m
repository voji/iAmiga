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
#import "DiskDriveService.h"
#import "HardDriveService.h"
#import "Settings.h"

@interface CoreSettingsRegistry : NSObject

+ (CoreSettingsRegistry *)sharedRegistry;

@property (nonatomic, readonly) NSMutableDictionary *settingToCurrentValue;

@end

/**
 * Method names starting with "hook_" are meant to be implemented by subclasses.
 */
@implementation CoreSetting {
    @private
    CoreSettingsRegistry *_registry;
    NSString *_settingName;
    
    @protected
    Settings *_settings;
}

/**
 * Persists the given setting value.  Subclasses must implement.
 */
- (void)hook_persistValue:(id)value {
    [NSException raise:@"Subclasses must implement" format:@"%@", NSStringFromSelector(_cmd)];
}

/**
 * Returns the current value of this setting as far as the emulator is concerned.  Subclasses must implement.
 */
- (id)hook_getEmulatorValue {
    [NSException raise:@"Subclasses must implement" format:@"%@", NSStringFromSelector(_cmd)];
    return nil;
}

/**
 * Callback where subclasses can run custom logic when the emulator is reset.  Subclasses may implement.
 *
 * This method is only called if hasUnappliedValue returns YES for this setting instance.
 */
- (void)hook_onReset:(id)value {
    
}

- (instancetype)initWithName:(NSString *)settingName {
    if (self = [super init]) {
        _registry = [CoreSettingsRegistry sharedRegistry];
        _settings = [[Settings alloc] init];
        _settingName = [settingName retain];
    }
    return self;
}

- (void)setValue:(id)value {
    id currentValue = [self hook_getEmulatorValue];
    id unappliedValue = [self getUnappliedValue];
    BOOL valueIsDifferentFromPreviousValue = NO;
    if ([self eq:currentValue to:value]) {
        [_registry.settingToCurrentValue removeObjectForKey:self];
        valueIsDifferentFromPreviousValue = unappliedValue != nil;
    } else {
        if (unappliedValue) {
            valueIsDifferentFromPreviousValue = ![self eq:unappliedValue to:value];
        } else {
            valueIsDifferentFromPreviousValue = YES;
        }
        if (valueIsDifferentFromPreviousValue) {
            [_registry.settingToCurrentValue setObject:value ? value : [NSNull null] forKey:self];
        }
    }
    if (valueIsDifferentFromPreviousValue) {
        [self hook_persistValue:value];
    }
}

- (id)getValue {
    id value = [self getUnappliedValue];
    if (value) {
        return value == [NSNull null] ? nil : value;
    }
    return [self hook_getEmulatorValue];
}

- (BOOL)hasUnappliedValue {
    return [self getUnappliedValue] != nil;
}

- (NSString *)getMessageForModification {
    return @"Requires reset to take effect";
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self retain];
}

- (NSString *)description {
    return _settingName;
}

- (BOOL)eq:(id)thing1 to:(id)thing2 {
    if (!thing1 && !thing2) return YES;
    if (!thing1 && thing2 == [NSNull null]) return YES;
    if (thing1 == [NSNull null] && !thing2) return YES;
    return [thing1 isEqual:thing2];
}

- (NSString *)getUnappliedValue {
    return [_registry.settingToCurrentValue objectForKey:self];
}

- (void)dealloc {
    [_settingName release];
    [_settings release];
    [super dealloc];
}

@end

@implementation DriveServiceBasedCoreSetting {
    @protected
    DiskDriveService *_diskDriveService;
}

- (instancetype)initWithName:(NSString *)settingName {
    if ([super initWithName:settingName]) {
        _diskDriveService = [[DiskDriveService alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_diskDriveService release];
    [super dealloc];
}

@end

@implementation RomCoreSetting

- (void)hook_persistValue:(NSString *)romPath {
    _settings.romPath = romPath;
}

- (void)hook_onReset:(NSString *)romPath {
    [_diskDriveService configureRom:romPath];
}

- (NSString *)hook_getEmulatorValue {
    return [_diskDriveService getRomPath];
}

@end

@implementation DiskDriveEnabledCoreSetting

- (NSString *)getMessageForModification {
    BOOL enabled = [[self getUnappliedValue] boolValue];
    return [NSString stringWithFormat:@"%@ drive: requires reset to take effect", enabled ? @"Enabled" : @"Disabled"];
}

- (void)hook_persistValue:(NSNumber *)enabled {
    DriveState *driveState = _settings.driveState;
    [self hook_setEnabled:[enabled boolValue] onDriveState:driveState];
    _settings.driveState = driveState;
}

- (NSNumber *)hook_getEmulatorValue {
    DriveState *driveState = [_diskDriveService getDriveState];
    return [NSNumber numberWithBool:[self hook_getEnabledFromDriveState:driveState]];
}

- (BOOL)hook_getEnabledFromDriveState:(DriveState *)driveState {
    [NSException raise:@"Subclasses must implement" format:@"%@", NSStringFromSelector(_cmd)];
    return NO;
}

- (void)hook_setEnabled:(BOOL)enabled onDriveState:(DriveState *)driveState {
    [NSException raise:@"Subclasses must implement" format:@"%@", NSStringFromSelector(_cmd)];
}

@end

@implementation DF1EnabledCoreSetting

- (BOOL)hook_getEnabledFromDriveState:(DriveState *)driveState {
    return driveState.df1Enabled;
}

- (void)hook_setEnabled:(BOOL)enabled onDriveState:(DriveState *)driveState {
    [driveState setDf1Enabled:enabled];
}

@end

@implementation DF2EnabledCoreSetting

- (BOOL)hook_getEnabledFromDriveState:(DriveState *)driveState {
    return driveState.df2Enabled;
}

- (void)hook_setEnabled:(BOOL)enabled onDriveState:(DriveState *)driveState {
    [driveState setDf2Enabled:enabled];
}

@end

@implementation DF3EnabledCoreSetting

- (BOOL)hook_getEnabledFromDriveState:(DriveState *)driveState {
    return driveState.df3Enabled;
}

- (void)hook_setEnabled:(BOOL)enabled onDriveState:(DriveState *)driveState {
    [driveState setDf3Enabled:enabled];
}

@end

@implementation HD0PathCoreSetting {
    @private
    HardDriveService *_hardDriveService;
}

- (instancetype)initWithName:(NSString *)settingName {
    if ([super initWithName:settingName]) {
        _hardDriveService = [[HardDriveService alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_hardDriveService release];
    [super dealloc];
}

- (void)hook_persistValue:(NSString *)hd0Path {
    _settings.hardfilePath = hd0Path;
}

- (void)hook_onReset:(NSString *)hdfPath {
    if (hdfPath) {
        [_hardDriveService mountHardfile:hdfPath];
    } else {
        [_hardDriveService unmountHardfile];
    }
}

- (NSString *)hook_getEmulatorValue {
    return [_hardDriveService getMountedHardfilePath];
}

@end

extern int mainMenu_ntsc;

@implementation NTSCEnabledCoreSetting

- (void)hook_persistValue:(NSNumber *)enabled {
    _settings.ntsc = [enabled boolValue];
}

- (void)hook_onReset:(NSNumber *)enabled {
    mainMenu_ntsc = [enabled intValue];
}

- (NSNumber *)hook_getEmulatorValue {
    return [NSNumber numberWithInt:mainMenu_ntsc];
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
        _settingToCurrentValue = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end

@implementation CoreSettings

+ (void)onReset {
    NSMutableDictionary *sToV = [CoreSettingsRegistry sharedRegistry].settingToCurrentValue;
    for (CoreSetting *setting in sToV.keyEnumerator) {
        id unappliedValue = [sToV objectForKey:setting];
        if (unappliedValue) {
            [setting hook_onReset:unappliedValue == [NSNull null] ? nil : unappliedValue];
        }
    }
    [sToV removeAllObjects];
}

+ (RomCoreSetting *)romCoreSetting {
    static RomCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[RomCoreSetting alloc] initWithName:@"ROM"];
    });
    return setting;
}

+ (DF1EnabledCoreSetting *)df1EnabledCoreSetting {
    static DF1EnabledCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[DF1EnabledCoreSetting alloc] initWithName:@"DF1Enabled"];
    });
    return setting;
}

+ (DF2EnabledCoreSetting *)df2EnabledCoreSetting {
    static DF2EnabledCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[DF2EnabledCoreSetting alloc] initWithName:@"DF2Enabled"];
    });
    return setting;
}

+ (DF3EnabledCoreSetting *)df3EnabledCoreSetting {
    static DF3EnabledCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[DF3EnabledCoreSetting alloc] initWithName:@"DF3Enabled"];
    });
    return setting;
}


+ (HD0PathCoreSetting *)hd0PathCoreSetting {
    static HD0PathCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[HD0PathCoreSetting alloc] initWithName:@"HD0Path"];
    });
    return setting;
}

+ (NTSCEnabledCoreSetting *)ntscEnabledCoreSetting {
    static NTSCEnabledCoreSetting *setting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[NTSCEnabledCoreSetting alloc] initWithName:@"NTSCEnabled"];
    });
    return setting;
}

@end
