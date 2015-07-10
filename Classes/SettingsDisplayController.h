//
//  SettingsDisplayController.h
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import <UIKit/UIKit.h>

@interface SettingsDisplayController : UITableViewController

@property (readwrite, retain) IBOutlet UISwitch *ntsc;
@property (readwrite, retain) IBOutlet UISwitch *stretchscreen;
@property (readwrite, retain) IBOutlet UISwitch *showstatus;
@property (readwrite, retain) IBOutlet UISwitch *showstatusbar;
@property (readwrite, retain) IBOutlet UILabel *selectedEffectLabel;

@end
