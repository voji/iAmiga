//  Created by Simon Toens on 07.03.15
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

#import "State.h"
#import "StateFileManager.h"

static NSString *kStatesDirectoryName = @"states";
static NSString *kStateImagesDirectoryName = @"images";
static NSString *kStateFileExtension = @".asf";
static NSString *kStateFileImageExtension = @".jpg";

@implementation StateFileManager {
    @private
    NSFileManager *_fileManager;
    NSString *_documentsDirectoryPath;
    NSString *_statesDirectoryPath;
    NSString *_imagesDirectoryPath;
}

# pragma mark - init/dealloc

- (instancetype)init {
    if (self = [super init]) {
        _fileManager = [[NSFileManager defaultManager] retain];
        _documentsDirectoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] retain];
        _statesDirectoryPath = [[StateFileManager createAndGetDirectory:_fileManager rootDirectory:_documentsDirectoryPath directoryName:kStatesDirectoryName] retain];
        _imagesDirectoryPath = [[StateFileManager createAndGetDirectory:_fileManager rootDirectory:_statesDirectoryPath directoryName:kStateImagesDirectoryName] retain];
    }
    return self;
}

- (void)dealloc {
    [_fileManager release];
    [_documentsDirectoryPath release];
    [_statesDirectoryPath release];
    [_imagesDirectoryPath release];
    [super dealloc];
}

# pragma mark - Public methods

- (BOOL)stateFileExistsForStateName:(NSString *)stateName {
    NSString *stateFilePath = [self getStateFilePathForStateName:stateName];
    return [_fileManager fileExistsAtPath:stateFilePath];
}

- (NSString *)getStateFilePathForStateName:(NSString *)stateName {
    stateName = [self trimNilIfEmpty:stateName];
    return stateName ? [[_statesDirectoryPath stringByAppendingPathComponent:stateName] stringByAppendingString:kStateFileExtension] : nil;
}

- (void)saveStateImage:(UIImage *)image forStateFilePath:(NSString *)stateFilePath {
    NSString *stateName = [self getStateNameFromStateFileNameOrPath:stateFilePath];
    NSData *imageBytes = UIImageJPEGRepresentation(image, 0.5f);
    NSString *imageFilePath = [self getStateImagePathForStateName:stateName];
    [imageBytes writeToFile:imageFilePath atomically:YES];
}

- (BOOL)isValidStateName:(NSString *)stateName {
    stateName = [self trimNilIfEmpty:stateName];
    return stateName != nil;
}

- (NSArray *)loadStates {
    NSArray *stateNames = [self loadStateNames];
    NSMutableArray *states = [NSMutableArray arrayWithCapacity:[stateNames count]];
    for (NSString *stateName in stateNames) {
        [states addObject:[self loadStateForStateName:stateName]];
    }
    return states;
}

- (void)deleteState:(State *)state {
    if ([_fileManager fileExistsAtPath:state.path]) {
        [_fileManager removeItemAtPath:state.path error:NULL];
    }
    NSString *stateImagePath = [self getStateImagePathForStateName:state.name];
    if ([_fileManager fileExistsAtPath:stateImagePath]) {
        [_fileManager removeItemAtPath:stateImagePath error:NULL];
    }
}

#pragma mark - Private methods

- (State *)loadStateForStateName:(NSString *)stateName {
    NSString *stateFilePath = [self getStateFilePathForStateName:stateName];
    NSDate *creationDate = [self getFileModificationDate:stateFilePath];
    NSString *imagePath = [self getStateImagePathForStateName:stateName];
    imagePath = [_fileManager fileExistsAtPath:imagePath] ? imagePath : nil;
    return [[[State alloc] initWithName:stateName path:stateFilePath creationDate:creationDate imagePath:imagePath] autorelease];
}

- (NSArray *)loadStateNames {
    NSArray *fileNames = [_fileManager contentsOfDirectoryAtPath:_statesDirectoryPath error:NULL];
    NSMutableArray *stateNames = [NSMutableArray arrayWithCapacity:[fileNames count]];
    for (NSString *fileName in fileNames) {
        if ([self isStateFile:fileName]) {
            [stateNames addObject:[self getStateNameFromStateFileNameOrPath:fileName]];
        }
    }
    return stateNames;
}

- (NSDate *)getFileModificationDate:(NSString *)filePath {
    NSDictionary *attributes = [_fileManager attributesOfItemAtPath:filePath error:NULL];
    return [attributes objectForKey:NSFileModificationDate];
}
             
- (BOOL)isStateFile:(NSString *)fileName {
    return [fileName hasSuffix:kStateFileExtension];
}

- (NSString *)getStateImagePathForStateName:(NSString *)stateName {
    return [[_imagesDirectoryPath stringByAppendingPathComponent:stateName] stringByAppendingString:kStateFileImageExtension];
}

- (NSString *)trimNilIfEmpty:(NSString *)string {
    if (!string) {
        return nil;
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string.length == 0 ? nil : string;
}

- (NSString *)getStateNameFromStateFileNameOrPath:(NSString *)stateFilePath {
    NSString *stateFileName = [[stateFilePath pathComponents] lastObject];
    return [stateFileName substringToIndex:[stateFileName length] - [kStateFileExtension length]];
}

+ (NSString *)createAndGetDirectory:(NSFileManager *)fileManager rootDirectory:(NSString *)rootDirectory directoryName:(NSString *)directoryName {
    NSString *directoryPath = [rootDirectory stringByAppendingPathComponent:directoryName];
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return directoryPath;
}

@end