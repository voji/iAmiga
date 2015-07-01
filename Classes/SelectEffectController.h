//
//  SelectEffectController.h
//  iAmiga
//
//  Created by Stuart Carnie on 1/19/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectEffectController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (readwrite, nonatomic) NSUInteger selectedEffectIndex;
@property (readonly, nonatomic) NSString *selectedEffectName;
@property (readwrite, nonatomic) IBOutlet UIPickerView *effectsPicker;

@end