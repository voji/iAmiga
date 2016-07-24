//
//  SettingsGeneralController.h
//  iUAE
//
//  Created by Emufr3ak on 24.5.15.
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

#import "SettingsSelectPortViewController.h"
#import "Settings.h"
#import "JoypadKey.h"

@interface SettingsSelectPortViewController ()

@end

@implementation SettingsSelectPortViewController {
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated {
    
    _P0Cell.accessoryType = [[_settings keyConfigurationforButton:PORT] isEqualToString:@"0"] ? UITableViewCellAccessoryCheckmark :UITableViewCellAccessoryNone;
    
    _P1Cell.accessoryType = [[_settings keyConfigurationforButton:PORT] isEqualToString:@"1"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectPort0:(id)sender
{
    [_settings setKeyconfiguration:@"0" Button:PORT];
    [self.delegate didSelectPort:0];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)SelectPort1:(id)sender
{
    [_settings setKeyconfiguration:@"1" Button:PORT];
    [self.delegate didSelectPort:1];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{

    [_settings release];
    [_P0Cell release];
    [_P1Cell release];
    [super dealloc];
}

@end
