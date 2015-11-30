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

@interface SettingsJoypadVpadController : UITableViewController <SelectVpadPosDelegate, SelectVPadStyleDelegate>

@property (retain, nonatomic) IBOutlet UITableViewCell *Joypadstyle;
@property (retain, nonatomic) IBOutlet UITableViewCell *LeftorRight;

- (IBAction)toggleShowButtonTouch:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *swShowButtonTouch;

@end

