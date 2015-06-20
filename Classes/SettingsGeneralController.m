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

#import "DiskDriveService.h"
#import "SettingsGeneralController.h"
#import "Settings.h"
#import "StateManagementController.h"

@implementation SettingsGeneralController {
    DiskDriveService *diskDriveService;
    Settings *settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    diskDriveService = [[DiskDriveService alloc] init];
    settings = [[Settings alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [settings initializeSettings];
    [self setupUIState];
}

- (void)setupUIState {
    [self setupFloppyLabels];
    [self setupAutoloadConfigSwitch];
    [self setupConfigurationName];
}

- (void)setupFloppyLabels {
    NSString *df0AdfPath = [diskDriveService getInsertedDiskForDrive:0];
    [_df0 setText:df0AdfPath ? [df0AdfPath lastPathComponent] : @"Empty"];
    
    NSString *df1AdfPath = [diskDriveService getInsertedDiskForDrive:1];
    [_df1 setText:df1AdfPath ? [df1AdfPath lastPathComponent] : @"Empty"];
}

- (void)setupConfigurationName {
    if(settings.configurationName)
    {
        [_configurationname setText:settings.configurationName];
    }
}

- (void)setupAutoloadConfigSwitch {
    [_swautoloadconfig setOn:settings.autoloadConfig];
}

- (IBAction)toggleAutoloadconfig:(id)sender {
    settings.autoloadConfig = !settings.autoloadConfig;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectDisk"])
    {
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
    NSString *adfPath = [fileInfo path];
    int driveNumber = sender.tag;
    NSArray *floppyPaths = settings.insertedFloppies;
    NSMutableArray *mutableFloppyPaths = floppyPaths ? [[floppyPaths mutableCopy] autorelease] : [[[NSMutableArray alloc] init] autorelease];
    while ([mutableFloppyPaths count] <= driveNumber)
    {
        // pad the array if a disk is inserted into a drive with a higher number, but there's nothing in the lower number drive(s) yet
        [mutableFloppyPaths addObject:@""];
    }
    [mutableFloppyPaths replaceObjectAtIndex:driveNumber withObject:adfPath];
    settings.insertedFloppies = mutableFloppyPaths;
    [settings setFloppyConfiguration:adfPath];
    [diskDriveService insertDisk:adfPath intoDrive:driveNumber];
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

- (void)didSelectConfiguration:(NSString *)configurationName {
    [_configurationname setText:configurationName];
    settings.configurationName = configurationName;
}

- (void)didDeleteConfiguration {
    NSMutableArray *configurations = [[settings.configurations mutableCopy] autorelease];
    
    if(![configurations indexOfObject:[_configurationname text]])
    {
        [_configurationname setText:@"General"];
    }
}

- (void)dealloc {
    [diskDriveService release];
    [settings release];
    [_df0 release];
    [_df1 release];
    [_configurationname release];
    [_cellconfiguration release];
    [_emulatorScreenshot release];
    
    [super dealloc];
}

@end
