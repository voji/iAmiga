//
//  SettingsJoypadStyle.h
//  iUAE
//
//  Created by Urs on 18.09.15.
//
//

#import <UIKit/UIKit.h>

@protocol SelectVPadStyleDelegate
- (void)didSelectVPadStyle:(NSString *)strStyle;
@end

@interface SettingsJoypadStyle : UITableViewController

- (IBAction)onebuttonselected:(id)sender;
- (IBAction)fourbuttonselected:(id)sender;

@property (retain, nonatomic) IBOutlet UITableViewCell *CellOneButton;
@property (retain, nonatomic) IBOutlet UITableViewCell *CellFourButton;
@property (nonatomic, assign) id<SelectVPadStyleDelegate>	delegate;

@end
