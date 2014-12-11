//
//  SelectHardware.m
//  iAmiga
//
//  Created by Stuart Carnie on 6/19/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "SelectHardware.h"
extern int joystickselected;

@implementation SelectHardware

- (void)viewDidLoad {
    [super viewDidLoad];
	
	controllers = [[NSMutableArray alloc] initWithObjects:
               @"iCADE",
               @"iControlPad",
               @"MFI Controller",
               nil];
	lastSelectedRow = joystickselected;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	return [controllers count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [controllers objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {	
	lastSelectedRow = row;
}

- (IBAction)done:(id)sender {
    int joystick;
    
    switch(lastSelectedRow)
    {
        case 2:
            joystick = 4;
            break;
        case 0:
            joystick = 3;
            break;
        default:
            joystick = 2;
            break;
    }
    
	[delegate didSelectHardware:joystick name:[controllers objectAtIndex:lastSelectedRow]];
	//[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDelegate:(id<SelectHardwareDelegate>)aDelegate {
	delegate = aDelegate;
}

- (void)dealloc {
    [super dealloc];
}

@end
