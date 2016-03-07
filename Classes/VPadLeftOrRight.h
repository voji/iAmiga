//
//  VPadLeftOrRight.h
//  iUAE
//
//  Created by Urs on 18.09.15.
//
//

#import <UIKit/UIKit.h>

@protocol SelectVpadPosDelegate
- (void)didSelectVPadPosition:(NSString *)strPosition;
@end

@interface VPadLeftOrRight : UITableViewController

- (IBAction)leftcheckmarkselected:(id)sender;
- (IBAction)rightcheckmarkselected:(id)sender;

@property (retain, nonatomic) IBOutlet UITableViewCell *CellLeft;
@property (retain, nonatomic) IBOutlet UITableViewCell *CellRight;
@property (nonatomic, assign) id<SelectVpadPosDelegate>	delegate;


@end

