//
//  SettingsJoypadVpadController.m
//  iUAE
//
//  Created by Emufr3ak on 05.09.15.
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

#import "SettingsJoypadVpadController.h"
#import "Settings.h"

@interface SettingsJoypadVpadController ()

@end

@implementation SettingsJoypadVpadController {
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    
    [_swShowButtonTouch setOn:_settings.joypadshowbuttontouch];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    _Joypadstyle.detailTextLabel.text = [_settings stringForKey:@"_joypadstyle"];
    _LeftorRight.detailTextLabel.text = [_settings stringForKey:@"_joypadleftorright"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectVPadPosition:(NSString *)strPosition {
    [_settings setObject:strPosition forKey:@"_joypadleftorright"];
}

- (void)didSelectVPadStyle:(NSString *)strStyle {
    [_settings setObject:strStyle forKey:@"_joypadstyle"];
}

- (void)toggleShowButtonTouch:(id)sender {
    _settings.joypadshowbuttontouch = !_settings.joypadshowbuttontouch;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectLeftOrRight"]) {
        VPadLeftOrRight *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"SelectVpadStyle"])
    {
        SettingsJoypadStyle *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)dealloc {
    
    [_swShowButtonTouch release];
    [_settings release];
    [_Joypadstyle release];
    [_LeftorRight release];

    [super dealloc];
}

@end
