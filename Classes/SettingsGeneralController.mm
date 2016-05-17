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
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "CoreSetting.h"
#import "DiskDriveService.h"
#import "HardDriveService.h"
#import "SettingsGeneralController.h"
#import "Settings.h"
#import "StateManagementController.h"
#import "cfgfile.h"
#import "filesys.h"

static NSString *const kNoDiskLabel = @"Empty";
static NSString *const kNoDiskAdfPath = @"";

static NSString *const kSelectFileSegue = @"SelectFile";
static NSString *const kAssignDiskfilesSegue = @"AssignDiskfiles";
static NSString *const kLoadConfigurationSegue = @"LoadConfiguration";
static NSString *const kKeyButtonsSegue = @"KeyButtons";
static NSString *const kStateManagementSegue = @"StateManagement";
static NSString *const kConfirmResetSegue = @"ConfirmReset";

static const NSUInteger kRomSection = 0;
static const NSUInteger kDrivesSection = 1;
static const NSUInteger kConfigSection = 2;
static const NSUInteger kMiscSection = 3;

@protocol FileSelectionContext <NSObject>
@property (nonatomic, readonly) NSArray *extensions;
@end

@interface AdfSelectionContext : NSObject <FileSelectionContext>
@property (nonatomic, assign) int driveNumber;
@end
@implementation AdfSelectionContext : NSObject
- (NSArray *)extensions {
    return @[@"ADF", @"adf"];
}
@end

@interface RomSelectionContext : NSObject <FileSelectionContext>
@end
@implementation RomSelectionContext : NSObject
- (NSArray *)extensions {
    return @[@"rom", @"ROM"];
}
@end

@implementation SettingsGeneralController {
    DiskDriveService *diskDriveService;
    HardDriveService *hardDriveService;
    RomCoreSetting *romSetting;
    Settings *settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    diskDriveService = [[DiskDriveService alloc] init];
    hardDriveService = [[HardDriveService alloc] init];
    romSetting = [[CoreSettings romCoreSetting] retain];
    settings = [[Settings alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupUIState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupUIState {
    [self setupRomLabel];
    [self setupDriveLabels];
    [self setupAutoloadConfigSwitch];
    [self setupConfigurationName];
    [self setupDriveSwitches];
}

- (void)setupDriveSwitches {
    [_df1Switch setOn:[diskDriveService enabled:1]];
    [_df2Switch setOn:[diskDriveService enabled:2]];
    [_df3Switch setOn:[diskDriveService enabled:3]];
    [_hd0Switch setOn:[hardDriveService mounted]];
}

- (void)setupDriveLabels {
    NSString *adfPath = [diskDriveService getInsertedDiskForDrive:0];
    [_df0 setText:adfPath ? [adfPath lastPathComponent] : kNoDiskLabel];
    
    adfPath = [diskDriveService getInsertedDiskForDrive:1];
    [_df1 setText:adfPath ? [adfPath lastPathComponent] : kNoDiskLabel];
    
    adfPath = [diskDriveService getInsertedDiskForDrive:2];
    [_df2 setText:adfPath ? [adfPath lastPathComponent] : kNoDiskLabel];
    
    adfPath = [diskDriveService getInsertedDiskForDrive:3];
    [_df3 setText:adfPath ? [adfPath lastPathComponent] : kNoDiskLabel];
    
    [_hd0 setText:[hardDriveService mounted] ? [[hardDriveService getMountedHardfilePath] lastPathComponent] : @""];
}

- (void)setupRomLabel {
    NSString *romPath = [diskDriveService getRomPath];
    [_rom setText:romPath ? [romPath lastPathComponent] : @""];
    [_romWarning setHidden:![romSetting hasUnappliedValue]];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kDrivesSection)
    {
        return [diskDriveService diskInsertedIntoDrive:indexPath.row];
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Eject";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == kDrivesSection)
        {
            [self.tableView setEditing:NO animated:YES];
            int driveNumber = indexPath.row;
            [self onAdfChanged:kNoDiskAdfPath drive:driveNumber];
            [diskDriveService ejectDiskFromDrive:driveNumber];
            [self setupDriveLabels];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == kRomSection || indexPath.section == kDrivesSection)
    {
        id<FileSelectionContext> ctx = nil;
        if (indexPath.section == kDrivesSection)
        {
            ctx = [[AdfSelectionContext alloc] init];
            ((AdfSelectionContext *)ctx).driveNumber = indexPath.row;
        }
        else
        {
            ctx = [[RomSelectionContext alloc] init];
        }
        [self performSegueWithIdentifier:kSelectFileSegue sender:ctx];
    }
    else if (indexPath.section == kConfigSection)
    {
        if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:kAssignDiskfilesSegue sender:nil];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:kLoadConfigurationSegue sender:nil];
        }
    }
    else if (indexPath.section == kMiscSection)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:kKeyButtonsSegue sender:nil];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:kStateManagementSegue sender:nil];
        }
        else if (indexPath.row == 2)
        {
            [self performSegueWithIdentifier:kConfirmResetSegue sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSelectFileSegue])
    {
        EMUROMBrowserViewController *controller = segue.destinationViewController;
        id<FileSelectionContext> ctx = sender;
        controller.extensions = ctx.extensions;
        controller.delegate = self;
        controller.context = ctx;
    }
    else if ([segue.identifier isEqualToString:kLoadConfigurationSegue])
    {
        SelectConfigurationViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kStateManagementSegue])
    {
        StateManagementController *stateController = segue.destinationViewController;
        stateController.emulatorScreenshot = _emulatorScreenshot;
    }
    else if ([segue.identifier isEqualToString:kConfirmResetSegue])
    {
        ResetController *resetController = segue.destinationViewController;
        resetController.delegate = self.resetDelegate;
    }
}

// SelectRomDelegate - callback when selecting an adf/rom
- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(id<FileSelectionContext>)ctx {
    NSString *path = [fileInfo path];
    if ([ctx class] == [RomSelectionContext class])
    {
        [self didReallySelectRom:path];
    }
    else
    {
        [self didSelectAdf:path context:ctx];
    }
}

- (void)didReallySelectRom:(NSString *)romPath
{
    [romSetting toggleFromOldValue:[diskDriveService getRomPath] toNewValue:romPath];
    [diskDriveService configureRom:romPath];
    [self setupRomLabel];
}

- (void)didSelectAdf:(NSString *)adfPath context:(AdfSelectionContext *)ctx {
    [self onAdfChanged:adfPath drive:ctx.driveNumber];
    [diskDriveService insertDisk:adfPath intoDrive:ctx.driveNumber];
}

- (void)onAdfChanged:(NSString *)adfPath drive:(NSUInteger)driveNumber {
    NSArray *floppyPaths = settings.insertedFloppies;
    NSMutableArray *mutableFloppyPaths = floppyPaths ?
        [[floppyPaths mutableCopy] autorelease] : [[[NSMutableArray alloc] init] autorelease];
    while ([mutableFloppyPaths count] <= driveNumber)
    {
        // pad the array if a disk is inserted into a drive with a higher number, and
        // there's nothing in the lower number drive(s) yet
        [mutableFloppyPaths addObject:kNoDiskAdfPath];
    }
    [mutableFloppyPaths replaceObjectAtIndex:driveNumber withObject:adfPath];
    settings.insertedFloppies = mutableFloppyPaths;
    [settings setFloppyConfiguration:adfPath];
}

- (NSString *)getFirstOption {
    return @"General";
}

- (BOOL)isRecentConfig:(NSString *)configurationname {    
    return [_configurationname.text isEqualToString:configurationname];
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
    [hardDriveService release];
    [romSetting release];
    [settings release];
    [_df0 release];
    [_df1 release];
    [_df2 release];
    [_df3 release];
    [_df1Switch release];
    [_df2Switch release];
    [_df3Switch release];
    [_hd0 release];
    [_configurationname release];
    [_emulatorScreenshot release];
    [super dealloc];
}

@end
