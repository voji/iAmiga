//
//  SettingsJoypadVpadController.h
//  iUAE
//
//  Created by Urs on 05.09.15.
//
//

#import <UIKit/UIKit.h>
#import "VPadLeftOrRight.h"
#import "SettingsJoypadStyle.h"
#import "VPadTouchOrGyro.h"

@interface SettingsJoypadVpadController : UITableViewController <SelectVpadPosDelegate, SelectVPadStyleDelegate, SelectVpadDirectionDelegate>

@property (retain, nonatomic) IBOutlet UITableViewCell *Joypadstyle;
@property (retain, nonatomic) IBOutlet UITableViewCell *LeftorRight;
@property (retain, nonatomic) IBOutlet UITableViewCell *DPadMode;

@property (retain, nonatomic) IBOutlet UITableViewCell *GyroInfo;
@property (retain, nonatomic) IBOutlet UITableViewCell *GyroCalibration;
@property (retain, nonatomic) IBOutlet UITableViewCell *GyroToggleUpDown;
@property (retain, nonatomic) IBOutlet UITableViewCell *GyroSensitivity;


- (IBAction)toggleShowButtonTouch:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *swShowButtonTouch;

- (IBAction)toggleGyroUpDown:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *swGyroUpDown;

- (IBAction)gyroSensitivityChanged:(UISlider *)sender;
@property (retain, nonatomic) IBOutlet UISlider *sliderGyroSensitivity;

@end

