//
//  SettingHardwareController.m
//  iUAE
//
//  Created by Urs on 03.04.17.
//
//

#import "SettingHardwareController.h"
#import "CoreSetting.h"
#import "Settings.h"
#import "UnappliedSettingLabelHandler.h"

@interface SettingHardwareController ()

@end

@implementation SettingHardwareController {
    Settings *_settings;
    CMemCoreSetting *_cmem;
    FMemCoreSetting *_fmem;
    UnappliedSettingLabelHandler *_settingLabelHandler;
}

- (IBAction)cMemChanged:(id)sender {
    _cmemslider.value = (int) (_cmemslider.value + (float) 0.5);
    
    [_cmem setValue:[NSNumber numberWithFloat:_cmemslider.value*512]];
    _cmemlabel.text = [NSString stringWithFormat:@"%i KB", (int) _cmemslider.value*512];
    
    [self setupWarningLabels];
}

- (IBAction)fMemChanged:(id)sender {
    _fmemslider.value = (int) (_fmemslider.value + (float) 0.5);
    
    [_fmem setValue:[NSNumber numberWithFloat:_fmemslider.value]];
    _fmemlabel.text = [NSString stringWithFormat:@"%i MB", (int) _fmemslider.value];
    
    [self setupWarningLabels];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settings = [[Settings alloc] init];
    _settingLabelHandler = [[UnappliedSettingLabelHandler alloc] init];
    _cmem = [CMemCoreSetting getInstance];
    _fmem = [FMemCoreSetting getInstance];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_settingLabelHandler layoutLabels];
}

- (void)setupWarningLabels {
    [_settingLabelHandler updateLabelStates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float memkb = [[_cmem getValue] floatValue];
    _cmemslider.value = memkb / 512;
    _fmemslider.value = [[_fmem getValue] floatValue];
    
    _fmemlabel.text = [NSString stringWithFormat:@"%i MB", (int) _fmemslider.value];
    _cmemlabel.text = [NSString stringWithFormat:@"%i KB", (int) _cmemslider.value*512];
    
    [self setupWarningLabels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 1) // fmem
    {
        [_settingLabelHandler addResetWarningLabelForCell:cell forSetting:_fmem];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) // cmem
    {
        [_settingLabelHandler addResetWarningLabelForCell:cell forSetting:_cmem];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)dealloc {
    [_settings release];
    [_cmemslider release];
    [_fmemslider release];
    
    [_cmemlabel release];
    [_fmemlabel release];
    [super dealloc];
}

@end
