//
//  SettingsGeneralController.h
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

#import <UIKit/UIKit.h>
#import "EMUROMBrowserViewController.h"
#import "SelectConfigurationViewController.h"
#import "DriveState.h"

@protocol ResetDelegate <NSObject>

- (void)didSelectReset:(DriveState *)driveState;

@end

@interface SettingsGeneralController : UITableViewController<SelectRomDelegate, SelectConfigurationDelegate>

@property (readwrite, assign) IBOutlet UILabel *romPathLabel;
@property (readwrite, assign) IBOutlet UILabel *df0PathLabel;
@property (readwrite, assign) IBOutlet UILabel *df1PathLabel;
@property (readwrite, assign) IBOutlet UISwitch *df1Switch;
@property (readwrite, assign) IBOutlet UILabel *df2PathLabel;
@property (readwrite, assign) IBOutlet UISwitch *df2Switch;
@property (readwrite, assign) IBOutlet UILabel *df3PathLabel;
@property (readwrite, assign) IBOutlet UISwitch *df3Switch;
@property (readwrite, assign) IBOutlet UILabel *hd0PathLabel;
@property (readwrite, assign) IBOutlet UISegmentedControl *hd0ReadOnlySegmentedControl;
@property (readwrite, assign) IBOutlet UISwitch *configAutoloadSwitch;
@property (readwrite, assign) IBOutlet UILabel *configNameLabel;

@property (readwrite, retain) UIImage *emulatorScreenshot;
@property (readwrite, assign) id<ResetDelegate> resetDelegate;

@end