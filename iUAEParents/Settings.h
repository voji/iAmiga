//
//  Settings.h
//  iUAE
//
//  Created by Urs on 08.03.15.
//
//

#import <Foundation/Foundation.h>
#import "DriveState.h"

@protocol protReloadSettings
- (void)settingsChanged;
@end

static NSString *const kJoyStyleOneButton = @"OneButton";
static NSString *const kJoyStyleFourButton = @"FourButton";

@interface Settings : NSObject

/**
 * Properties for common settings.
 */
@property (nonatomic, readwrite, assign) BOOL autoloadConfig;
@property (nonatomic, readwrite, assign) NSArray *insertedFloppies;
@property (nonatomic, readwrite, assign) NSString *configurationName;
@property (nonatomic, readwrite, assign) NSArray *configurations;

@property (nonatomic, readwrite, assign) BOOL ntsc;
@property (nonatomic, readwrite, assign) BOOL stretchScreen;
@property (nonatomic, readwrite, assign) NSUInteger addVerticalStretchValue;
@property (nonatomic, readwrite, assign) BOOL showStatus;
@property (nonatomic, readwrite, assign) BOOL showStatusBar;
@property (nonatomic, readwrite, assign) NSUInteger selectedEffectIndex;
@property (nonatomic, readwrite, assign) DriveState *driveState;
@property (nonatomic, readwrite, assign) NSString *hardfilePath;
@property (nonatomic, readwrite, assign) NSString *joypadstyle;
@property (nonatomic, readwrite, assign) NSString *joypadleftorright;
@property (nonatomic, readwrite, assign) BOOL joypadshowbuttontouch;
@property (nonatomic, readwrite, assign) BOOL keyButtonsEnabled;
@property (nonatomic, readwrite, assign) NSArray *keyButtonConfigurations;
@property (nonatomic, readwrite, assign) NSString *dpadTouchOrMotion;
@property (nonatomic, readonly, assign) BOOL DPadModeIsTouch;
@property (nonatomic, readonly, assign) BOOL DPadModeIsMotion;
@property (nonatomic, readwrite, assign) BOOL gyroToggleUpDown;
@property (nonatomic, readwrite, assign) float gyroSensitivity;


- (void)setFloppyConfigurations:(NSArray *)adfPaths;
- (void)setFloppyConfiguration:(NSString *)adfPath;
- (void)setKeyconfiguration:(NSString *)configuredkey Button:(int)button;

- (void)setBool:(BOOL)value forKey:(NSString *)settingitemname;
- (void)setObject:(id)value forKey:(NSString *)settingitemname;
- (bool)boolForKey:(NSString *)settingitemname;
- (NSString *)stringForKey:(NSString *)settingitemname;
- (NSArray *)arrayForKey:(NSString *)settingitemname;
- (void)removeObjectForKey:(NSString *) settingitemname;
- (NSString *)configForDisk:(NSString *)diskName;
- (void)setConfig:(NSString *)configName forDisk:(NSString *)diskName;
- (NSArray *)controllers;
- (void)setControllers:(NSArray *)controllers;

@end