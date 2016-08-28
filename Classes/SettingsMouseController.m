//
//  SettingsMouseController.m
//  iUAE
//
//  Created by Urs on 08.08.16.
//
//

#import "SettingsMouseController.h"
#import "Settings.h"

@implementation SettingsMouseController {
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [_lstickSwitch setOn:_settings.LStickAnalogIsMouse];
    [_rstickSwitch setOn:_settings.RStickAnalogIsMouse];
    [_butSwitch setOn:_settings.useL2forMouseButton];
    [_rbutSwitch setOn:_settings.useR2forRightMouseButton];
    [_rstickSwitch setOn:_settings.RStickAnalogIsMouse];
    
}
- (void)dealloc {
    
    [_lstickSwitch release];
    [_rstickSwitch release];
    [super dealloc];
    
}
- (IBAction)togglerStick:(id)sender {
    _settings.RStickAnalogIsMouse = !_settings.RStickAnalogIsMouse;
}

- (IBAction)togglelStick:(id)sender {
    _settings.LStickAnalogIsMouse = !_settings.LStickAnalogIsMouse;
}

- (IBAction)togglebutSwitch:(id)sender {
    _settings.useL2forMouseButton = !_settings.useL2forMouseButton;
}

- (IBAction)togglerbutSwitch:(id)sender {
    _settings.useR2forRightMouseButton = !_settings.useR2forRightMouseButton;
}

@end
