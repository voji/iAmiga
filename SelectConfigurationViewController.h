//
//  SelectConfigurationViewController.h
//  iUAE
//
//  Created by Urs on 25.01.15.
//
//

#import <UIKit/UIKit.h>

@protocol SelectConfigurationDelegate
- (void)didSelectConfiguration:(NSString *)configurationname;
- (BOOL)isRecentConfig:(NSString *)configurationname;
@end

@interface SelectConfigurationViewController : UITableViewController

@property (nonatomic, assign) id<SelectConfigurationDelegate>	delegate;

@end
