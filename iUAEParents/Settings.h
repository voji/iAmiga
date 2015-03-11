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
- (void) initializesettingitembool:(NSString *)settingitemname value:(BOOL)value;
- (void) initializesettingitemstring:(NSString *)settingitemname value:(NSString *)value;
- (bool) getsettingitembool:(NSString *)settingitemname;
- (NSString *) getsettingitemstring:(NSString *)settingitemname;

@end