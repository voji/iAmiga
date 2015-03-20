//
//  Settings.h
//  iUAE
//
//  Created by Urs on 08.03.15.
//
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
- (void)initializeSettings;
-(void)initializeCommonSettings;
-(void) initializespecificsettings;
- (void) setBool:(BOOL)value forKey:(NSString *)settingitemname;
- (void) setObject:(id)value forKey:(NSString *)settingitemname;
- (bool) boolForKey:(NSString *)settingitemname;
- (NSString *) stringForKey:(NSString *)settingitemname;
- (NSArray *) arrayForKey:(NSString *)settingitemname;
- (void) removeObjectForKey:(NSString *) settingitemname;
- (NSString *) configForDisk:(NSString *)diskName;
- (void) setConfig:(NSString *)configName forDisk:(NSString *)diskName;

@end