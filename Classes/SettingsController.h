//
//  SettingsController.h
//  iUAE
//
//  Created by Urs on 30.12.14.
//
//

#import <UIKit/UIKit.h>

@protocol SettingsControllerDelegate
- (void)loadSettings;
@end

@interface SettingsController : UITabBarController

@property (nonatomic, assign) id<SettingsControllerDelegate>	delegate;

@end
