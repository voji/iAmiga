//
//  SettingsGeneralController.h
//  iUAE
//
//  Created by Emufr3ak on 24.05.15.
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
// You should have received a copy of the GNU General Public License
//along with this program; if not, write to the Free Software
//Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import <UIKit/UIKit.h>


@protocol SelectPortDelegate
- (void)didSelectPort:(int)pNumber;
@end

@interface SettingsSelectPortViewController : UITableViewController

@property (nonatomic, assign) id<SelectPortDelegate>	delegate;
@property (retain, nonatomic) IBOutlet UITableViewCell *P0Cell;
@property (retain, nonatomic) IBOutlet UITableViewCell *P1Cell;

- (IBAction)SelectPort0:(id)sender;
- (IBAction)SelectPort1:(id)sender;

@end
