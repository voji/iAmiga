//
//  SelectConfigurationViewController.h
//  iUAE
//
//  Created by Urs on 25.01.15.
//
//

#import <UIKit/UIKit.h>
#import "AddConfigurationViewController.h"

@protocol SelectConfigurationDelegate <NSObject>
- (void)didSelectConfiguration:(NSString *)configurationname;
- (BOOL)isRecentConfig:(NSString *)configurationname;
- (void)didDeleteConfiguration;
- (NSString *)getFirstOption;
@end

@interface SelectConfigurationViewController : UITableViewController <AddConfigurationDelegate>

@property (nonatomic, assign) id<SelectConfigurationDelegate> delegate;

@end
