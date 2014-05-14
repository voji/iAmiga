//
//  IOSKeyboard.h
//  iAmiga
//
//  Created by Urs on 02.04.14.
//
//

#import <UIKit/UIKit.h>
#import "SDL.h"

@interface IOSKeyboard : NSObject <UITextFieldDelegate>
- (void) toggleKeyboard;
-(void) setdummyfields:(UITextField *)dummyfield fieldf:(UITextField *)fieldf;
-(id) initWithDummyFields:(UITextField *)dummyfield fieldf:(UITextField *)fieldf;
@end
