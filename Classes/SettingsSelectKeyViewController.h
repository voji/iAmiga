//
//  SettingsSelectKeyViewController.h
//  iUAE
//
//  Created by Urs on 17.05.15.
//
//

#import <UIKit/UIKit.h>
#import "IOSKeyboard.h"

@protocol SelectKeyDelegate
- (void)didSelectKey:(int)asciicode;
@end

@interface SettingsSelectKeyViewController : UITableViewController <IOSKeyboardDelegate>

- (IBAction)associateKey:(id)sender;

@property (readwrite, retain) IBOutlet UITextField *dummy_textfield; // dummy text field used to display the keyboard
@property (readwrite, retain) IBOutlet UITextField  *dummy_textfield_f; //dummy textfield used to display the keyboard with function keys
@property (readwrite, retain) IBOutlet UITextField *dummy_textfield_s; //dummy textfield for special key like right shift numlock etc .....
@property (nonatomic, assign) id<SelectKeyDelegate>	delegate;

@end
