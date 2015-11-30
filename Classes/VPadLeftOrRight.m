//
//  VPadLeftOrRight.m
//  iUAE
//
//  Created by Urs on 18.09.15.
//
//

#import "VPadLeftOrRight.h"
#import "Settings.h"

@implementation VPadLeftOrRight {
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
    
    NSString *leftorright = [_settings stringForKey:@"_joypadleftorright"];
    
    _CellRight.accessoryType = [leftorright isEqualToString:@"Right"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    _CellLeft.accessoryType = [leftorright isEqualToString:@"Left"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftcheckmarkselected:(id)sender {
    [self.delegate didSelectVPadPosition:@"Left"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightcheckmarkselected:(id)sender {
    [self.delegate didSelectVPadPosition:@"Right"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [_CellLeft release];
    [_CellRight release];
    [_settings release];
    
    [super dealloc];
}

@end
