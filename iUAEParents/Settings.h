//
//  Settings.h
//  iUAE
//
//  Created by Urs on 08.03.15.
//
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

/**
 * Returns YES if this is the very first time the settings are initialized (meaning this must be the first time the app runs).
 */
- (BOOL)initializeSettings;


- (void) setBool:(BOOL)value forKey:(NSString *)settingitemname;
- (void) setObject:(id)value forKey:(NSString *)settingitemname;
- (bool) boolForKey:(NSString *)settingitemname;
- (NSString *) stringForKey:(NSString *)settingitemname;
- (NSArray *) arrayForKey:(NSString *)settingitemname;
- (void) removeObjectForKey:(NSString *) settingitemname;
- (NSString *) configForDisk:(NSString *)diskName;
- (void) setConfig:(NSString *)configName forDisk:(NSString *)diskName;

- (void)setFloppyConfiguration:(NSString *)adfPath;

// floppy related methods - move into their own class
- (NSString *)getInsertedFloppyForDrive:(int)driveNumber;
- (void)insertFloppy:(NSString *)adfPath intoDrive:(int)driveNumber;
- (void)insertConfiguredFloppies;

@end