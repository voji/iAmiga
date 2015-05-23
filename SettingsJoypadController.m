//
//  SettingsJoypadController.m
//  iUAE
//
//  Created by Urs on 14.05.15.
//
//

#import "SettingsJoypadController.h"
#import "Settings.h"

#define BTN_A 1
#define BTN_B 2

@interface SettingsJoypadController ()

@end

@implementation SettingsJoypadController {
    Settings *settings;
    UITableViewCell *context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settings = [[Settings alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [settings initializeSettings];
    
    _CellA.detailTextLabel.text = [settings stringForKey:[NSString stringWithFormat: @"_BTNN_%d", BTN_A]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectKey"]) {
        UITableViewCell *cellsender = (UITableViewCell *) sender;
        SettingsSelectKeyViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        context = cellsender;
    }
}

- (void)didselectFire {
    
    NSString *strConfigKey = [NSString stringWithFormat: @"_BTN_%d", context.tag];
    [settings setObject:@"FIRE" forKey:strConfigKey];
    
    strConfigKey = [NSString stringWithFormat: @"_BTNN_%d", context.tag];
    [settings setObject:@"FIRE" forKey:strConfigKey];
}

- (void)didSelectKey:(int)asciicode {
    
    NSString *strConfigValue = [NSString stringWithFormat: @"KEY_%d", asciicode];
    NSString *strConfigKey = [NSString stringWithFormat: @"_BTN_%d", context.tag];
    [settings setObject:strConfigValue forKey:strConfigKey];
    
    strConfigValue = [NSString stringWithFormat: @"%c", asciicode];
    strConfigKey = [NSString stringWithFormat: @"_BTNN_%d", context.tag];
    [settings setObject:strConfigValue forKey:strConfigKey];

    context.detailTextLabel.text = strConfigValue;
}

- (void)dealloc {
    [settings release];

    [_CellA release];
    [super dealloc];
}

@end
