//
//  SingleWindowAppDelegate.h
//  iAmiga
//
//  Created by Stuart Carnie on 6/21/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//
//  Changed by Emufr3ak on 29.05.14.
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

@class BaseEmulationViewController;

@interface SingleWindowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow							*window;	
	UIWindow							*externalWindow;
}

@property (nonatomic, retain) NSMutableArray *Filename;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BaseEmulationViewController *mainController;

@end
