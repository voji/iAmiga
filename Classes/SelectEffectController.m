//
//  SelectEffectController.m
//  iAmiga
//
//  Created by Stuart Carnie on 1/19/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "SelectEffectController.h"
#import "SDL.h"
#import "UIKitDisplayView.h"

@implementation SelectEffectController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_effectsPicker selectRow:_selectedEffectIndex inComponent:0 animated:YES];
    [self pickerView:_effectsPicker didSelectRow:_selectedEffectIndex inComponent:0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	return [_effectNames count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [_effectNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedEffectIndex = row;
}

- (void)dealloc {
    [_effectNames release];
    [_effectsPicker release];
    [super dealloc];
}

@end