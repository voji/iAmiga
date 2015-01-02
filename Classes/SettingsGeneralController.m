//
//  SettingsGeneralController.m
//  iUAE
//
//  Created by Emufr3ak on 29.12.14.
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

#import "SettingsGeneralController.h"

@interface SettingsGeneralController ()
@end

@implementation SettingsGeneralController {
}

static NSMutableArray *Filename;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *filenamedf0 = [[defaults objectForKey:@"iUAEDF0"] lastPathComponent];
    
    if(!Filename)
    {
        Filename = [[NSMutableArray alloc] init];
        if(filenamedf0)
        {
            [Filename addObject:[filenamedf0 mutableCopy]];
        }
        else
        {
            [Filename addObject:[NSMutableString new]];
        }
        [Filename addObject:[NSMutableString new]];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *df0title = [[Filename objectAtIndex:0] length] == 0 ? @"Empty" : [Filename objectAtIndex:0];
    NSString *df1title = [[Filename objectAtIndex:1] length] == 0 ? @"Empty" : [Filename objectAtIndex:1];
    
    df0title = [df0title stringByAppendingString:@"  >"];
    
    [_df0 setText:df0title];
    
    //[df1 setTitle:df1title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_df0 release];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectDisk"]) {
        UIButton *btnsender = (UIButton *) sender;
        
        EMUROMBrowserViewController *controller = (EMUROMBrowserViewController *)segue.destinationViewController;
        controller.delegate = self;
        controller.context = btnsender;
    }
}

- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(UIButton*)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [fileInfo path];
    
    int df = sender.tag;
    
    NSString *key = @"iUAEDF";
    key = [key stringByAppendingString:[NSMutableString stringWithFormat:@"%d", df]];
    
    [defaults setObject:path forKey:key];
    
    [Filename replaceObjectAtIndex:df withObject:[NSMutableString stringWithString:[fileInfo fileName]]];
    
}

@end
