//
//  Settings.m
//  iUAE
//
//  Created by Emufr3ak on 08.03.15.
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

#import "uae.h"
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"
#import "JoypadKey.h"

#import "Settings.h"
#import "KeyButtonConfiguration.h"

static NSString *const kAppSettingsInitializedKey = @"appvariableinitialized";
static NSString *const kInitializeKey = @"_initialize";
static NSString *const kConfigurationNameKey = @"configurationname";
static NSString *const kConfigurationsKey = @"configurations";
static NSString *const kAutoloadConfigKey = @"autoloadconfig";
static NSString *const kInsertedFloppiesKey = @"insertedfloppies";
static NSString *const kKeyButtonsEnabledKey = @"keyButtonsEnabled";
static NSString *const kKeyButtonConfigurationsKey = @"keyButtonConfigurations";

static NSString *const kNtscKey = @"_ntsc";
static NSString *const kStretchScreenKey = @"_stretchscreen";
static NSString *const kAddVerticalStretchKey = @"_addverticalstretchvalue";
static NSString *const kShowStatusKey = @"_showstatus";
static NSString *const kShowStatusBarKey = @"_showstatusbar";
static NSString *const kSelectedEffectIndexKey = @"_selectedeffectindex";

static NSString *const kControllersKey = @"_controllers";
static NSString *const kJoypadStyleKey = @"_joypadstyle";
static NSString *const kJoypadLeftOrRightKey = @"_joypadleftorright";
static NSString *const kJoypadShowButtonTouchKey = @"_joypadshowbuttontouch";

static NSString *const kDf1EnabledKey = @"df1Enabled";
static NSString *const kDf2EnabledKey = @"df2Enabled";
static NSString *const kDf3EnabledKey = @"df3Enabled";

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;
extern int mainMenu_AddVerticalStretchValue;
extern int joystickselected;

static NSString *configurationname;

@implementation Settings {
    NSUserDefaults *defaults;
}

- (id)init {
    if (self = [super init]) {
        defaults = [[NSUserDefaults standardUserDefaults] retain];
        [self initializeCommonSettings];
        [self initializespecificsettings];
    }
    return self;
}

- (void)initializeCommonSettings {
    
    configurationname = [[defaults stringForKey:kConfigurationNameKey] retain];
    
    BOOL isFirstInitialization = ![defaults boolForKey:kAppSettingsInitializedKey];
    
    if(isFirstInitialization)
    {
        [defaults setBool:TRUE forKey:kAppSettingsInitializedKey];
        self.autoloadConfig = TRUE;
        self.driveState = [DriveState getAllEnabled];
        [defaults setObject:@"General" forKey:kConfigurationNameKey];
    }
}

- (void)setFloppyConfigurations:(NSArray *)adfPaths {
    for (NSString *adfPath : adfPaths)
    {
        [self setFloppyConfiguration:adfPath];
    }
}

- (void)setFloppyConfiguration:(NSString *)adfPath {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", [adfPath lastPathComponent]];
    if ([defaults stringForKey:settingstring] && self.autoloadConfig )
    {
        [configurationname release];
        configurationname = [[defaults stringForKey:settingstring] retain];
        [defaults setObject:configurationname forKey:kConfigurationNameKey];
    }
}

- (void)initializespecificsettings {
    if(![self boolForKey:kInitializeKey])
    {
        self.ntsc = mainMenu_ntsc;
        self.stretchScreen = mainMenu_stretchscreen;
        self.addVerticalStretchValue = mainMenu_AddVerticalStretchValue;
        self.showStatus = mainMenu_showStatus;
        [self setBool:TRUE forKey:kInitializeKey];
    }
    else
    {
        mainMenu_ntsc = self.ntsc;
        mainMenu_stretchscreen = self.stretchScreen;
        mainMenu_AddVerticalStretchValue = self.addVerticalStretchValue;
        mainMenu_showStatus = self.showStatus;
    }
    
    //Set Default values for settings if key does not exist
    
    self.showStatusBar =            [self keyExists:kShowStatusBarKey]          ? self.showStatusBar        :   YES;
    self.selectedEffectIndex =      [self keyExists:kSelectedEffectIndexKey]    ? self.selectedEffectIndex  :   0;
    self.joypadstyle =              [self keyExists:kJoypadStyleKey]            ? self.joypadstyle          :   @"FourButton";
    self.joypadleftorright =        [self keyExists:kJoypadLeftOrRightKey]      ? self.joypadleftorright    :   @"Right";
    self.joypadshowbuttontouch =    [self keyExists:kJoypadShowButtonTouchKey]  ? self.joypadshowbuttontouch :  YES;
    
    if (![self keyExists:[NSString stringWithFormat:@"_BTN_%d", BTN_A]])
    //Set default values for JoypadKeyconfiguration
    {
    
        [self setKeyconfiguration:@"Joypad" Button:BTN_A];
        [self setKeyconfiguration:@"Joypad" Button:BTN_B];
        [self setKeyconfiguration:@"Joypad" Button:BTN_X];
        [self setKeyconfiguration:@"Joypad" Button:BTN_Y];
        [self setKeyconfiguration:@"Joypad" Button:BTN_L1];
        [self setKeyconfiguration:@"Joypad" Button:BTN_L2];
        [self setKeyconfiguration:@"Joypad" Button:BTN_R1];
        [self setKeyconfiguration:@"Joypad" Button:BTN_R2];
        [self setKeyconfiguration:@"Joypad" Button:BTN_UP];
        [self setKeyconfiguration:@"Joypad" Button:BTN_DOWN];
        [self setKeyconfiguration:@"Joypad" Button:BTN_LEFT];
        [self setKeyconfiguration:@"Joypad" Button:BTN_RIGHT];
        
        [self setKeyconfigurationname:@"Joypad" Button:BTN_A];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_B];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_X];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_Y];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_L1];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_L2];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_R1];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_R2];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_UP];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_DOWN];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_LEFT];
        [self setKeyconfigurationname:@"Joypad" Button:BTN_RIGHT];
    }
}
                          
- (BOOL)keyExists: (NSString *) key {
    return [[[defaults dictionaryRepresentation] allKeys] containsObject:[self getInternalSettingKey: key]];
}

- (BOOL)autoloadConfig {
    return [self boolForKey:kAutoloadConfigKey];
}

- (void)setAutoloadConfig:(BOOL)autoloadConfig {
    [self setBool:autoloadConfig forKey:kAutoloadConfigKey];
}

- (NSArray *)insertedFloppies {
    return [self arrayForKey:kInsertedFloppiesKey];
}

- (void)setInsertedFloppies:(NSArray *)insertedFloppies {
    [self setObject:insertedFloppies forKey:kInsertedFloppiesKey];
}

- (BOOL)ntsc {
    return [self boolForKey:kNtscKey];
}

- (void)setNtsc:(BOOL)ntsc {
    [self setBool:ntsc forKey:kNtscKey];
}

- (BOOL)stretchScreen {
    return [self boolForKey:kStretchScreenKey];
}

- (void)setStretchScreen:(BOOL)stretchScreen {
    [self setBool:stretchScreen forKey:kStretchScreenKey];
}

- (NSUInteger)addVerticalStretchValue {
    return [self integerForKey:kAddVerticalStretchKey];
}

- (void)setAddVerticalStretchValue:(NSUInteger)addVerticalStretchVal {
    [self setInteger: addVerticalStretchVal forKey:kAddVerticalStretchKey];
}

- (BOOL)showStatus {
    return [self boolForKey:kShowStatusKey];
}

- (void)setShowStatus:(BOOL)showStatus {
    [self setBool:showStatus forKey:kShowStatusKey];
}

- (NSString *)joypadstyle {
    return [self stringForKey:kJoypadStyleKey];
}

- (void)setJoypadstyle:(NSString *)joypadstyle {
    [self setObject:joypadstyle forKey:kJoypadStyleKey];
}

- (NSString *)joypadleftorright {
    return [self stringForKey:kJoypadLeftOrRightKey];
}

- (void)setJoypadleftorright:(NSString *)joypadleftorright {
    [self setObject:joypadleftorright forKey:kJoypadLeftOrRightKey];
}

- (BOOL)joypadshowbuttontouch {
    return [self boolForKey:kJoypadShowButtonTouchKey];
}

-(void)setJoypadshowbuttontouch:(BOOL)joypadshowbuttontouch {
    [self setBool:joypadshowbuttontouch forKey:kJoypadShowButtonTouchKey];
}

-(void)setKeyconfiguration:(NSString *)configuredkey Button:(int)button {
    [self setObject:configuredkey forKey:[NSString stringWithFormat:@"_BTN_%d", button]];
}

-(void)setKeyconfigurationname:(NSString *)configuredkey Button:(int)button {
    [self setObject:configuredkey forKey:[NSString stringWithFormat:@"_BTNN_%d", button]];
}

- (BOOL)showStatusBar {
    return [self boolForKey:kShowStatusBarKey];
}

- (void)setShowStatusBar:(BOOL)showStatusBar {
    [self setBool:showStatusBar forKey:kShowStatusBarKey];
}

- (NSUInteger)selectedEffectIndex {
    return [self integerForKey:kSelectedEffectIndexKey];
}

- (void)setSelectedEffectIndex:(NSUInteger)selectedEffectIndex {
    return [self setInteger:selectedEffectIndex forKey:kSelectedEffectIndexKey];
}

- (NSString *)configurationName {
    return [self stringForKey:kConfigurationNameKey];
}

- (void)setConfigurationName:(NSString *)configurationName {
    [self setObject:configurationName forKey:kConfigurationNameKey];
    [self initializespecificsettings];
}

- (NSArray *)configurations {
    return [self arrayForKey:kConfigurationsKey];
}

- (void)setConfigurations:(NSArray *)configurations {
    [self setObject:configurations forKey:kConfigurationsKey];
}

- (NSArray *)controllers {
    return [self arrayForKey:kControllersKey];
}

- (void)setControllers:(NSArray *)controllers {
    [self setObject:controllers forKey:kControllersKey];
}


- (DriveState *)driveState {
    DriveState *driveState = [[[DriveState alloc] init] autorelease];
    driveState.df1Enabled = [self boolForKey:kDf1EnabledKey];
    driveState.df2Enabled = [self boolForKey:kDf2EnabledKey];
    driveState.df3Enabled = [self boolForKey:kDf3EnabledKey];
    return driveState;
}

- (void)setDriveState:(DriveState *)driveState {
    [self setBool:driveState.df1Enabled forKey:kDf1EnabledKey];
    [self setBool:driveState.df2Enabled forKey:kDf2EnabledKey];
    [self setBool:driveState.df3Enabled forKey:kDf3EnabledKey];
}

- (BOOL)keyButtonsEnabled {
    return [self boolForKey:kKeyButtonsEnabledKey];
}

- (void)setKeyButtonsEnabled:(BOOL)keyButtonsEnabled {
    [self setBool:keyButtonsEnabled forKey:kKeyButtonsEnabledKey];
}

NSString *const kPositionAttrName = @"position";
NSString *const kSizeAttrName = @"size";
NSString *const kKeyAttrName = @"key";
NSString *const kKeyNameAttrName = @"keyname";
NSString *const kGroupNameAttrName = @"groupname";
NSString *const kShowOutlineAttrName = @"showoutline";
NSString *const kEnabledAttrName = @"enabled";

- (NSArray *)keyButtonConfigurations {
    NSString *json = [self stringForKey:kKeyButtonConfigurationsKey];
    if (!json) {
        return @[];
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSArray *dicts = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSMutableArray *keyButtonConfigurations = [[[NSMutableArray alloc] initWithCapacity:[dicts count]] autorelease];
    for (NSDictionary *dict : dicts) {
        KeyButtonConfiguration *button = [[[KeyButtonConfiguration alloc] init] autorelease];
        button.position = CGPointFromString([dict objectForKey:kPositionAttrName]);
        button.size = CGSizeFromString([dict objectForKey:kSizeAttrName]);
        button.key = (SDLKey)[[dict objectForKey:kKeyAttrName] intValue];
        button.keyName = [dict objectForKey:kKeyNameAttrName];
        button.groupName = [dict objectForKey:kGroupNameAttrName];
        button.showOutline = [[dict objectForKey:kShowOutlineAttrName] boolValue];
        button.enabled = [[dict objectForKey:kEnabledAttrName] boolValue];
        [keyButtonConfigurations addObject:button];
    }
    return keyButtonConfigurations;
}

- (void)setKeyButtonConfigurations:(NSArray *)keyButtonConfigurations {
    NSMutableArray *dicts = [NSMutableArray arrayWithCapacity:[keyButtonConfigurations count]];
    for (KeyButtonConfiguration *button in keyButtonConfigurations) {
        NSDictionary *dict = @{kPositionAttrName : NSStringFromCGPoint(button.position),
                               kSizeAttrName : NSStringFromCGSize(button.size),
                               kKeyAttrName : @(button.key),
                               kKeyNameAttrName : button.keyName,
                               kGroupNameAttrName : button.groupName,
                               kShowOutlineAttrName : @(button.showOutline),
                               kEnabledAttrName : @(button.enabled)};
        [dicts addObject:dict];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicts options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self setObject:json forKey:kKeyButtonConfigurationsKey];
}

- (void)setBool:(BOOL)value forKey:(NSString *)settingitemname {
    [defaults setBool:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (void)setObject:(id)value forKey:(NSString *)settingitemname {
    [defaults setObject:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (bool)boolForKey:(NSString *)settingitemname {
    return [defaults boolForKey:[self getInternalSettingKey:settingitemname]];
}
         
- (NSString *)stringForKey:(NSString *)settingitemname {
    return [defaults stringForKey:[self getInternalSettingKey:settingitemname]];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)settingitemname {
    [defaults setInteger:value forKey:[self getInternalSettingKey:settingitemname]];
}

- (NSInteger)integerForKey:(NSString *)settingitemname {
    return [defaults integerForKey:[self getInternalSettingKey:settingitemname]];
}

- (NSArray *)arrayForKey:(NSString *)settingitemname {
    return [defaults arrayForKey:[self getInternalSettingKey:settingitemname]];
}

- (void)removeObjectForKey:(NSString *) settingitemname {
    [defaults removeObjectForKey:[self getInternalSettingKey:settingitemname]];
}

- (NSString *)getInternalSettingKey:(NSString *)name {
    // if name starts with '_', the setting is stored in its own configuration
    return [name hasPrefix:@"_"] ? [NSString stringWithFormat:@"%@%@", configurationname, name] : name;
}

- (NSString *)configForDisk:(NSString *)diskName {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", diskName];
    return [defaults stringForKey:settingstring];
}

- (void)setConfig:(NSString *)configName forDisk:(NSString *)diskName {
    
    NSString *configstring = [NSString stringWithFormat:@"cnf%@", diskName];
    
    if([configName isEqual:@"None"])
    {
        if([self configForDisk:diskName])
        {
            [defaults setObject:nil forKey:configstring];
        }
    }
    else
    {
        [defaults setObject:configName forKey:configstring];
    }
}

- (void)dealloc {
    [defaults release];
    defaults = nil;
    [super dealloc];
}
         
@end