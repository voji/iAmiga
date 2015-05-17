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
#import "Settings.h"
#import "StateManagementController.h"

@interface SettingsGeneralController ()
@end

@implementation SettingsGeneralController {
    Settings *settings;
    NSMutableArray *Filepath;
    bool autoloadconfig;
}

static NSMutableArray *Filename;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settings = [[Settings alloc] init];
    Filepath = [[settings arrayForKey:@"insertedfloppies"] mutableCopy];
    
    autoloadconfig = [settings boolForKey:@"autoloadconfig"];
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
        
    [_df0 setText:df0title];
    [_df1 setText:df1title];
    
    [settings initializeSettings];
    
    if([settings stringForKey:@"configurationname"])
    {
        [_configurationname setText:[settings stringForKey:@"configurationname"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggleAutoloadconfig:(id)sender {
    autoloadconfig = !autoloadconfig;
    [settings setBool:autoloadconfig forKey:@"autoloadconfig"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectDisk"]) {
        UIButton *btnsender = (UIButton *) sender;
        EMUROMBrowserViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.context = btnsender;
    }
    else if([segue.identifier isEqualToString:@"loadconfiguration"])
    {
        SelectConfigurationViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"statemanagement"])
    {
        StateManagementController *stateController = segue.destinationViewController;
        stateController.emulatorScreenshot = _emulatorScreenshot;
    }
}

- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(UIButton*)sender {
    NSString *path = [fileInfo path];
    int df = sender.tag;
    
    [Filepath replaceObjectAtIndex:df withObject:path];
    [settings setObject:Filepath forKey:@"insertedfloppies"];
    
    [Filename replaceObjectAtIndex:df withObject:[NSMutableString stringWithString:[fileInfo fileName]]];
    
}

- (NSString *)getfirstoption {
    return [[NSString alloc] initWithFormat:@"General"];
}

- (BOOL)isRecentConfig:(NSString *)configurationname {
    
    if([[_configurationname text] isEqual:configurationname])
    {
        return TRUE;
    }

    return FALSE;
}

- (void)didSelectConfiguration:(NSString *)configurationname {
    [_configurationname setText:configurationname];
    [settings setObject:configurationname forKey:@"configurationname"];
}

- (void)didDeleteConfiguration {
    NSMutableArray *configurations = [[settings arrayForKey:@"configurations"] mutableCopy];
    
    if(![configurations indexOfObject:[_configurationname text]])
    {
        [_configurationname setText:@"General"];
    }
}

- (void)dealloc
{
    [_df0 release];
    [_df1 release];
    [Filepath release];
    [_configurationname release];
    [_cellconfiguration release];
    [_emulatorScreenshot release];
    
    [super dealloc];
}

@end
