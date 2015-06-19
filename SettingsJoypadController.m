//
//  SettingsGeneralController.h
//  iUAE
//
//  Created by Emufr3ak on 24.05.15.
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

#import "SettingsJoypadController.h"
#import "Settings.h"
#import "JoypadKey.h"

@interface SettingsJoypadController ()

@end

@implementation SettingsJoypadController {
    Settings *settings;
    UITableViewCell *context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settings = [[Settings alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [settings initializeSettings];
    
    _CellA.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_A]];
    _CellB.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_B]];
    _CellX.detailTextLabel.text = [settings stringForKey: [NSString stringWithFormat: @"_BTNN_%d", BTN_X]];
    _CellY.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_Y]];
    _CellL1.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_L1]];
    _CellL2.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_L2]];
    _CellR1.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_R1]];
    _CellR2.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_R2]];
    _CellUp.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_UP]];
    _CellDown.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_DOWN]];
    _CellLeft.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_LEFT]];
    _CellRight.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_RIGHT]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectKey"]) {
        UITableViewCell *cellsender = (UITableViewCell *) sender;
        SettingsSelectKeyViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        context = cellsender;
        
        NSString *strbuttonconnected = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", context.tag]];
        
        NSString *joypaddetailtext = [strbuttonconnected isEqualToString:@"Joypad"] ? @"Joypad" : @"";
        NSString *keydetailtext = [strbuttonconnected isEqualToString:@"Joypad"] ? @"" : strbuttonconnected;
        
        controller.joypaddetailtext = joypaddetailtext;
        controller.keydetailtext = keydetailtext;
        
    }
}

- (void)didSelectJoypad {
    
    NSString *strConfigKey = [NSString stringWithFormat: @"_BTN_%d", context.tag];
    [settings setObject:@"Joypad" forKey:strConfigKey];
    
    strConfigKey = [NSString stringWithFormat: @"_BTNN_%d", context.tag];
    [settings setObject:@"Joypad" forKey:strConfigKey];
    
    //context.detailTextLabel.text = @"Joypad";
}

- (void)didSelectKey:(int)asciicode keyName:(NSString *)keyName {
    
    NSString *strConfigValue = [NSString stringWithFormat: @"KEY_%d", asciicode];
    NSString *strConfigKey = [NSString stringWithFormat: @"_BTN_%d", context.tag];
    [settings setObject:strConfigValue forKey:strConfigKey];
    
    strConfigKey = [NSString stringWithFormat: @"_BTNN_%d", context.tag];
    [settings setObject:keyName forKey:strConfigKey];

    //context.detailTextLabel.text = strConfigValue;
}

- (void)dealloc {
    [settings release];

    [_CellA release];
    [_CellB release];
    [_CellX release];
    [_CellY release];
    [_CellL1 release];
    [_CellL2 release];
    [_CellR1 release];
    [_CellR2 release];
    
    [_CellUp release];
    [_CellDown release];
    [_CellLeft release];
    [_CellRight release];
    [super dealloc];
}

@end
