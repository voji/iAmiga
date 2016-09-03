//  Created by Simon Toens on 22.05.16
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
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "UnappliedSettingLabelHandler.h"

/**
 * So that UILabel can be used as key.
 */
@interface LabelWrapper : NSObject <NSCopying>

- (instancetype)initWithLabel:(UILabel *)label;

@property (nonatomic, retain) UILabel *label;

@end

@implementation UnappliedSettingLabelHandler {
    @private
    NSMutableDictionary *_labelToSettingsArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _labelToSettingsArray = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addResetWarningLabelForCell:(UITableViewCell *)cell forSetting:(CoreSetting *)setting {
    [self addResetWarningLabelForCell:cell forSettings:@[setting]];
}

- (void)addResetWarningLabelForCell:(UITableViewCell *)cell forSettings:(NSArray *)settings {
    if ([settings count] == 0) {
        return;
    }
    UILabel *label = [self newWarningLabel];
    [self updateLabelState:label forSettings:settings];
    [cell addSubview:label];
    [cell bringSubviewToFront:label];
    LabelWrapper *labelWrapper = [[[LabelWrapper alloc] initWithLabel:label] autorelease];
    [_labelToSettingsArray setObject:settings forKey:labelWrapper];
}

- (void)layoutLabels {
    for (LabelWrapper *labelWrapper in [_labelToSettingsArray keyEnumerator]) {
        [self addConstraintsTo:labelWrapper.label];
    }
}

- (void)addConstraintsTo:(UILabel *)label {
    UIView *target = label.superview;
    [target addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:label.superview
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1
                                                        constant:13]];
    
    [target addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:label.superview
                                                       attribute:NSLayoutAttributeLeading
                                                      multiplier:1
                                                        constant:28]];
}

- (void)updateLabelStates {
    for (LabelWrapper *labelWrapper in [_labelToSettingsArray allKeys]) {
        NSArray *settings = [_labelToSettingsArray objectForKey:labelWrapper];
        [self updateLabelState:labelWrapper.label forSettings:settings];
    }
}

- (void)updateLabelState:(UILabel *)label forSettings:(NSArray *)settings {
    CoreSetting *setting = [self getFistSettingWithUnappliedValue:settings];
    if (!setting) {
        setting = [settings objectAtIndex:0];
    }
    [self updateLabelState:label forSetting:setting];
}

- (CoreSetting *)getFistSettingWithUnappliedValue:(NSArray *)settings {
    for (CoreSetting *setting in settings) {
        if ([setting hasUnappliedValue]) {
            return setting;
        }
    }
    return nil;
}

- (void)updateLabelState:(UILabel *)label forSetting:(CoreSetting *)setting {
    [label setHidden:![setting hasUnappliedValue]];
    label.text = [setting getModificationDescription];
}

- (UILabel *)newWarningLabel {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    return label;
}

- (void)dealloc {
    [_labelToSettingsArray release];
    [super dealloc];
}

@end

@implementation LabelWrapper {
    @private
    UILabel *_label;
}

- (instancetype)initWithLabel:(UILabel *)label {
    if (self = [super init]) {
        self.label = label;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (void)dealloc {
    self.label = nil;
    [super dealloc];
}

@end
