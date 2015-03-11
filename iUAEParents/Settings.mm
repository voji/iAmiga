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

@implementation Settings {
     NSUserDefaults *defaults;
     NSString *configurationname;
}

- (void)initializeSettings {
    
    [self initializeCommonSettings];
    [self initializespecificsettings];
    
}

- init {
    [super init];
    
    defaults = [NSUserDefaults standardUserDefaults];
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
    if(![self getsettingitembool:@"initialize"])
    {
        [self initializesettingitembool:@"_ntsc" value:mainMenu_ntsc];
        [self initializesettingitembool:@"_stretchscreeen" value:mainMenu_stretchscreen];
        [self initializesettingitembool:@"_showstatus" value:mainMenu_stretchscreen];
    }
}

- (void) initializesettingitembool:(NSString *)settingitemname value:(BOOL)value {
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
         
- (void) initializesettingitemstring:(NSString *)settingitemname value:(NSString *)value {
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
            
- (bool) getsettingitembool:(NSString *)settingitemname {
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
         
- (NSString *) getsettingitemstring:(NSString *)settingitemname {
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

- (void)dealloc
{
    [defaults release];
}
         
@end