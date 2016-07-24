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
#import "VPadMotionController.h"
#import <Foundation/Foundation.h>

@interface SettingsJoypadVpadController ()

@end

@implementation SettingsJoypadVpadController {
    Settings *_settings;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    
    [_swShowButtonTouch setOn:_settings.joypadshowbuttontouch];
    [_swGyroUpDown setOn:_settings.gyroToggleUpDown];
    [_sliderGyroSensitivity setValue:_settings.gyroSensitivity];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    _Joypadstyle.detailTextLabel.text = [_settings stringForKey:@"_joypadstyle"];
    _LeftorRight.detailTextLabel.text = [_settings stringForKey:@"_joypadleftorright"];
    _DPadMode.detailTextLabel.text = _settings.dpadTouchOrMotion;
    _GyroSensitivity.textLabel.text = [NSString stringWithFormat:@"Gyro Sensitivity: %.2f",_settings.gyroSensitivity];
    
    [_GyroInfo setHidden: _settings.DPadModeIsTouch ? YES : NO];
    [_GyroCalibration setHidden: _settings.DPadModeIsTouch ? YES : NO];
    [_GyroToggleUpDown setHidden:_settings.DPadModeIsTouch ? YES : NO];
    [_GyroSensitivity setHidden:_settings.DPadModeIsTouch ? YES : NO];
    
    
    if ([_GyroInfo isHidden] == NO){

        [VPadMotionController startUpdating];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateValues:) userInfo:nil repeats:YES];

    }
    
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated {

    [VPadMotionController stopUpdating];
}

-(void) updateValues:(NSTimer *)timer{
    double refRoll = [VPadMotionController referenceAttitude].roll;
    double refPitch = [VPadMotionController referenceAttitude].pitch;
    
    double roll = [VPadMotionController getMotion].roll;
    double pitch = [VPadMotionController getMotion].pitch;
    
    _GyroInfo.detailTextLabel.text = [NSString stringWithFormat: @"Reference t/d %.2f, l/r %.2f  - current t/d %.2f, l/r %.2f",refRoll, refPitch, roll, pitch];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4)
    {
        [VPadMotionController calibrate];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if((cell == _GyroInfo || cell == _GyroCalibration || cell == _GyroToggleUpDown || cell == _GyroSensitivity) && _settings.DPadModeIsTouch)
        return 0; //set the hidden cell's height to 0
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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

- (void)didSelectVPadDirection:(NSString *)strType {
    _settings.dpadTouchOrMotion = strType;
}


- (void)toggleShowButtonTouch:(id)sender {
    _settings.joypadshowbuttontouch = !_settings.joypadshowbuttontouch;
}

- (void)toggleGyroUpDown:(id)sender{
    _settings.gyroToggleUpDown = !_settings.gyroToggleUpDown;
}

- (IBAction)gyroSensitivityChanged:(UISlider *)sender {
    _settings.gyroSensitivity = sender.value;
    _GyroSensitivity.textLabel.text = [NSString stringWithFormat:@"Gyro Sensitivity: %.2f",_settings.gyroSensitivity];
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
    else if([segue.identifier isEqualToString:@"SelectDPadMode"])
    {
        VPadTouchOrGyro *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)dealloc {
    
    [timer release];
    [_swShowButtonTouch release];
    [_settings release];
    [_Joypadstyle release];
    [_LeftorRight release];
    [_DPadMode release];
    [_GyroInfo release];
    [_GyroCalibration release];
    [_swGyroUpDown release];
    [_GyroToggleUpDown release];
    [_GyroSensitivity release];
    [_sliderGyroSensitivity release];
    [super dealloc];
}

@end
