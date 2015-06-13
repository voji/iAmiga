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
// You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "uae.h"
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"

#import "Settings.h"

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
    
    configurationname = [[defaults stringForKey:@"configurationname"] retain];
    
    BOOL isFirstInitialization = ![defaults boolForKey:@"appvariableinitialized"];
    
    if(isFirstInitialization)
    {
        [defaults setBool:TRUE forKey:@"appvariableinitialized"];
        [defaults setBool:FALSE forKey:@"autoloadconfig"];
        [defaults setObject:@"General" forKey:@"configurationname"];
    }
    return isFirstInitialization;
}

- (NSString *)getInsertedFloppyForDrive:(int)driveNumber {
    NSAssert(driveNumber >= 0 && driveNumber <= NUM_DRIVES, @"Bad drive number");
    NSString *adfPath = [NSString stringWithCString:changed_df[driveNumber] encoding:[NSString defaultCStringEncoding]];
    return [adfPath length] == 0 ? nil : adfPath;
}

- (void)insertConfiguredFloppies {
    NSArray *adfPaths = [self arrayForKey:@"insertedfloppies"];
    for (int driveNumber = 0; driveNumber < [adfPaths count]; driveNumber++)
    {
        if (driveNumber < NUM_DRIVES)
        {
            NSString *adfPath = [adfPaths objectAtIndex:driveNumber];
            if ([adfPath length] == 0) {
                continue; // placeholder item
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:adfPath isDirectory:NULL]) {
                // it is possible that the stored adf path is no longer valid - this especially happens
                // during debugging.  If that's the case, don't insert the floppy to avoid confusion
                [self insertFloppy:adfPath intoDrive:driveNumber];
            } else {
                NSLog(@"Adf does not exist: %@", adfPath);
            }
        }
        else
        {
            break;
        }
    }
}

- (void)insertFloppy:(NSString *)adfPath intoDrive:(int)driveNumber {
    NSAssert(driveNumber >= 0 && driveNumber <= NUM_DRIVES, @"Bad drive number");
    [adfPath getCString:changed_df[driveNumber] maxLength:256 encoding:[NSString defaultCStringEncoding]];
    real_changed_df[driveNumber] = 1;
    [self setFloppyConfiguration:adfPath];
}

- (void)setFloppyConfiguration:(NSString *)adfPath {
    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", [adfPath lastPathComponent]];
    if ([defaults stringForKey:settingstring])
    {
        [configurationname release];
        configurationname = [[defaults stringForKey:settingstring] retain];
        [defaults setObject:configurationname forKey:@"configurationname"];
    }
}

- (void)initializespecificsettings {
    if(![self boolForKey:@"_initialize"])
    {
        [self setBool:mainMenu_ntsc forKey:@"_ntsc"];
        [self setBool:mainMenu_stretchscreen forKey:@"_stretchscreen"];
        [self setBool:mainMenu_showStatus forKey:@"_showstatus"];
        [self setBool:TRUE forKey:@"_initialize"];
    }
    else
    {
        mainMenu_ntsc = [self boolForKey:@"_ntsc"];
        mainMenu_stretchscreen = [self boolForKey:@"_stretchscreen"];
        mainMenu_showStatus = [self boolForKey:@"_showstatus"];
    }
}

- (void) setBool:(BOOL)value forKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
    //Setting in own Configuration
    {
        [defaults setBool:value forKey:[NSString stringWithFormat:@"%@%@", configurationname, settingitemname ]];
    }
    else
    //General Setting
    {
       [defaults setBool:value forKey:[NSString stringWithFormat:@"%@", settingitemname ]];
    }
}
         
- (void) setObject:(id)value forKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        [defaults setObject:value forKey:[NSString stringWithFormat:@"%@%@", configurationname, settingitemname ]];
    }
    else
        //General Setting
    {
        [defaults setObject:value forKey:[NSString stringWithFormat:@"%@", settingitemname ]];
    }
}

- (bool) boolForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
    //Setting in own Configuration
    {
        return [defaults boolForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults boolForKey:[NSString stringWithFormat:@"%@", settingitemname]];
    }
}
         
- (NSString *) stringForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        return [defaults stringForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults stringForKey:[NSString stringWithFormat:@"%@", settingitemname]];
    }
}

- (NSArray *) arrayForKey:(NSString *)settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        return [defaults arrayForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        return [defaults arrayForKey:[NSString stringWithFormat:@"%@", settingitemname]];
    }
}

- (void) removeObjectForKey:(NSString *) settingitemname {
    if([settingitemname hasPrefix:@"_"])
        //Setting in own Configuration
    {
        [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@", configurationname,  settingitemname]];
    }
    else
    {
        [defaults removeObjectForKey:[NSString stringWithFormat:@"%@", settingitemname]];
    }
}

- (NSString *) configForDisk:(NSString *)diskName {

    NSString *settingstring = [NSString stringWithFormat:@"cnf%@", diskName];
    return [defaults stringForKey:settingstring];
}

- (void) setConfig:(NSString *)configName forDisk:(NSString *)diskName {
    
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

- (void)dealloc
{
    [defaults release];
    defaults = nil;
    [super dealloc];
}
         
@end
