//
//  AddConfigurationViewController.h
//  iUAE
//
//  Created by Urs on 03.02.15.
//
//

#import <UIKit/UIKit.h>

@interface AddConfigurationViewController : UITableViewController

- (IBAction)addConfiguration:(id)sender;
- (IBAction)toggleAddConfiguration:(id)sender;

@property (readwrite, retain) IBOutlet UIButton *add;
@property (readwrite, retain) IBOutlet UITextField *name;

@end
