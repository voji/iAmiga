//
//  SettingsGeneralController.m
//  iUAE
//
//  Created by Emufr3ak on 29.12.14.
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

#import "SettingsGeneralController.h"
#import "Settings.h"
#import "StateManagementController.h"

@interface SettingsGeneralController ()
@end

@implementation SettingsGeneralController {
    Settings *settings;
    bool autoloadconfig;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settings = [[Settings alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *df0title = @"Empty";
    NSString *df1title = @"Empty";
    
    NSArray *floppyPaths = [settings arrayForKey:@"insertedfloppies"];
    
    if ([floppyPaths count] >= 1) {
        df0title = [[floppyPaths objectAtIndex:0] lastPathComponent];
        if ([floppyPaths count] > 1) {
            df1title = [[floppyPaths objectAtIndex:1] lastPathComponent];
        }
    }
    
    [_df0 setText:df0title];
    [_df1 setText:df1title];
    
    [settings initializeSettings];
    
    if([settings stringForKey:@"configurationname"])
    {
        [_configurationname setText:[settings stringForKey:@"configurationname"]];
    }
}

- (IBAction)toggleAutoloadconfig:(id)sender {
    autoloadconfig = !autoloadconfig;
    [settings setBool:autoloadconfig forKey:@"autoloadconfig"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectDisk"]) {
        UIButton *btnsender = (UIButton *) sender;
        EMUROMBrowserViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.context = btnsender;
    }
    else if([segue.identifier isEqualToString:@"loadconfiguration"])
    {
        SelectConfigurationViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"statemanagement"])
    {
        StateManagementController *stateController = segue.destinationViewController;
        stateController.emulatorScreenshot = _emulatorScreenshot;
    }
}

- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(UIButton*)sender {
    NSString *path = [fileInfo path];
    int df = sender.tag;
    NSMutableArray *floppyPaths = [[[settings arrayForKey:@"insertedfloppies"] mutableCopy] autorelease];
    [floppyPaths replaceObjectAtIndex:df withObject:path];
    [settings setObject:floppyPaths forKey:@"insertedfloppies"];
}

- (NSString *)getfirstoption {
    return [[NSString alloc] initWithFormat:@"General"];
}

- (BOOL)isRecentConfig:(NSString *)configurationname {
    
    if([[_configurationname text] isEqual:configurationname])
    {
        return TRUE;
    }

    return FALSE;
}

- (void)didSelectConfiguration:(NSString *)configurationname {
    [_configurationname setText:configurationname];
    [settings setObject:configurationname forKey:@"configurationname"];
}

- (void)didDeleteConfiguration {
    NSMutableArray *configurations = [[[settings arrayForKey:@"configurations"] mutableCopy] autorelease];
    
    if(![configurations indexOfObject:[_configurationname text]])
    {
        [_configurationname setText:@"General"];
    }
}

- (void)dealloc
{
    [settings release];
    [_df0 release];
    [_df1 release];
    [_configurationname release];
    [_cellconfiguration release];
    [_emulatorScreenshot release];
    
    [super dealloc];
}

@end
