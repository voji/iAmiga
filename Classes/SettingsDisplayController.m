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
    [_ntsc setOn:settings.ntsc];
    [_showstatus setOn:settings.showStatus];
    [_stretchscreen setOn:settings.stretchScreen];
}

- (void)toggleNTSC:(id)sender {
    settings.ntsc = _ntsc.isOn;
    mainMenu_ntsc = _ntsc.isOn;
}

- (void)toggleShowstatus:(id)sender {
    settings.showStatus = _showstatus.isOn;
    mainMenu_showStatus = _showstatus.isOn;
}

- (void)toggleStretchscreen:(id)sender {
    settings.stretchScreen = _stretchscreen.isOn;
    mainMenu_stretchscreen = _stretchscreen.isOn;
}

- (void)dealloc
{
    [settings release];
    [super dealloc];
}

@end
