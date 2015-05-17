//
//  SettingsSelectKeyViewController.m
//  iUAE
//
//  Created by Urs on 17.05.15.
//
//

#import "SettingsSelectKeyViewController.h"
#import "IOSKeyboard.h"

@interface SettingsSelectKeyViewController ()

@end

@implementation SettingsSelectKeyViewController {
    IOSKeyboard *ioskeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ioskeyboard = [[IOSKeyboard alloc] initWithDummyFields:_dummy_textfield fieldf:_dummy_textfield_f fieldspecial:_dummy_textfield_s];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)associateKey:(id)sender {
    [ioskeyboard toggleKeyboard];
}

@end
