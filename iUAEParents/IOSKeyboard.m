//  Created by Emufr3ak on 29.05.14.
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

#import "IOSKeyboard.h"

#define KEYDOWN 1
#define KEYUP 2
#define KEYPRESS 3

#define SDLK_PERCENT 37
#define SDLK_LEFTBRACES 123
#define SDLK_PIPE 124
#define SDLK_RIGHTBRACES 125
#define SDLK_TILDE 126


#define SDLK_POUND 163
#define SDLK_DOPPELS 223
#define SDLK_AUMLAUT 228
#define SDLK_OUMLAUT 246
#define SDLK_UUMLAUT 252

#define SDLK_LAMIGA 257
#define SDLK_RAMIGA 258

#define BFKEY 1
#define BSKEY 2


@implementation IOSKeyboard {
    
    bool keyboardactive;
    bool shiftselected;
    bool altselected;
    bool ctrlselected;
    bool lAselected;
    bool rAselected;
    bool fkeyselected;
    bool skeyselected;
    
    UIButton *btnKeyboard;
    UIButton *btnSettings;
    
    UIButton *arrowleft_btnd;
    UIButton *arrowup_btnd;
    UIButton *arrowdown_btnd;
    UIButton *arrowright_btnd;
    
    UIButton *fKey_btnd;
    UIButton *sKey_btnd;
    
    UITextField        *dummy_textfield; // dummy text field used to display the keyboard
    UITextField *dummy_textfield_f; //dummy textfield used to display the keyboard with function keys
 
    UITextField *dummy_textfield_s;
    
    PKCustomKeyboard *specialkeyboardipad;
    PMCustomKeyboard *specialckeyboardiphone;
}

-(void) toggleKeyboard {
    /* Turn Keyboard visibility on and off */
    
    keyboardactive = !keyboardactive;
    
    if (keyboardactive) {
        [dummy_textfield becomeFirstResponder];
    }
    else
    {
        [dummy_textfield resignFirstResponder];
        [dummy_textfield_f resignFirstResponder];
        [dummy_textfield_s resignFirstResponder];
        fkeyselected = FALSE;
        skeyselected = FALSE;
    }
    
}

- (IBAction)toggleKeyboardmode:(id)sender {
    
    UIButton *button = sender;
    
    [dummy_textfield resignFirstResponder];
    [dummy_textfield_f resignFirstResponder];
    [dummy_textfield_s resignFirstResponder];
    
    fkeyselected = (button.tag == BFKEY) ? !fkeyselected : FALSE;
    skeyselected = (button.tag == BSKEY) ? !skeyselected : FALSE;
    
    if (fkeyselected)
    {
        [dummy_textfield_f becomeFirstResponder];
    }
    else if (skeyselected)
    {
        [dummy_textfield_s becomeFirstResponder];
    }
    else
    {
        [dummy_textfield becomeFirstResponder];
    }
}

- (IBAction)toggleCtrlKey:(id)sender {
    
    /* Presse / Release Ctrl Key */
    
    if (!ctrlselected)
    {
        ctrlselected = TRUE;
        [self setButtonSelected:sender];
        [self sendkey:SDLK_LCTRL direction:KEYDOWN];
    }
    else
    {
        ctrlselected = FALSE;
        [self setButtonUnselected:sender];
        [self sendkey:SDLK_LCTRL direction:KEYUP];
    }
}

- (IBAction)toggleShiftKey:(id)sender {
    
    /* Presse / Release Shift Key */
    
    if (!shiftselected)
    {
        shiftselected = TRUE;
        [self setButtonSelected:sender];
        [self sendkey:SDLK_LSHIFT direction:KEYDOWN];
    }
    else
    {
        shiftselected = FALSE;
        [self setButtonUnselected:sender];
        [self sendkey:SDLK_LSHIFT direction:KEYUP];
    }
}

- (IBAction)toggleAltKey:(id)sender {
    
    /* Presse / Release Alt Key */
    
    if (!altselected)
    {
        altselected = TRUE;
        [self setButtonSelected:sender];
        [self sendkey:SDLK_LALT direction:KEYDOWN];
    }
    else
    {
        altselected = FALSE;
        [self setButtonUnselected:sender];
        [self sendkey:SDLK_LALT direction:KEYUP];
    }
}

- (IBAction)togglelAKey:(id)sender {
    if (!lAselected)
    {
        lAselected = TRUE;
        [self setButtonSelected:sender];
        [self sendkey:SDLK_PAGEDOWN direction:KEYDOWN];
    }
    else
    {
        lAselected = FALSE;
        [self setButtonUnselected:sender];
        [self sendkey:SDLK_PAGEDOWN direction:KEYUP];
    }
}

- (IBAction)togglerAKey:(id)sender {
    if (!rAselected)
    {
        rAselected = TRUE;
        [self setButtonSelected:sender];
        [self sendkey:SDLK_PAGEUP direction:KEYDOWN];
    }
    else
    {
        rAselected = FALSE;
        [self setButtonUnselected:sender];
        [self sendkey:SDLK_PAGEUP direction:KEYUP];
    }
}

- (IBAction)toggleEscKey:(id)sender {
    [self sendkey:SDLK_ESCAPE];
}

//Catches Enter
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendkey:SDLK_RETURN];
    return NO;
}

- (IBAction)F1Key:(id)sender {
    [self sendkey:SDLK_F1];
}

- (IBAction)F2Key:(id)sender {
    [self sendkey:SDLK_F2];
}

- (IBAction)F3Key:(id)sender {
    [self sendkey:SDLK_F3];
}

- (IBAction)F4Key:(id)sender {
    [self sendkey:SDLK_F4];
}

- (IBAction)F5Key:(id)sender {
    [self sendkey:SDLK_F5];
}

- (IBAction)F6Key:(id)sender {
    [self sendkey:SDLK_F6];
}

- (IBAction)F7Key:(id)sender {
    [self sendkey:SDLK_F7];
}

- (IBAction)F8Key:(id)sender {
    [self sendkey:SDLK_F8];
}

- (IBAction)F9Key:(id)sender {
    [self sendkey:SDLK_F9];
}

- (IBAction)F10Key:(id)sender {
    [self sendkey:SDLK_F10];
}

- (IBAction)CursorKeyPressed:(id)sender {
    
    UIButton *button = sender;
    
    int keypressed =    (button == arrowup_btnd) ? SDLK_UP :
                        (button == arrowdown_btnd) ? SDLK_DOWN :
                        (button == arrowleft_btnd) ? SDLK_LEFT :
                        SDLK_RIGHT;

    
    [self sendkey:keypressed];

}

- (IBAction)specialkeypressed:(id)sender
{
    UITextField *textfield = [sender object];
    
    NSString *keyflag = [textfield.text substringToIndex:1];
    int asciicode = [[textfield.text substringFromIndex:1] intValue];
    
    if([keyflag isEqual: @"D"])
    {
        [self sendkey:asciicode direction:KEYDOWN];
    }
    else
    {
        [self sendkey:asciicode direction:KEYUP];
    }
    
    [textfield setText:@""];
}

- (IBAction)keypressed:(id)sender
{
    /* Get String */
    UITextField *textfield = [sender object];
    NSMutableString *inputstring = [[textfield text] mutableCopy];
    NSUInteger length = inputstring.length;
    
    //Backspace Pressed: Little Hack: Length is always 1 because one character is autoplaced there (expect when deleted by backspace)
    if(length == 0)
    {
        [self sendkey:SDLK_BACKSPACE];
        [textfield setText:@"0"];
        return;
    }
    
    //Send Asciicode for each pressed key
    for(int i=1;i<length;i++)
    {
        int asciicodekey = (int) [inputstring characterAtIndex:i];
        
        switch (asciicodekey)
        {
            case SDLK_COLON:
                [self shiftsendkey:SDLK_SEMICOLON];
                break;
                
            case SDLK_LEFTPAREN:
                [self shiftsendkey:SDLK_9];
                break;
            
            case SDLK_RIGHTPAREN:
                [self shiftsendkey:SDLK_0];
                break;
                
            case SDLK_DOLLAR:
                [self shiftsendkey:SDLK_4];
                break;
                
            case SDLK_AMPERSAND:
                [self shiftsendkey:SDLK_7];
                break;
                
            case SDLK_AT:
                [self shiftsendkey:SDLK_2];
                break;
                
            case SDLK_QUESTION:
                [self shiftsendkey:SDLK_SLASH];
                break;
                
            case SDLK_EXCLAIM:
                [self shiftsendkey:SDLK_1];
                break;
                
            case SDLK_QUOTEDBL:
                [self shiftsendkey:SDLK_BACKQUOTE];
                break;
                
            case SDLK_LEFTBRACES:
                [self shiftsendkey:SDLK_LEFTBRACKET];
                break;
                
            case SDLK_RIGHTBRACES:
                [self shiftsendkey:SDLK_RIGHTBRACKET];
                break;
                
            case SDLK_HASH:
                [self shiftsendkey:SDLK_3];
                break;
                
            case SDLK_PERCENT:
                [self shiftsendkey:SDLK_5];
                break;
                
            case SDLK_CARET:
                [self shiftsendkey:SDLK_6];
                break;
                
            case SDLK_ASTERISK:
                [self shiftsendkey:SDLK_8];
                break;
                
            case SDLK_PLUS:
                [self shiftsendkey:SDLK_EQUALS];
                break;
                
            case SDLK_UNDERSCORE:
                [self shiftsendkey:SDLK_MINUS];
                break;
                
            case SDLK_PIPE:
                [self shiftsendkey:SDLK_BACKSLASH];
                break;
                
            case SDLK_TILDE:
                [self shiftsendkey:SDLK_QUOTE];
                break;
                
            case SDLK_LESS:
                [self shiftsendkey:SDLK_COMMA];
                break;
                
            case SDLK_GREATER:
                [self shiftsendkey:SDLK_PERIOD];
                break;
                
            case SDLK_POUND:
                [self altsendkey:SDLK_l];
                break;
                
            case SDLK_DOPPELS:
                [self altsendkey:SDLK_s];
                break;
                
            case SDLK_AUMLAUT:
                [self altsendkey:SDLK_k];
                [self sendkey:SDLK_a];
                break;
                
            case SDLK_OUMLAUT:
                [self altsendkey:SDLK_k];
                [self sendkey:SDLK_o];
                break;
                
            case SDLK_UUMLAUT:
                [self altsendkey:SDLK_k];
                [self sendkey:SDLK_u];
                break;
                
            default:
                //Key can be send directly
                [self sendkey:asciicodekey];
        }
    }
    
    [textfield setText:@"0"];
}

- (void) altsendkey:(int)asciicode {
    if (!altselected) { [self sendkey:SDLK_LALT direction:KEYDOWN]; }
    [self sendkey:asciicode direction:KEYPRESS];
    if (!altselected) { [self sendkey:SDLK_LALT direction:KEYUP]; }
}

- (void) shiftsendkey:(int)asciicode {
    if (!shiftselected) { [self sendkey:SDLK_LSHIFT direction:KEYDOWN]; }
    [self sendkey:asciicode direction:KEYPRESS];
    if (!shiftselected) { [self sendkey:SDLK_LSHIFT direction:KEYUP]; }
}

- (void) sendkey:(int)asciicode {
    [self sendkey:asciicode direction:KEYPRESS];
}

- (void) sendkey:(int)asciicode direction:(int)direction {

    if(direction == KEYPRESS || direction == KEYDOWN)
    {
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicode;
        SDL_PushEvent(&ed);
    }
    
    if(direction == KEYPRESS || direction == KEYUP)
    {
        SDL_Event eu = { SDL_KEYUP };
        eu.key.keysym.sym = (SDLKey) asciicode;
        SDL_PushEvent(&eu);
    }
}

-(void)setButtonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = TRUE;
    /*[button setBackgroundColor:[UIColor grayColor]];*/
}

-(void)setButtonUnselected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = FALSE;
    /*[button setBackgroundColor:[UIColor whiteColor]];*/
}

- (id) initWithDummyFields:(UITextField *)dummyfield fieldf:(UITextField *)fieldf fieldspecial:(UITextField *)fieldspecial {
    
    self = [super init];
    
    keyboardactive = FALSE;
    ctrlselected = FALSE;
    altselected = FALSE;
    shiftselected = FALSE;
    lAselected = FALSE;
    rAselected = FALSE;
    fkeyselected = FALSE;
    skeyselected = FALSE;
    
    dummy_textfield = dummyfield;
    dummy_textfield_f = fieldf;
    dummy_textfield_s = fieldspecial;
    
    [dummy_textfield setInputAccessoryView:[self createkeyboardToolBar:@"Custom"]];
    [dummy_textfield_f setInputAccessoryView:[self createFKeyToolbar]];
    [dummy_textfield_s setInputAccessoryView:[self createkeyboardToolBar:@"Standard"]];
    
    [dummy_textfield setText:@"0"]; //Dummychar to dedect backspace.
    [dummy_textfield_f setText:@"0"]; //Dummychar to dedect backspace.
    
    [dummy_textfield setDelegate: self];
    [dummy_textfield_f setDelegate:self];
    [dummy_textfield_s setDelegate:self];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keypressed:)
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:dummy_textfield];

    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keypressed:)
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:dummy_textfield_f];
   
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(specialkeypressed:)
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:dummy_textfield_s];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        specialckeyboardiphone = [[PMCustomKeyboard alloc] init];
        [specialckeyboardiphone setTextView:dummy_textfield_s];
    }
    else {
        specialkeyboardipad = [[PKCustomKeyboard alloc] init];
        [specialkeyboardipad setTextView:dummy_textfield_s];
    }
    
    return self;
}

-(UIView *) createFKeyToolbar {
    
    UIToolbar* fkey_toolbar = [[[UIToolbar alloc] initWithFrame:CGRectNull] autorelease];
    
    UIButton *f1_btnd = [self createKeyboardButton:@"F1" action:@selector(F1Key:)];
    UIButton *f2_btnd = [self createKeyboardButton:@"F2" action:@selector(F2Key:)];
    UIButton *f3_btnd = [self createKeyboardButton:@"F3" action:@selector(F3Key:)];
    UIButton *f4_btnd = [self createKeyboardButton:@"F4" action:@selector(F4Key:)];
    UIButton *f5_btnd = [self createKeyboardButton:@"F5" action:@selector(F5Key:)];
    UIButton *f6_btnd = [self createKeyboardButton:@"F6" action:@selector(F6Key:)];
    UIButton *f7_btnd = [self createKeyboardButton:@"F7" action:@selector(F7Key:)];
    UIButton *f8_btnd = [self createKeyboardButton:@"F8" action:@selector(F8Key:)];
    UIButton *f9_btnd = [self createKeyboardButton:@"F9" action:@selector(F9Key:)];
    UIButton *f10_btnd = [self createKeyboardButton:@"F10" action:@selector(F10Key:)];
    UIButton *done_btnd = [self createKeyboardButton:@"done" action:@selector(toggleKeyboardmode:)];
    [done_btnd setTag:BFKEY];
    
    UIBarButtonItem* f1_btn = [[[UIBarButtonItem alloc] initWithCustomView:f1_btnd] autorelease];
    UIBarButtonItem* f2_btn = [[[UIBarButtonItem alloc] initWithCustomView:f2_btnd] autorelease];
    UIBarButtonItem* f3_btn = [[[UIBarButtonItem alloc] initWithCustomView:f3_btnd] autorelease];
    UIBarButtonItem* f4_btn = [[[UIBarButtonItem alloc] initWithCustomView:f4_btnd] autorelease];
    UIBarButtonItem* f5_btn = [[[UIBarButtonItem alloc] initWithCustomView:f5_btnd] autorelease];
    UIBarButtonItem* f6_btn = [[[UIBarButtonItem alloc] initWithCustomView:f6_btnd] autorelease];
    UIBarButtonItem* f7_btn = [[[UIBarButtonItem alloc] initWithCustomView:f7_btnd] autorelease];
    UIBarButtonItem* f8_btn = [[[UIBarButtonItem alloc] initWithCustomView:f8_btnd] autorelease];
    UIBarButtonItem* f9_btn = [[[UIBarButtonItem alloc] initWithCustomView:f9_btnd] autorelease];
    UIBarButtonItem* f10_btn = [[[UIBarButtonItem alloc] initWithCustomView:f10_btnd] autorelease];
    UIBarButtonItem* done_btn = [[[UIBarButtonItem alloc] initWithCustomView:done_btnd] autorelease];
    
    
	UIBarButtonItem* flex_spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    // iPad gets a shift button, iphone doesn't (there's just not enough space ...)
    NSArray* items;
    
    items = [NSArray arrayWithObjects:f1_btn, flex_spacer, f2_btn, flex_spacer, f3_btn, flex_spacer, f4_btn, flex_spacer, f5_btn, flex_spacer, f6_btn, flex_spacer, f7_btn, flex_spacer, f8_btn, flex_spacer,
             f9_btn, flex_spacer, f10_btn, flex_spacer, done_btn, flex_spacer, nil];
    
	[fkey_toolbar setItems:items];
    [fkey_toolbar sizeToFit];
    return fkey_toolbar;
    
}

-(UIView *)createkeyboardToolBar:(NSString *)lastoptionname {
    /* This function was provided by freerdp at https://github.com/FreeRDP/FreeRDP/. Many thanks */
    
    UIToolbar* keyboard_toolbar = [[[UIToolbar alloc] initWithFrame:CGRectNull] autorelease];
    /*[keyboard_toolbar setBarStyle:UIBarStyleBlackOpaque];*/
    
    UIButton *esc_btnd = [self createKeyboardButton:@"Esc" action:@selector(toggleEscKey:)];
    UIButton *ctrl_btnd = [self createKeyboardButton:@"Ctrl" action:@selector(toggleCtrlKey:)];
    UIButton *alt_btnd = [self createKeyboardButton:@"Alt" action:@selector(toggleAltKey:)];
    UIButton *shift_btnd = [self createKeyboardButton:@"Shift" action:@selector(toggleShiftKey:)];
    UIButton *lA_btnd = [self createKeyboardButton:@"lA" action:@selector(togglelAKey:)];
    UIButton *rA_btnd = [self createKeyboardButton:@"rA" action:@selector(togglerAKey:)];
    
    arrowleft_btnd = [self createKeyboardButton:@"<-" action:@selector(CursorKeyPressed:)];
    arrowup_btnd = [self createKeyboardButton:@"^" action:@selector(CursorKeyPressed:)];
    arrowdown_btnd = [self createKeyboardButton:@"v" action:@selector(CursorKeyPressed:)];
    arrowright_btnd = [self createKeyboardButton:@"->" action:@selector(CursorKeyPressed:)];
    
    fKey_btnd = [self createKeyboardButton:@"F" action:@selector(toggleKeyboardmode:)];
    [fKey_btnd setTag:BFKEY];
    
    sKey_btnd = [self createKeyboardButton:lastoptionname action:@selector(toggleKeyboardmode:)];
    [sKey_btnd setTag:BSKEY];
    
    UIBarButtonItem* esc_btn = [[[UIBarButtonItem alloc] initWithCustomView:esc_btnd] autorelease];
	UIBarButtonItem* ctrl_btn = [[[UIBarButtonItem alloc] initWithCustomView:ctrl_btnd] autorelease];
	UIBarButtonItem* alt_btn = [[[UIBarButtonItem alloc] initWithCustomView:alt_btnd] autorelease];
    UIBarButtonItem* lA_btn = [[[UIBarButtonItem alloc] initWithCustomView:lA_btnd] autorelease];
    UIBarButtonItem* rA_btn = [[[UIBarButtonItem alloc] initWithCustomView:rA_btnd] autorelease];
    
    UIBarButtonItem* arrowleft_btn = [[[UIBarButtonItem alloc] initWithCustomView:arrowleft_btnd] autorelease];
    UIBarButtonItem* arrowup_btn = [[[UIBarButtonItem alloc] initWithCustomView:arrowup_btnd] autorelease];
    UIBarButtonItem* arrowdown_btn = [[[UIBarButtonItem alloc] initWithCustomView:arrowdown_btnd] autorelease];
    UIBarButtonItem* arrowright_btn = [[[UIBarButtonItem alloc] initWithCustomView:arrowright_btnd] autorelease];
    
    UIBarButtonItem* F_btn = [[[UIBarButtonItem alloc] initWithCustomView:fKey_btnd] autorelease];
	UIBarButtonItem* flex_spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem* shift_btn = [[[UIBarButtonItem alloc] initWithCustomView:shift_btnd] autorelease];
    
    UIBarButtonItem* special_btn = [[[UIBarButtonItem alloc] initWithCustomView:sKey_btnd] autorelease];
    
    NSArray* items;

    items = [NSArray arrayWithObjects:esc_btn, flex_spacer,
                 shift_btn, flex_spacer,
                 ctrl_btn, flex_spacer,
                 alt_btn, flex_spacer,
                 lA_btn, flex_spacer,
                 rA_btn, flex_spacer,
                 arrowleft_btn, arrowup_btn,
                 arrowdown_btn, arrowright_btn, flex_spacer,
                 F_btn, flex_spacer,
                 special_btn, flex_spacer, nil];
    
	[keyboard_toolbar setItems:items];
    [keyboard_toolbar sizeToFit];
    return keyboard_toolbar;
    
}

-(UIButton *)createKeyboardButton:(NSString *)Name action:(SEL) selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:Name forState:UIControlStateNormal ];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    /*[[button layer] setBorderWidth: 1];
     [[button layer] setCornerRadius: 10];
     [[button layer] setMasksToBounds:YES];
     [button setBackgroundColor: [UIColor whiteColor]];
     [button setAlpha:1.0f];
     [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];*/
    
    return button;
}

@end
