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

#import "ResetController.h"
#import "DiskDriveService.h"

@interface ResetController()
@property (readwrite, assign) IBOutlet UISwitch *df1Switch;
@property (readwrite, assign) IBOutlet UISwitch *df2Switch;
@property (readwrite, assign) IBOutlet UISwitch *df3Switch;
@end

@implementation ResetController {
    DiskDriveService *_diskDriveService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _diskDriveService = [[DiskDriveService alloc] init];
    _driveState = [[_diskDriveService getDriveState] retain];
    [_df1Switch setOn:_driveState.df1Enabled];
    [_df2Switch setOn:_driveState.df2Enabled];
    [_df3Switch setOn:_driveState.df3Enabled];
}

- (IBAction)onResetConfirmed {
    [self.delegate didSelectReset:_driveState];
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

- (void)dealloc {
    [_diskDriveService release];
    [super dealloc];
}

@end