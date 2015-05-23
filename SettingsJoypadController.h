//
//  SettingsJoypadController.h
//  iUAE
//
//  Created by Urs on 14.05.15.
//
//

#import <UIKit/UIKit.h>
#import "SettingsSelectKeyViewController.h"

@interface SettingsJoypadController : UITableViewController <SelectKeyDelegate>

@property (retain, nonatomic) IBOutlet UITableViewCell *CellA;



@end
