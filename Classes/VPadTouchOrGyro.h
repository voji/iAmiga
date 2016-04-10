//
//  VPadTouchOrGyro.h
//  iUAE
//
//  Created by MrStargazer on 02.03.16.
//
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

#import <UIKit/UIKit.h>


@protocol SelectVpadDirectionDelegate
- (void)didSelectVPadDirection:(NSString *)strType;
@end

@interface VPadTouchOrGyro : UITableViewController

@property (retain, nonatomic) IBOutlet UITableViewCell *cellTouch;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellGyro;



@property (nonatomic, assign) id<SelectVpadDirectionDelegate>	delegate;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
