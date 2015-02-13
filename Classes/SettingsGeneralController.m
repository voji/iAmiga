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
    NSUserDefaults *defaults;
    NSMutableArray *Filepath;
    bool autoloadconfig;
}

static NSMutableArray *Filename;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    Filepath = [[defaults arrayForKey:@"insertedfloppies"] mutableCopy];
    
    autoloadconfig = [defaults boolForKey:@"autoloadconfig"];
    [_swautoloadconfig setOn:autoloadconfig animated:TRUE];
    
    if(!Filepath)
    {
        Filepath = [[NSMutableArray alloc] init];
        [Filepath addObject:[NSMutableString new]];
        [Filepath addObject:[NSMutableString new]];
    }
    
    if(!Filename)
    {
        
        Filename = [[NSMutableArray alloc] init];
        
        for(int i=0;i<=1;i++)
        {
            NSString *curadf = [Filepath objectAtIndex:i];
            
            if(curadf)
            {
                [Filename addObject:[curadf lastPathComponent]];
            }
            else
            {
                    [Filename addObject:[NSMutableString new]];
            }
        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *df0title = [[Filename objectAtIndex:0] length] == 0 ? @"Empty" : [Filename objectAtIndex:0];
    NSString *df1title = [[Filename objectAtIndex:1] length] == 0 ? @"Empty" : [Filename objectAtIndex:1];
    
    df0title = [df0title stringByAppendingString:@"  >"];
    df1title = [df1title stringByAppendingString:@" >"];
    
    [_df0 setText:df0title];
    [_df1 setText:df1title];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_df0 release];
    [_df1 release];
    [Filepath release];
}

- (IBAction)toggleAutoloadconfig:(id)sender {
    autoloadconfig = !autoloadconfig;
    [defaults setBool:autoloadconfig forKey:@"autoloadconfig"];
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
    NSString *path = [fileInfo path];
    int df = sender.tag;
    
    [Filepath replaceObjectAtIndex:df withObject:path];
    [defaults setObject:Filepath forKey:@"insertedfloppies"];
    
    [Filename replaceObjectAtIndex:df withObject:[NSMutableString stringWithString:[fileInfo fileName]]];
    
}

@end
