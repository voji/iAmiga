//
//  SelectEffectController.h
//  iAmiga
//
//  Created by Stuart Carnie on 1/19/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectEffectController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *effectNames;
@property (nonatomic, assign) NSUInteger selectedEffectIndex;
@property (nonatomic, strong) NSString *selectedEffectName;
@property (nonatomic, strong) IBOutlet UIPickerView *effectsPicker;

@end