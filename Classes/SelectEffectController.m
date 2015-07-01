//
//  SelectEffectController.m
//  iAmiga
//
//  Created by Stuart Carnie on 1/19/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import "SelectEffectController.h"

@implementation SelectEffectController {
    NSArray *_effects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_effects = [@[@"None",
                 @"Scanline (50%)", @"Scanline (100%)",
                 @"Aperture 1x2 RB", @"Aperture 1x3 RB",
                 @"Aperture 2x4 RB", @"Aperture 2x4 BG"] retain];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_effectsPicker selectRow:_selectedEffectIndex inComponent:0 animated:YES];
    [self pickerView:_effectsPicker didSelectRow:_selectedEffectIndex inComponent:0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {	
	return [_effects count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [_effects objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedEffectIndex = row;
    _selectedEffectName = [_effects objectAtIndex:row];
}

- (void)dealloc {
    [_effects release];
    [_selectedEffectName release];
    [super dealloc];
}

@end