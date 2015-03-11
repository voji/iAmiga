//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "SettingsDisplayController.h"

@interface SettingsDisplayController ()

@end

@implementation SettingsDisplayController {
    NSUserDefaults *defaults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {

    NSString *configurationname = [[defaults stringForKey:@"configurationname"] copy];
    NSString *NTSCStretchScreen = [[defaults stringForKey:[NSString stringWithFormat:@"%@%@", configurationname, @"_stretchscreen"];
                                    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
