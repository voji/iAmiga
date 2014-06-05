//
//  AnimatedImageSequenceView.m
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

#import "AnimatedImageSequenceView.h"

@implementation FadeAction

@synthesize fadeInTime=_fadeInTime, holdTime=_holdTime, imageName=_imageName, fadeOutTime=_fadeOutTime, backgroundColor=_backgroundColor;

+ (FadeAction *)actionWithFadeIn:(NSTimeInterval)fadeIn holdTime:(NSTimeInterval)holdTime fadeOut:(NSTimeInterval)fadeOut forImageNamed:(NSString *)imageName {
    return [[[FadeAction alloc] initWithFadeIn:fadeIn holdTime:holdTime fadeOut:fadeOut forImageNamed:imageName] autorelease];
}

- (id)initWithFadeIn:(NSTimeInterval)fadeIn holdTime:(NSTimeInterval)holdTime fadeOut:(NSTimeInterval)fadeOut forImageNamed:(NSString *)imageName {
    self = [super init];
    if (!self) return nil;
    
    _fadeInTime = fadeIn;
    _holdTime = holdTime;
    _fadeOutTime = fadeOut;
    self.backgroundColor = [UIColor blackColor];
    self.imageName = imageName;
    
    return self;
}

- (void)dealloc {
    self.imageName = nil;
    self.backgroundColor = nil;
    [super dealloc];
}

@end

@interface AnimatedImageSequenceView()

- (void)animateNext;

@end


@implementation AnimatedImageSequenceView

@synthesize sequence=_sequence, delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.opaque = YES;
    self.backgroundColor = [UIColor blackColor];
    
    UIImageView *view = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    view.opaque = NO;
    view.contentMode = UIViewContentModeCenter;
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                            UIViewAutoresizingFlexibleHeight |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:view];
    
    view = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    view.opaque = NO;
    view.contentMode = UIViewContentModeCenter;
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                            UIViewAutoresizingFlexibleHeight |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:view];
    
    return self;
}

- (void)startWithSequence:(NSMutableArray *)sequence {
    self.sequence = sequence;
    [self animateNext];
}

- (void)animateNext {
    if ([_sequence count] == 0) {
        [self.delegate sequenceDidFinishForView:self];
        return;
    }
    
    FadeAction *next = [_sequence objectAtIndex:0];
    NSTimeInterval holdTime = next.holdTime;
    NSTimeInterval fadeInTime = next.fadeInTime;
    
    UIImageView *bottom = [self.subviews objectAtIndex:0];
    bottom.alpha = 0.0f;
    bottom.backgroundColor = next.backgroundColor;
    bottom.image = [UIImage imageNamed:next.imageName];
    [_sequence removeObjectAtIndex:0];    
    
    UIImageView *top = [self.subviews objectAtIndex:1];
    
    [UIView animateWithDuration:fadeInTime 
                     animations:^(void) {
                         top.alpha = 0.0f;
                         bottom.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         [self insertSubview:bottom aboveSubview:top];
                         [self performSelector:@selector(animateNext) withObject:nil afterDelay:holdTime];
                     }];
}

- (void)dealloc {
    [super dealloc];
}

@end
