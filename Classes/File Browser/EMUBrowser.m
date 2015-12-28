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

#import "EMUBrowser.h"
#import "EMUFileInfo.h"

@implementation EMUBrowser

- (NSArray *)getFileInfos {
    return [self getFileInfosWithFileNameFilter:nil];
}

- (EMUFileInfo *)getFileInfo:(NSString *)fileName {
    NSArray *fileInfo = [self getFileInfosWithFileNameFilter:fileName];
    return [fileInfo count] == 0 ? nil : [fileInfo lastObject];
}

- (NSArray *)getFileInfosWithFileNameFilter:(NSString *)fileNameFilter {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *documentFileInfos = [self getFileInfosInDirectory:documentsDirectory fileNameFilter:fileNameFilter];
    NSArray *bundleFileInfos = [self getFileInfosInDirectory:[[NSBundle mainBundle] bundlePath] fileNameFilter:fileNameFilter];
    NSMutableArray *fileInfos = [[[NSMutableArray alloc] initWithCapacity:[documentFileInfos count] + [bundleFileInfos count]] autorelease];
    [fileInfos addObjectsFromArray:documentFileInfos];
    [fileInfos addObjectsFromArray:bundleFileInfos];
    return fileInfos;
}

- (NSArray *)getFileInfosInDirectory:(NSString *)directory fileNameFilter:(NSString *)fileNameFilter {
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:directory];
    NSArray *relativeFilePaths = [[direnum allObjects] pathsMatchingExtensions:@[@"adf", @"ADF"]];
    NSMutableArray *fileInfos = [[[NSMutableArray alloc] initWithCapacity:[relativeFilePaths count]] autorelease];
    for (NSString *relativeFilePath in relativeFilePaths) {
        NSString *filePath = [directory stringByAppendingPathComponent:relativeFilePath];
        EMUFileInfo *fileInfo = [[[EMUFileInfo alloc] initFromPath:filePath] autorelease];
        if (fileNameFilter) {
            NSString *fileName = [relativeFilePath lastPathComponent];
            if ([fileName isEqualToString:fileNameFilter]) {
                return [NSArray arrayWithObject:fileInfo];
            }
        } else {
            [fileInfos addObject:fileInfo];
        }
    }
    return fileInfos;
}

@end
