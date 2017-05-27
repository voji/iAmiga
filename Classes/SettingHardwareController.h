//
//  SettingHardwareController.h
//  iUAE
//
//  Created by Urs on 03.04.17.
//
//

#import <UIKit/UIKit.h>

@interface SettingHardwareController : UITableViewController

@property (retain, nonatomic) IBOutlet UISlider *cmemslider;
@property (retain, nonatomic) IBOutlet UISlider *fmemslider;
@property (retain, nonatomic) IBOutlet UILabel *cmemlabel;
@property (retain, nonatomic) IBOutlet UILabel *fmemlabel;

- (IBAction)cMemChanged:(id)sender;
- (IBAction)fMemChanged:(id)sender;

@end
