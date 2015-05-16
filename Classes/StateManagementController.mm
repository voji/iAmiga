//  Created by Simon Toens on 12.03.15
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

#import "sysconfig.h"
#import "sysdeps.h"
#import "savestate.h"

#import "State.h"
#import "StateManagementController.h"
#import "StateFileManager.h"

@implementation StateManagementController {
    @private
    StateFileManager *_stateFileManager;
    NSArray *_states;
    State *_selectedState;
    UITextField *_tableHeaderTextField;
}

# pragma mark - init/dealloc

- (void)dealloc {
    [_stateFileManager release];
    [_states release];
    [_tableHeaderTextField release];
    self.emulatorScreenshot = nil;
    [super dealloc];
}

#pragma mark - Overridden UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _saveButton.enabled = NO;
    _restoreButton.enabled = NO;
    _stateFileManager = [[StateFileManager alloc] init];
    [_stateNameTextField addTarget:self action:@selector(onStateNameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    _tableHeaderTextField = [self initTableHeadView];
    _statesTableView.tableHeaderView = _tableHeaderTextField;
    [self reloadStates];
    [self updateUIState];
}

#pragma mark - UITableViewDelegate methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // hack to get rid of empty rows in table view (also see heightForFooterInSection)
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedState = [_states objectAtIndex:indexPath.row];
    _stateNameTextField.text = _selectedState.name;
    _selectedStateScreenshot.image = _selectedState.image;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateUIState];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        State *state = [_states objectAtIndex:indexPath.row];
        [_stateFileManager deleteState:state];
        [self reloadStates];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self clearSelectedStateScreenshotImage];
        [self updateUIState];
    }
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"asfcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    State *state = [_states objectAtIndex:indexPath.row];
    cell.textLabel.text = state.name;
    cell.imageView.image = state.image;
    cell.detailTextLabel.text = state.modificationDate;
    return cell;
}

#pragma mark - Target-action methods

- (IBAction)onInfoButtonSelected {
    [self showAlertWithTitle:@"About states" message:kIssues hasCancelButton:NO hasDelegate:NO];
}

- (IBAction)onSave {
    NSString *stateName = _stateNameTextField.text;
    if (![_stateFileManager isValidStateName:stateName]) {
        [self showAlertWithTitle:@"Save" message:[NSString stringWithFormat:@"The state name '%@' is invalid", stateName] hasCancelButton:NO hasDelegate:NO];
    } else if ([_stateFileManager stateFileExistsForStateName:stateName]) {
        [self showAlertWithTitle:@"Save" message:[NSString stringWithFormat:@"State '%@' exists, overwrite?", stateName] hasCancelButton:YES hasDelegate:YES];
    } else {
        [self saveState];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // Overwrite existing state confirmation
        [self saveState];
    }
}

- (void)saveState {
    NSString *stateName = _stateNameTextField.text;
    NSString *stateFilePath = [_stateFileManager getStateFilePathForStateName:stateName];
    if (_emulatorScreenshot) {
        [_stateFileManager saveStateImage:_emulatorScreenshot forStateFilePath:stateFilePath];
    }
    [self setGlobalSaveStatePath:stateFilePath andState:STATE_DOSAVE];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRestore {
    NSString *stateFilePath = nil;
    if (_selectedState) {
        stateFilePath = _selectedState.path;
    } else {
        NSString *stateName = _stateNameTextField.text; // for some reason the user manually typed the state name to load
        if ([_stateFileManager stateFileExistsForStateName:stateName]) {
            stateFilePath = [_stateFileManager getStateFilePathForStateName:stateName];
        } else {
            [self showAlertWithTitle:@"Restore" message:[NSString stringWithFormat:@"State '%@' does not exist", stateName] hasCancelButton:NO hasDelegate:NO];
        }
    }
    if (stateFilePath) {
        [self setGlobalSaveStatePath:stateFilePath andState:STATE_DORESTORE];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private methods

- (void)setGlobalSaveStatePath:(NSString *)stateFilePath andState:(int)state {
    static char path[1024];
    [stateFilePath getCString:path maxLength:sizeof(path) encoding:[NSString defaultCStringEncoding]];
    savestate_filename = path;
    savestate_state = state;
}

- (UITextField *)initTableHeadView {
    UITextField *tableHeaderTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    tableHeaderTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    tableHeaderTextField.userInteractionEnabled = NO;
    UIFont* boldFont = [UIFont boldSystemFontOfSize:17];
    tableHeaderTextField.font = boldFont;
    return tableHeaderTextField;
}

- (void)clearSelectedStateScreenshotImage {
    _selectedStateScreenshot.image = nil;
}

- (void)onStateNameTextFieldChanged {
    _selectedState = nil;
    [self clearSelectedStateScreenshotImage];
    [self updateUIState];
}

- (void)updateUIState {
    [self updateButtonState];
    [self updateTableHeaderLabel];
}

- (void)updateTableHeaderLabel {
    if ([_states count] == 0) {
        _tableHeaderTextField.text = @"No saved states";
    } else {
        _tableHeaderTextField.text = @"Saved states";
    }
    [_statesTableView setNeedsDisplay];
}


- (void)updateButtonState {
    BOOL buttonsEnabled = [_stateNameTextField.text length] > 0;
    _saveButton.enabled = buttonsEnabled;
    _restoreButton.enabled = buttonsEnabled;
}

- (void)reloadStates {
    if (_states) {
        [_states release];
    }
    _states = [[_stateFileManager loadStates] retain];
}
    
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message hasCancelButton:(BOOL)hasCancelButton hasDelegate:(BOOL)hasDelegate {
    [[[[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:hasDelegate ? self : nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:(hasCancelButton ? @"Cancel" : nil), nil] autorelease] show];
}

static NSString *kIssues = @"- When restoring, insert the correct disk(s) first, exit settings, then re-enter settings to restore the state.\n- When saving, the state will only actually be saved when exiting from settings.";

@end