//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "SettingsDisplayController.h"
#import "Settings.h"

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;

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

    [settings initializeSettings];
    [_ntsc setOn:[settings boolForKey:@"_ntsc"]];
    [_showstatus setOn:[settings boolForKey:@"_showstatus"]];
    [_stretchscreen setOn:[settings boolForKey:@"_stretchscreen"]];

}

- (void)toggleNTSC:(id)sender {
    [settings setBool:_ntsc.isOn forKey:@"_ntsc"];
    mainMenu_ntsc = _ntsc.isOn;
}

- (void)toggleShowstatus:(id)sender {
    [settings setBool:_showstatus.isOn forKey:@"_showstatus"];
    mainMenu_showStatus = _showstatus.isOn;
}

- (void)toggleStretchscreen:(id)sender {
    [settings setBool:_stretchscreen.isOn forKey:@"_stretchscreen"];
    mainMenu_stretchscreen = _stretchscreen.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [settings release];
    [super dealloc];
}

@end
