//
//  AddConfigurationViewController.m
//  iUAE
//
//  Created by Urs on 03.02.15.
//
//

#import "AddConfigurationViewController.h"
#import "Settings.h"

@interface AddConfigurationViewController ()

@end

@implementation AddConfigurationViewController {
    Settings *settings;
    NSMutableArray *configurations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_add setEnabled:false];
    
    settings = [[Settings alloc] init];
    
    configurations = [[settings arrayForKey:@"configurations"] mutableCopy];

    if(!configurations)
    {
        configurations = [[NSMutableArray alloc] init];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addConfiguration:(id)sender {
    NSMutableArray *test;
    
    if([configurations containsObject:_name.text] || [_name.text isEqual:@"None"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configuration Exists"
                                                        message:@"Configuration Already exists enter a new Name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    }
    else
    {
        [configurations addObject:[NSString stringWithString:_name.text]];
        [settings setObject:configurations forKey:@"configurations"];
        
        if(self.delegate)
        {
            [self.delegate configurationAdded:_name.text];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)toggleAddConfiguration:(id)sender {

    if(_name.text.length > 0)
    {
        [_add setEnabled:TRUE];
    }
    else
    {
        [_add setEnabled:FALSE];
    }
}

-(void)dealloc {
    [_add release];
    [_name release];
    [configurations release];
    [settings release];
    [super dealloc];
}

#pragma mark - Table view data source

@end
