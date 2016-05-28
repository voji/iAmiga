//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "CoreSetting.h"
#import "SelectEffectController.h"
#import "SettingsDisplayController.h"
#import "Settings.h"
#import "UnappliedSettingLabelHandler.h"

extern int mainMenu_showStatus;
extern int mainMenu_stretchscreen;
extern int mainMenu_AddVerticalStretchValue;

@implementation SettingsDisplayController {
    NSArray *_effectNames;
    SelectEffectController *_selectEffectController;
    Settings *_settings;
    NTSCEnabledCoreSetting *_ntscEnabledSetting;
    UnappliedSettingLabelHandler *_settingLabelHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _settings = [[Settings alloc] init];
    _effectNames = [@[@"None",
                      @"Scanline (50%)", @"Scanline (100%)",
                      @"Aperture 1x2 RB", @"Aperture 1x3 RB",
                      @"Aperture 2x4 RB", @"Aperture 2x4 BG"] retain];
    self.additionalVerticalStretchValue.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _ntscEnabledSetting = [[CoreSettings ntscEnabledCoreSetting] retain];
    _settingLabelHandler = [[UnappliedSettingLabelHandler alloc] init];

    [_ntsc setOn:[[_ntscEnabledSetting getValue] boolValue]];
    [_showstatus setOn:_settings.showStatus];
    [_stretchscreen setOn:_settings.stretchScreen];
    [_showstatusbar setOn:_settings.showStatusBar];
    [self handleSelectedEffect];
    [self setupWarningLabels];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_settingLabelHandler layoutLabels];
}

- (void)setupWarningLabels {
    [_settingLabelHandler updateLabelStates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 1) // ntsc
    {
        [_settingLabelHandler addResetWarningLabelForCell:cell forSetting:_ntscEnabledSetting];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_selectEffectController release];
    _selectEffectController = [segue.destinationViewController retain];
    _selectEffectController.effectNames = _effectNames;
    _selectEffectController.selectedEffectIndex = _settings.selectedEffectIndex;
}

- (IBAction)toggleNTSC:(id)sender {
    [_ntscEnabledSetting setValue:[NSNumber numberWithBool:_ntsc.isOn]];
    [self setupWarningLabels];
}

- (IBAction)toggleShowstatus:(id)sender {
    _settings.showStatus = _showstatus.isOn;
    mainMenu_showStatus = _showstatus.isOn;
    [[self view] endEditing:YES];
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
    [_ntscEnabledSetting release];
    [_settingLabelHandler release];
    [super dealloc];
}
- (IBAction)setAdditionalVerticalStretch:(id)sender {
    mainMenu_AddVerticalStretchValue = (int)[_additionalVerticalStretchValue.text doubleValue];
    _settings.addVerticalStretchValue = mainMenu_AddVerticalStretchValue;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}


@end