//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "SelectEffectController.h"
#import "SettingsDisplayController.h"
#import "Settings.h"

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;

@implementation SettingsDisplayController {
    NSArray *_effectNames;
    SelectEffectController *_selectEffectController;
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _settings = [[Settings alloc] init];
    _effectNames = [@[@"None",
                      @"Scanline (50%)", @"Scanline (100%)",
                      @"Aperture 1x2 RB", @"Aperture 1x3 RB",
                      @"Aperture 2x4 RB", @"Aperture 2x4 BG"] retain];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_ntsc setOn:_settings.ntsc];
    [_showstatus setOn:_settings.showStatus];
    [_stretchscreen setOn:_settings.stretchScreen];
    [_showstatusbar setOn:_settings.showStatusBar];
    [self handleSelectedEffect];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_selectEffectController release];
    _selectEffectController = [segue.destinationViewController retain];
    _selectEffectController.effectNames = _effectNames;
    _selectEffectController.selectedEffectIndex = _settings.selectedEffectIndex;
}

- (IBAction)toggleNTSC:(id)sender {
    _settings.ntsc = _ntsc.isOn;
    mainMenu_ntsc = _ntsc.isOn;
}

- (IBAction)toggleShowstatus:(id)sender {
    _settings.showStatus = _showstatus.isOn;
    mainMenu_showStatus = _showstatus.isOn;
}

- (IBAction)toggleStretchscreen:(id)sender {
    _settings.stretchScreen = _stretchscreen.isOn;
    mainMenu_stretchscreen = _stretchscreen.isOn;
}

- (IBAction)toggleShowStatusBar {
    _settings.showStatusBar = !_settings.showStatusBar;
}

- (void)populateEffectLabel:(int)selectedEffectIndex {
    NSString *effectName = [_effectNames objectAtIndex:selectedEffectIndex];
    [_selectedEffectLabel setText:effectName];
}

- (void)handleSelectedEffect {
    int effectIndex;
    if (_selectEffectController)
    {
        effectIndex = _selectEffectController.selectedEffectIndex;
        _settings.selectedEffectIndex = effectIndex;
    }
    else
    {
        effectIndex = _settings.selectedEffectIndex;
    }
    [self populateEffectLabel:effectIndex];
}

- (void)dealloc {
    [_effectNames release];
    [_selectEffectController release];
    [_settings release];
    [super dealloc];
}

@end