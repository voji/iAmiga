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

- (void)initializeSettings {
    
    [self initializeCommonSettings];
    [self initializespecificsettings];
    
}

-(id) init {
    [super init];
    defaults = [[NSUserDefaults standardUserDefaults] retain];
    return self;
}

-(void)initializeCommonSettings {
    
    NSArray *insertedfloppies = [[defaults arrayForKey:@"insertedfloppies"] mutableCopy];
    
    BOOL appvariableinitializied = [defaults boolForKey:@"appvariableinitialized"];
    
    if(!appvariableinitializied)
    {
        [defaults setBool:TRUE forKey:@"appvariableinitialized"];
        [defaults setBool:TRUE forKey:@"autoloadconfig"];
        [defaults setObject:@"General" forKey:@"configurationname"];
    }
    
    configurationname = [defaults stringForKey:@"configurationname"];
    
    for(int i=0;i<=1;i++)
    {
        NSString *curadf = [insertedfloppies objectAtIndex:i];
        NSString *oldadf = [NSString stringWithCString:changed_df[i] encoding:[NSString defaultCStringEncoding]];
        
        if(![curadf isEqualToString:oldadf])
        {
            [curadf getCString:changed_df[i] maxLength:256 encoding:[NSString defaultCStringEncoding]];
            real_changed_df[i] = 1;
            
            NSString *settingstring = [NSString stringWithFormat:@"cnf%@", [curadf lastPathComponent]];
            
            configurationname = [defaults stringForKey:settingstring] ? [defaults stringForKey:settingstring] : configurationname;
            [defaults setObject:configurationname forKey:@"configurationname"];
        }
    }
}

-(void) initializespecificsettings {
    if(![self boolForKey:@"initialize"])
    {
        [self setBool:mainMenu_ntsc forKey:@"_ntsc"];
        [self setBool:mainMenu_stretchscreen forKey:@"_stretchscreen"];
        [self setBool:mainMenu_showStatus forKey:@"_showstatus"];
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