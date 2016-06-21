/*
 Frodo, Commodore 64 emulator for the iPhone
 Copyright (C) 2007, 2008 Stuart Carnie
 See gpl.txt for license information.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "EMUROMBrowserViewController.h"
#import "EMUBrowser.h"
#import "EMUFileInfo.h"
#import "EMUFileGroup.h"

@implementation EMUROMBrowserViewController

@synthesize roms, selectedIndexPath, indexTitles, delegate, context;

+ (NSString *)getFileImportedNotificationName {
    return @"FileImportedNotification";
}

- (void)viewDidLoad {
	self.title = @"Browser";
    self.adfImporter = [[AdfImporter alloc] init];
    [self reloadAdfs];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAdfChanged)
                                                 name:[EMUROMBrowserViewController getFileImportedNotificationName]
                                               object:nil];
    
    self.indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                        @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V",
                        @"W", @"X", @"Y", @"Z", @"#"];
}

- (void)reloadAdfs {
	NSMutableArray *sections = [[NSMutableArray alloc] init];
	for (int i = 0; i < 26; i++) {
		unichar c = i+65;
		EMUFileGroup *g = [[EMUFileGroup alloc] initWithSectionName:[NSString stringWithFormat:@"%c", c]];
		[sections addObject:g];
	}
	[sections addObject:[[EMUFileGroup alloc] initWithSectionName:@"#"]];
	
	EMUBrowser *browser = [[EMUBrowser alloc] init];
    NSArray *files = [browser getFileInfosForExtensions:self.extensions];
	for (EMUFileInfo* f in files) {
		unichar c = [[f fileName] characterAtIndex:0];
		if (isdigit(c)) {
			EMUFileGroup *g = (EMUFileGroup*)[sections objectAtIndex:26];
			[g.files addObject:f];
		} else {
			c = toupper(c) - 65;
			EMUFileGroup *g = (EMUFileGroup*)[sections objectAtIndex:c];
			[g.files addObject:f];
		}
	}
	[browser release];
	self.roms = sections;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.roms.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	EMUFileGroup *g = (EMUFileGroup*)[self.roms objectAtIndex:section];
	return g.sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    unichar c = [title characterAtIndex:0];
	if (c > 64 && c < 91)
		return c - 65;
	
    return 26;
}

- (void)onAdfChanged {
    [self reloadAdfs];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	EMUFileGroup *g = (EMUFileGroup*)[self.roms objectAtIndex:section];
    return g.files.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath == selectedIndexPath)
		return;
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	cell = [tableView cellForRowAtIndexPath:indexPath];
	self.selectedIndexPath = indexPath;
		
	EMUFileGroup *g = (EMUFileGroup*)[self.roms objectAtIndex:indexPath.section];
	EMUFileInfo *fi = [g.files objectAtIndex:indexPath.row];
	[self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
		[self.delegate didSelectROM:fi withContext:context];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *editActions = [NSMutableArray arrayWithCapacity:2];
    
    EMUFileInfo *fileInfo = [self getFileInfoForIndexPath:indexPath];
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSURL *url = [NSURL fileURLWithPath:fileInfo.path];
        NSString *string = @"iAmiga File Sharing";
        UIActivityViewController *activityViewController =
            [[[UIActivityViewController alloc] initWithActivityItems:@[string, url] applicationActivities:nil] autorelease];
        if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
            // iOS8: setting the sourceView is required for iPad
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            activityViewController.popoverPresentationController.sourceView = [cell.subviews firstObject]; // firstObject == cell actions
        }
        [self presentViewController:activityViewController animated:YES completion:^{ }];
    }];
    shareAction.backgroundColor = [UIColor blueColor];
    [editActions addObject:shareAction];
    
    BOOL okToDelete = [self.adfImporter isDownloadedAdf:fileInfo.path];
    if (okToDelete) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            BOOL deleted = [[NSFileManager defaultManager] removeItemAtPath:fileInfo.path error:NULL];
            if (deleted) {
                [self reloadAdfs];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
        }];
        [editActions addObject:deleteAction];
    }
    return editActions;
}

#define CELL_ID @"DiskCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID] autorelease];
	
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
    EMUFileInfo *fileInfo = [self getFileInfoForIndexPath:indexPath];
    cell.textLabel.text = [fileInfo fileName];
	
    return cell;
}

- (EMUFileInfo *)getFileInfoForIndexPath:(NSIndexPath *)indexPath {
    EMUFileGroup *group = [self.roms objectAtIndex:indexPath.section];
    return [group.files objectAtIndex:indexPath.row];
}

- (void)dealloc {
	self.roms = nil;
	self.indexTitles = nil;
	self.selectedIndexPath = nil;
	self.context = nil;
    self.adfImporter = nil;
    self.extensions = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
