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

@implementation UnappliedSettingLabelHandler {
    @private
    NSMutableDictionary *_settingToLabel;
}

- (instancetype)init {
    if (self = [super init]) {
        _settingToLabel = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addResetWarningLabelForCell:(UITableViewCell *)cell forSetting:(CoreSetting *)setting {
    UILabel *label = [self newWarningLabel];
    [self updateLabelState:label forSetting:setting];
    [cell addSubview:label];
    [cell bringSubviewToFront:label];    
    [_settingToLabel setObject:label forKey:setting];
}

- (void)layoutLabels {
    for (UILabel *label in [_settingToLabel objectEnumerator]) {
        [self addConstraintsTo:label];
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
    for (CoreSetting *setting in [_settingToLabel keyEnumerator]) {
        UILabel *label = [_settingToLabel objectForKey:setting];
        [self updateLabelState:label forSetting:setting];
    }
}

- (void)updateLabelState:(UILabel *)label forSetting:(CoreSetting *)setting {
    [label setHidden:![setting hasUnappliedValue]];
    label.text = [setting getMessageForModification];
}

- (UILabel *)newWarningLabel {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    return label;
}

- (void)dealloc {
    [_settingToLabel release];
    [super dealloc];
}

@end
