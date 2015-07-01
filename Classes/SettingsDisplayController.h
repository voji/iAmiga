//
//  SettingsDisplayController.h
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import <UIKit/UIKit.h>

@interface SettingsDisplayController : UITableViewController

- (IBAction)toggleNTSC:(id)sender;
- (IBAction)toggleStretchscreen:(id)sender;
- (IBAction)toggleShowstatus:(id)sender;

@property (readwrite, retain) IBOutlet UISwitch *ntsc;
@property (readwrite, retain) IBOutlet UISwitch *stretchscreen;
@property (readwrite, retain) IBOutlet UISwitch *showstatus;
@property (readwrite, retain) IBOutlet UILabel *selectedEffectLabel;

@end
