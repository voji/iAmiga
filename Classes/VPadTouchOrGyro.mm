//
//  VPadTouchOrGyro.mm
//  iUAE
//
//  Created by MrStargazer on 02.03.16.
//
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


#import "VPadTouchOrGyro.h"
#import "Settings.h"


@implementation VPadTouchOrGyro {
    Settings *_settings;
}

static NSString *const kDPadModeTouch = @"Touch";
static NSString *const kDPadModeMotion = @"Motion";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {

    _cellTouch.accessoryType = _settings.DPadModeIsTouch ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    _cellGyro.accessoryType = _settings.DPadModeIsMotion ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if  (indexPath.row == 0) {
        [self.delegate didSelectVPadDirection: kDPadModeTouch];
    }
    else if (indexPath.row == 1){
        [self.delegate didSelectVPadDirection: kDPadModeMotion];
    }
    else {
        // there should be only two rows.
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc
{
    [_cellGyro release];
    [_cellTouch release];
    [_settings release];
    [super dealloc];
}

@end
