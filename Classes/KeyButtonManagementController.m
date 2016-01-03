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

static NSString *const kTitleCellIdent = @"TitleCell";
static NSString *const kButtonViewConfigurationCellIdent = @"ButtonViewConfigurationCell";
static NSString *const kConfigureKeySegue = @"ConfigureKeySegue";

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
    _buttonConfigurations = [[NSMutableArray arrayWithArray:_settings.buttonViewConfigurations] retain];
    _initialLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // re-render table when coming back from configuring a button view
    if (!_initialLoad) {
        [self saveButtonViewConfigurations];
    }
    _initialLoad = NO;
}

- (void)dealloc {
    [_settings release];
    [_buttonConfigurations release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_buttonConfigurations count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Mapped Keys";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellIdent];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTitleCellIdent];
        }
        return cell;
    } else {
        ButtonViewConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonViewConfigurationCellIdent];
        if (!cell) {
            cell = [[[ButtonViewConfigurationCell alloc] init] autorelease];
        }
        KeyButtonConfiguration *button = [_buttonConfigurations objectAtIndex:row - 1];
        cell.keyNameLabel.text = button.keyName;
        [cell.showOutlineSwitch setOn:button.showOutline];
        [cell.showOutlineSwitch addTarget:button action:@selector(toggleShowOutline) forControlEvents:UIControlEventValueChanged];
        [cell.showOutlineSwitch addTarget:self action:@selector(saveButtonViewConfigurations) forControlEvents:UIControlEventValueChanged];
        [cell.enabledSwitch setOn:button.enabled];
        [cell.enabledSwitch addTarget:button action:@selector(toggleEnabled) forControlEvents:UIControlEventValueChanged];
        [cell.enabledSwitch addTarget:self action:@selector(saveButtonViewConfigurations) forControlEvents:UIControlEventValueChanged];
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
    [self saveButtonViewConfigurations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self onAddButtonView];
        } else {
            NSUInteger buttonViewIndex = indexPath.row - 1;
            [self performSegueWithIdentifier:kConfigureKeySegue sender:[_buttonConfigurations objectAtIndex:buttonViewIndex]];
        }
    }
}

- (void)onAddButtonView {
    KeyButtonConfiguration *buttonConfiguration = [self newButtonViewConfiguration];
    [_buttonConfigurations addObject:buttonConfiguration];
    NSArray *indexPath = @[[NSIndexPath indexPathForItem:[_buttonConfigurations count] inSection:1]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self performSegueWithIdentifier:kConfigureKeySegue sender:buttonConfiguration];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(KeyButtonConfiguration *)selectedButtonViewConfiguration {
    KeyButtonConfigurationController *controller = segue.destinationViewController;
    controller.selectedButtonViewConfiguration = selectedButtonViewConfiguration;
    controller.allButtonConfigurations = _buttonConfigurations;
}

- (void)saveButtonViewConfigurations {
    _settings.buttonViewConfigurations = _buttonConfigurations;
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