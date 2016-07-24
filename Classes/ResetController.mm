//  Created by Simon Toens on 10.07.15
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

#import "DiskDriveService.h"
#import "HardDriveService.h"
#import "EMUFileInfo.h"
#import "ResetController.h"

static NSString *const kSelectHardfileSegue = @"SelectHardfile";
static NSString *const kMountButtonMountLabel = @"Mount";
static NSString *const kMountButtonUnmountLabel = @"Unmount";
static NSString *const kNoHardfileText = @"Not Mounted";

@interface ResetController()
@property (readwrite, assign) IBOutlet UISwitch *df1Switch;
@property (readwrite, assign) IBOutlet UISwitch *df2Switch;
@property (readwrite, assign) IBOutlet UISwitch *df3Switch;
@property (readwrite, assign) IBOutlet UILabel *hd0Label;
@property (readwrite, assign) IBOutlet UIButton *mountButton;
@property (readwrite, retain) NSString *selectedHardfilePath;
@end

@implementation ResetController {
    DiskDriveService *_diskDriveService;
    DriveState *_driveState;
    HardDriveService *_hardDriveService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _diskDriveService = [[DiskDriveService alloc] init];
    _driveState = [[_diskDriveService getDriveState] retain];
    _hardDriveService = [[HardDriveService alloc] init];
    self.selectedHardfilePath = [_hardDriveService getMountedHardfilePath];
    [self setupDiskDriveUIState];
    [self setupHardDriveUIState];
}

- (void)setupDiskDriveUIState {
    [_df1Switch setOn:_driveState.df1Enabled];
    [_df2Switch setOn:_driveState.df2Enabled];
    [_df3Switch setOn:_driveState.df3Enabled];
}

- (void)setupHardDriveUIState {
    if (_selectedHardfilePath) {
        [_hd0Label setText:[_selectedHardfilePath lastPathComponent]];
        [_mountButton setTitle:kMountButtonUnmountLabel forState:UIControlStateNormal];
    } else {
        [_hd0Label setText:kNoHardfileText];
        [_mountButton setTitle:kMountButtonMountLabel forState:UIControlStateNormal];
    }
}

- (IBAction)onResetConfirmed {
    [self.delegate didSelectReset:_driveState hardfilePath:_selectedHardfilePath];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)toggleDF1Switch {
    _driveState.df1Enabled = _df1Switch.isOn;
}

- (IBAction)toggleDF2Switch {
    _driveState.df2Enabled = _df2Switch.isOn;
}

- (IBAction)toggleDF3Switch {
    _driveState.df3Enabled = _df3Switch.isOn;
}

- (IBAction)onMountButton {
    if (_selectedHardfilePath) {
        self.selectedHardfilePath = nil;
        [self setupHardDriveUIState];
    } else {
        [self performSegueWithIdentifier:kSelectHardfileSegue sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    EMUROMBrowserViewController *controller = segue.destinationViewController;
    controller.extensions = @[@"hdf", @"HDF"];
    controller.delegate = self;
}

- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(id)context {
    self.selectedHardfilePath = fileInfo.path;
    [self setupHardDriveUIState];
}

- (void)dealloc {
    [_diskDriveService release];
    [_driveState release];
    [_hardDriveService release];
    [_selectedHardfilePath release];
    [super dealloc];
}

@end