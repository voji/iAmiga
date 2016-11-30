//
//  SettingsDisplayController.h
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import <UIKit/UIKit.h>

@interface SettingsDisplayController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UISwitch *ntsc;
@property (nonatomic, assign) IBOutlet UISwitch *stretchscreen;
@property (nonatomic, assign) IBOutlet UISwitch *showstatus;
@property (nonatomic, assign) IBOutlet UISwitch *showstatusbar;
@property (nonatomic, assign) IBOutlet UILabel *selectedEffectLabel;
@property (nonatomic, assign) IBOutlet UITextField *additionalVerticalStretchValue;
@property (nonatomic, assign) IBOutlet UISlider *volumeSlider;

@end
