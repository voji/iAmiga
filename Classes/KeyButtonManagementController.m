//  Created by Simon Toens on 01.10.15
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Software Foundation, either version 2 of the
//  License, or (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "KeyButtonConfiguration.h"
#import "KeyButtonConfigurationController.h"
#import "KeyButtonManagementController.h"
#import "Settings.h"

static NSString *const kKeyButtonsEnabledCellIdent = @"KeyButtonsEnabledCell";
static NSString *const kNewKeyButtonCellIdent = @"NewKeyButtonCell";
static NSString *const kConfiguredKeyButtonCellIdent = @"ConfiguredKeyButtonCell";
static NSString *const kConfigureKeyButtonSegue = @"ConfigureKeyButtonSegue";

@implementation KeyButtonsEnabledCell
@end

@implementation ButtonViewConfigurationCell
@end

@implementation KeyButtonManagementController {
@private
    Settings *_settings;
    NSMutableArray *_buttonConfigurations;
    BOOL _initialLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _settings = [[Settings alloc] init];
    _initialLoad = YES;
    if (_settings.keyButtonsEnabled) {
        _buttonConfigurations = [[self loadButtonConfiguration] retain];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // re-render table when coming back from configuring a key button
    if (!_initialLoad) {
        [self saveButtonConfigurations];
    }
    _initialLoad = NO;
}

- (void)dealloc {
    [_settings release];
    [_buttonConfigurations release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _settings.keyButtonsEnabled ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _settings.keyButtonsEnabled ? [_buttonConfigurations count] + 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KeyButtonsEnabledCell *cell = [tableView dequeueReusableCellWithIdentifier:kKeyButtonsEnabledCellIdent];
        if (!cell) {
            cell = [[[KeyButtonsEnabledCell alloc] init] autorelease];
        }
        [cell.keyButtonsEnabledSwitch setOn:_settings.keyButtonsEnabled];
        return cell;
    }
    else if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewKeyButtonCellIdent];
        return cell ?
            cell:
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewKeyButtonCellIdent];
    } else {
        ButtonViewConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfiguredKeyButtonCellIdent];
        if (!cell) {
            cell = [[[ButtonViewConfigurationCell alloc] init] autorelease];
        }
        KeyButtonConfiguration *button = [_buttonConfigurations objectAtIndex:indexPath.row - 1];
        cell.keyNameLabel.text = button.keyName;
        [cell.showOutlineSwitch setOn:button.showOutline];
        [cell.showOutlineSwitch addTarget:button action:@selector(toggleShowOutline) forControlEvents:UIControlEventValueChanged];
        [cell.showOutlineSwitch addTarget:self action:@selector(saveButtonConfigurations) forControlEvents:UIControlEventValueChanged];
        [cell.enabledSwitch setOn:button.enabled];
        [cell.enabledSwitch addTarget:button action:@selector(toggleEnabled) forControlEvents:UIControlEventValueChanged];
        [cell.enabledSwitch addTarget:self action:@selector(saveButtonConfigurations) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 && indexPath.row != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_buttonConfigurations removeObjectAtIndex:indexPath.row - 1];
        [tableView endUpdates];
    }
    [self saveButtonConfigurations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self onAddKeyButton];
        } else {
            NSUInteger buttonViewIndex = indexPath.row - 1;
            [self performSegueWithIdentifier:kConfigureKeyButtonSegue
                                      sender:[_buttonConfigurations objectAtIndex:buttonViewIndex]];
        }
    }
}

- (IBAction)onKeyButtonsFeatureSwitchToggled:(UISwitch *)keyButtonsEnabledSwitch {
    _settings.keyButtonsEnabled = keyButtonsEnabledSwitch.isOn;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tableView beginUpdates];
    if (keyButtonsEnabledSwitch.isOn) {
        _buttonConfigurations = [[self loadButtonConfiguration] retain];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [_buttonConfigurations release];
        _buttonConfigurations = nil;
    }
    [self.tableView endUpdates];
}

- (void)onAddKeyButton {
    KeyButtonConfiguration *buttonConfiguration = [self newButtonViewConfiguration];
    [_buttonConfigurations addObject:buttonConfiguration];
    NSArray *indexPath = @[[NSIndexPath indexPathForItem:[_buttonConfigurations count] inSection:1]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self performSegueWithIdentifier:kConfigureKeyButtonSegue sender:buttonConfiguration];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(KeyButtonConfiguration *)selectedButtonViewConfiguration {
    KeyButtonConfigurationController *controller = segue.destinationViewController;
    controller.selectedButtonViewConfiguration = selectedButtonViewConfiguration;
    controller.allButtonConfigurations = _buttonConfigurations;
}

- (void)saveButtonConfigurations {
    _settings.keyButtonConfigurations = _buttonConfigurations;
}

- (NSMutableArray *)loadButtonConfiguration {
    return [NSMutableArray arrayWithArray:_settings.keyButtonConfigurations];
}

- (KeyButtonConfiguration *)newButtonViewConfiguration {
    KeyButtonConfiguration *b = [[[KeyButtonConfiguration alloc] init] autorelease];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        b.position = CGPointMake(200, 200);
        b.size = CGSizeMake(100, 100);
    } else {
        b.position = CGPointMake(100, 100);
        b.size = CGSizeMake(60, 60);
    }
    return b;
}

@end