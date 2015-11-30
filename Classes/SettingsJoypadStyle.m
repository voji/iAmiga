//
//  SettingsJoypadStyle.m
//  iUAE
//
//  Created by Urs on 18.09.15.
//
//

#import "SettingsJoypadStyle.h"
#import "Settings.h"

@implementation SettingsJoypadStyle {
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [_settings initializeSettings];
    
    NSString *vpadstyle = [_settings stringForKey:@"_joypadstyle"];
    
    _CellOneButton.accessoryType = [vpadstyle isEqualToString:@"OneButton"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    _CellFourButton.accessoryType = [vpadstyle isEqualToString:@"FourButton"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onebuttonselected:(id)sender {
    [self.delegate didSelectVPadStyle:@"OneButton"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fourbuttonselected:(id)sender {
    [self.delegate didSelectVPadStyle:@"FourButton"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
