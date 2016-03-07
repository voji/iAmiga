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

<<<<<<< HEAD
=======
+ (NSString *)getAdfChangedNotificationName {
    return @"OnAdfChanged";
}

>>>>>>> 1.1.0b1
- (void)viewDidLoad {
	self.title = @"Browser";
    self.adfImporter = [[AdfImporter alloc] init];
    [self reloadAdfs];
<<<<<<< HEAD
}

- (void)reloadAdfs {
	self.indexTitles = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
						@"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V",
						@"W", @"X", @"Y", @"Z", @"#", nil];
	
=======
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAdfChanged)
                                                 name:[EMUROMBrowserViewController getAdfChangedNotificationName]
                                               object:nil];
    
    self.indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                        @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V",
                        @"W", @"X", @"Y", @"Z", @"#"];
}

- (void)reloadAdfs {
>>>>>>> 1.1.0b1
	NSMutableArray *sections = [[NSMutableArray alloc] init];
	for (int i = 0; i < 26; i++) {
		unichar c = i+65;
		EMUFileGroup *g = [[EMUFileGroup alloc] initWithSectionName:[NSString stringWithFormat:@"%c", c]];
		[sections addObject:g];
	}
	[sections addObject:[[EMUFileGroup alloc] initWithSectionName:@"#"]];
	
	EMUBrowser *browser = [[EMUBrowser alloc] init];
	NSArray *files = [browser getFileInfos];
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
	// Return YES for supported orientations
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
	//cell.accessoryType = UITableViewCellAccessoryCheckmark;
	self.selectedIndexPath = indexPath;
		
	EMUFileGroup *g = (EMUFileGroup*)[self.roms objectAtIndex:indexPath.section];
	EMUFileInfo *fi = [g.files objectAtIndex:indexPath.row];
	//[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
		[self.delegate didSelectROM:fi withContext:context];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    EMUFileInfo *fileInfo = [self getFileInfoForIndexPath:indexPath];
    return [self.adfImporter isDownloadedAdf:fileInfo.path];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMUFileInfo *fileInfo = [self getFileInfoForIndexPath:indexPath];
        BOOL deleteOk = [[NSFileManager defaultManager] removeItemAtPath:fileInfo.path error:NULL];
        if (deleteOk) {
            [self reloadAdfs];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }
    }
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
<<<<<<< HEAD
=======
    [[NSNotificationCenter defaultCenter] removeObserver:self];
>>>>>>> 1.1.0b1
	[super dealloc];
}

@end
