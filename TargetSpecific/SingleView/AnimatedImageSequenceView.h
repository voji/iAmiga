//
//  AnimatedImageSequenceView.h
//  iAmiga
//
//  Created by Stuart Carnie on 6/23/11.
//  Copyright 2011 Manomio LLC. All rights reserved.
//
//  Changed by Emufr3ak on 29.05.14.
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

#import <UIKit/UIKit.h>

@interface FadeAction : NSObject {
    NSTimeInterval _fadeInTime;
    NSTimeInterval _holdTime;
    NSString *_imageName;
    NSTimeInterval _fadeOutTime;
    UIColor *_backgroundColor;
}

@property (nonatomic, assign) NSTimeInterval fadeInTime;
@property (nonatomic, assign) NSTimeInterval holdTime;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, assign) NSTimeInterval fadeOutTime;
@property (nonatomic, retain) UIColor *backgroundColor;

+ (FadeAction *)actionWithFadeIn:(NSTimeInterval)fadeIn holdTime:(NSTimeInterval)holdTime fadeOut:(NSTimeInterval)fadeOut forImageNamed:(NSString *)imageName;
- (id)initWithFadeIn:(NSTimeInterval)fadeIn holdTime:(NSTimeInterval)holdTime fadeOut:(NSTimeInterval)fadeOut forImageNamed:(NSString *)imageName;

@end

@protocol AnimatedImageSequenceDelegate <NSObject>

- (void)sequenceDidFinishForView:(UIView *)view;

@end

@interface AnimatedImageSequenceView : UIView {
    NSMutableArray *_sequence;
}

@property (nonatomic, retain) NSArray *sequence;
@property (nonatomic, assign) id<AnimatedImageSequenceDelegate> delegate;

- (void)startWithSequence:(NSMutableArray *)sequence;

@end
