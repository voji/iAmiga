//
//  PKCustomKeyboard.h
//  PunjabiKeyboard
//
//  Created by Kulpreet Chilana on 7/19/12.
//  Copyright (c) 2012 Kulpreet Chilana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDL.h"

@interface PKCustomKeyboard : UIView <UIInputViewAudioFeedback> /*{
    UIImageView *keyboardBackground;
    UIButton *bDown;
    UIButton *bUp;
    UIButton *bLeft;
    UIButton *bRight;
    UIButton *b0;
    UIButton *b1;
    UIButton *b2;
    UIButton *b3;
    UIButton *b4;
    UIButton *b5;
    UIButton *b6;
    UIButton *b7;
    UIButton *b8;
    UIButton *b9;
    UIButton *bBracketleft;
    UIButton *bBracketright;
    UIButton *bDivide;
    UIButton *bMultiply;
    UIButton *bMinus;
    UIButton *bPlus;
    UIButton *bShiftfleft;
    UIButton *bShiftright;
    UIButton *bAltLeft;
    UIButton *bAltRight;
    UIButton *bCtrlLeft;
    UIButton *bCtrlRight;
    UIButton *bAright;
    UIButton *bAleft;
}*/

@property (strong, nonatomic) IBOutlet UIImageView *keyboardBackground;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *altButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shiftButtons;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) IBOutlet UIButton *bDown;
@property (strong, nonatomic) IBOutlet UIButton *bUp;
@property (strong, nonatomic) IBOutlet UIButton *bLeft;
@property (strong, nonatomic) IBOutlet UIButton *bRight;
@property (strong, nonatomic) IBOutlet UIButton *b0;
@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;
@property (strong, nonatomic) IBOutlet UIButton *b5;
@property (strong, nonatomic) IBOutlet UIButton *b6;
@property (strong, nonatomic) IBOutlet UIButton *b7;
@property (strong, nonatomic) IBOutlet UIButton *b8;
@property (strong, nonatomic) IBOutlet UIButton *b9;
@property (strong, nonatomic) IBOutlet UIButton *bBracketleft;
@property (strong, nonatomic) IBOutlet UIButton *bBracketright;
@property (strong, nonatomic) IBOutlet UIButton *bDivide;
@property (strong, nonatomic) IBOutlet UIButton *bMultiply;
@property (strong, nonatomic) IBOutlet UIButton *bMinus;
@property (strong, nonatomic) IBOutlet UIButton *bPlus;
@property (strong, nonatomic) IBOutlet UIButton *bShiftfleft;
@property (strong, nonatomic) IBOutlet UIButton *bShiftright;
@property (strong, nonatomic) IBOutlet UIButton *bAltLeft;
@property (strong, nonatomic) IBOutlet UIButton *bAltRight;
@property (strong, nonatomic) IBOutlet UIButton *bCtrlLeft;
@property (strong, nonatomic) IBOutlet UIButton *bCtrlRight;
@property (strong, nonatomic) IBOutlet UIButton *bAright;
@property (strong, nonatomic) IBOutlet UIButton *bAleft;
@property (strong) id<UITextInput> textView;

- (IBAction)returnPressed:(id)sender;
- (IBAction)shiftPressed:(id)sender;
- (IBAction)altPressed:(id)sender;
- (IBAction)dismissPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)characterPressed:(id)sender;
- (IBAction)unShift;

@end
