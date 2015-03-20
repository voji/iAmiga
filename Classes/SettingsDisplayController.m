//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "SettingsDisplayController.h"
#import "Settings.h"

@interface SettingsDisplayController ()

@end

@implementation SettingsDisplayController {
    Settings *settings;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    settings = [[Settings alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {

    NSString *NTSCStretchScreen = [[settings stringForKey:@"_stretchscreen"] copy];
                                    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
