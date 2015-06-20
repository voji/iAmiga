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

#import "Settings.h"

static NSString *const kAppSettingsInitializedKey = @"appvariableinitialized";
static NSString *const kInitializeKey = @"_initialize";
static NSString *const kConfigurationNameKey = @"configurationname";
static NSString *const kConfigurationsKey = @"configurations";
static NSString *const kAutoloadConfigKey = @"autoloadconfig";
static NSString *const kNtscKey = @"_ntsc";
static NSString *const kStretchScreenKey = @"_stretchscreen";
static NSString *const kShowStatusKey = @"_showstatus";
static NSString *const kInsertedFloppiesKey = @"insertedfloppies";

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;
extern int joystickselected;

static NSString *configurationname;

@implementation Settings {
    NSUserDefaults *defaults;
}

- (id)init {
    if (self = [super init]) {
        defaults = [[NSUserDefaults standardUserDefaults] retain];
    }
    return self;
}

- (BOOL)initializeSettings {
    BOOL isFirstInitialization = [self initializeCommonSettings];
    [self initializespecificsettings];
    return isFirstInitialization;
}

- (BOOL)initializeCommonSettings {
    
    configurationname = [[defaults stringForKey:kConfigurationNameKey] retain];
    
    BOOL isFirstInitialization = ![defaults boolForKey:kAppSettingsInitializedKey];
    
    if(isFirstInitialization)
    {
        [defaults setBool:TRUE forKey:kAppSettingsInitializedKey];
        self.autoloadConfig = FALSE;
        [defaults setObject:@"General" forKey:kConfigurationNameKey];
    }
    return isFirstInitialization;
}

- (void)setFloppyConfigurations:(NSArray *)adfPaths {
    for (NSString *adfPath : adfPaths)
    {
        [self setFloppyConfiguration:adfPath];
    }
}

- (void)setFloppyConfiguration:(NSString *)adfPath {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", [adfPath lastPathComponent]];
    if ([defaults stringForKey:settingstring])
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
        self.showStatus = mainMenu_showStatus;
        [self setBool:TRUE forKey:kInitializeKey];
    }
    else
    {
        mainMenu_ntsc = self.ntsc;
        mainMenu_stretchscreen = self.stretchScreen;
        mainMenu_showStatus = self.showStatus;
    }
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

- (BOOL)showStatus {
    return [self boolForKey:kShowStatusKey];
}

- (void)setShowStatus:(BOOL)showStatus {
    [self setBool:showStatus forKey:kShowStatusKey];
}

- (NSString *)configurationName {
    return [self stringForKey:kConfigurationNameKey];
}

- (void)setConfigurationName:(NSString *)configurationName {
    [self setObject:configurationName forKey:kConfigurationNameKey];
}

- (NSArray *)configurations {
    return [self arrayForKey:kConfigurationsKey];
}

- (void)setConfigurations:(NSArray *)configurations {
    [self setObject:configurations forKey:kConfigurationsKey];
}

- (void)setBool:(BOOL)value forKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
    //Setting in own Configuration
    {
        [defaults setBool:value forKey:[NSString stringWithFormat:@"%@%@", configurationname, settingitemname]];
    }
    else
    //General Setting
    {
        [defaults setBool:value forKey:settingitemname];
    }
}
         
- (void)setObject:(id)value forKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        [defaults setObject:value forKey:[NSString stringWithFormat:@"%@%@", configurationname, settingitemname]];
    }
    else
        //General Setting
    {
        [defaults setObject:value forKey:settingitemname];
    }
}

- (bool)boolForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
    //Setting in own Configuration
    {
        return [defaults boolForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults boolForKey:settingitemname];
    }
}
         
- (NSString *)stringForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        return [defaults stringForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults stringForKey:settingitemname];
    }
}

- (NSArray *)arrayForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        return [defaults arrayForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults arrayForKey:settingitemname];
    }
}

- (void)removeObjectForKey:(NSString *) settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        [defaults removeObjectForKey:settingitemname];
    }
}

- (NSString *)configForDisk:(NSString *)diskName {

    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", diskName];
    return [defaults stringForKey:settingstring];
}

- (void)setConfig:(NSString *)configName forDisk:(NSString *)diskName {
    
    NSString *configstring = [NSString stringWithFormat:@"cnf%@", diskName];
    
    if([configName isEqual:@"None"]) {
        if([self configForDisk:diskName]) {
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
