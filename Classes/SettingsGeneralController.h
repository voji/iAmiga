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
#import "ResetController.h"
#import "EMUROMBrowserViewController.h"
#import "SelectConfigurationViewController.h"


@interface SettingsGeneralController : UITableViewController<SelectRomDelegate, SelectConfigurationDelegate>

@property (readwrite, retain) IBOutlet UISwitch *swautoloadconfig;
@property (readwrite, retain) IBOutlet UILabel *rom;
@property (readwrite, retain) IBOutlet UILabel *romWarning;
@property (readwrite, retain) IBOutlet UILabel *df0;
@property (readwrite, retain) IBOutlet UILabel *df1;
@property (readwrite, retain) IBOutlet UILabel *df2;
@property (readwrite, retain) IBOutlet UILabel *df3;
@property (readwrite, retain) IBOutlet UISwitch *df1Switch;
@property (readwrite, retain) IBOutlet UISwitch *df2Switch;
@property (readwrite, retain) IBOutlet UISwitch *df3Switch;
@property (readwrite, retain) IBOutlet UILabel *hd0;
@property (readwrite, retain) IBOutlet UISwitch *hd0Switch;
@property (readwrite, retain) IBOutlet UILabel *configurationname;

@property (readwrite, retain) UIImage *emulatorScreenshot;
@property (readwrite, assign) id<ResetDelegate> resetDelegate;

@end