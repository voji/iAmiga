/*
 Frodo, Commodore 64 emulator for the iPhone
 Copyright (C) 2007, 2008 Stuart Carnie
 See gpl.txt for license information.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "InputControllerView.h"
#import "debug.h"
#import "touchstick.h"
#import "CGVector.h"
#import "CocoaUtility.h"
#import "SDL_events.h"
#import "JoypadKey.h"
#import "KeyButtonViewHandler.h"


InputControllerView *sharedInstance;
extern CJoyStick g_touchStick;

@interface FireButtonView : UIView {
@public
	CJoyStick							*TheJoyStick;
	id<InputControllerChangedDelegate>	delegate;
	UIImageView							*fireImage;
}

@property (nonatomic, readwrite) BOOL showControls;
@property (nonatomic, readwrite, assign) NSString *joypadstyle;
@property (nonatomic, readwrite, assign) NSString *leftorright;
@property (nonatomic, readwrite) BOOL showbuttontouch;
@property (nonatomic, readwrite) BOOL clickedscreen;

@end

@implementation FireButtonView {
    Settings *_settings;
    NSTimer *_showcontrolstimer;
    BOOL _buttonapressed;
    BOOL _buttonbpressed;
    BOOL _buttonxpressed;
    BOOL _buttonypressed;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	TheJoyStick = &g_touchStick;
	
    _settings = [[Settings alloc] init];
    
	return self;
}

- (void)initShowControlsTimer {
    if (_showcontrolstimer) {
        [_showcontrolstimer release];
    }
    _showcontrolstimer = [[NSTimer scheduledTimerWithTimeInterval:1.000 target:self
                                                       selector:@selector(disableShowControls:) userInfo:nil repeats:YES] retain];
    _showcontrolstimer.tolerance = 0.0020;
    
    [self setNeedsDisplay];
}

- (void)disableShowControls:(NSTimer *)timer {
    _showControls = NO;
    [self setNeedsDisplay];
    
    [_showcontrolstimer invalidate];
    [_showcontrolstimer release];
    _showcontrolstimer = nil;
}


-(void)drawRect:(CGRect)rect {
    
    if(!_showControls && !_showbuttontouch)
    {
        return;
    }
    
    if([_joypadstyle isEqualToString:kJoyStyleFourButton])
    {
        [self drawFireButtonsFour:rect];
    }
    else
    {
        [self drawFireButtonsOne:rect];
    }
}

-(void)drawFireButtonsFour:(CGRect)rect
{
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 12], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect yLabel = CGRectMake(CGRectGetMidX(rect), CGRectGetMidY(rect)/2, 20, 20);
    CGRect aLabel = CGRectMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)*0.75, 20, 20);
    CGRect xLabel = CGRectMake(CGRectGetMidX(rect)/2, CGRectGetMidY(rect), 20, 20);
    CGRect bLabel = CGRectMake(CGRectGetMaxX(rect)*0.75, CGRectGetMidY(rect), 20, 20);
    
    if(_showControls || _buttonypressed)
    {
        //Button Y
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));  // mid right
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // bottom left
        CGContextClosePath(ctx);
            
        CGContextSetRGBFillColor(ctx, 0, 0, 0.7, 0.7);
        CGContextFillPath(ctx);
        
        [@"Y" drawInRect:yLabel withAttributes:textFontAttributes];
    }
    
    if(_showControls || _buttonapressed)
    {
    //Button A
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // top left
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));  // mid right
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom left
        CGContextClosePath(ctx);

        CGContextSetRGBFillColor(ctx, 0, 0, 0.7, 0.7);
        CGContextFillPath(ctx);
        
        [@"A" drawInRect:aLabel withAttributes:textFontAttributes];
    }
    
    if(_showControls || _buttonxpressed)
    {
    //Button X
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));  // mid right
        CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
        CGContextClosePath(ctx);
        
        CGContextSetRGBFillColor(ctx, 0, 0, 0.5, 0.7);
        CGContextFillPath(ctx);
        
        [@"X" drawInRect:xLabel withAttributes:textFontAttributes];
    }
    
    if(_showControls || _buttonbpressed)
    {
        //Button B
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top left
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));  // mid right
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom left
        CGContextClosePath(ctx);
        
        CGContextSetRGBFillColor(ctx, 0, 0, 0.5, 0.7);
        CGContextFillPath(ctx);
        
        [@"B" drawInRect:bLabel withAttributes:textFontAttributes];
    }
    
}

-(void)drawFireButtonsOne:(CGRect)rect
{
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 12], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect aLabel = CGRectMake(CGRectGetMidX(rect), CGRectGetMidY(rect), 20, 20);
    
    if(_showControls || _buttonapressed)
    {
        //Button A
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect)); //top left
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom right
        CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
        CGContextClosePath(ctx);
        
        CGContextSetRGBFillColor(ctx, 0, 0, 0.7, 0.7);
        CGContextFillPath(ctx);
        
        [@"A" drawInRect:aLabel withAttributes:textFontAttributes];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    CGPoint coordinates = [[[event allTouches] anyObject] locationInView:self];
    
    NSString *configuredkey;
    if([_joypadstyle isEqualToString:kJoyStyleFourButton])
    {
        configuredkey = [self getButtonFour:&coordinates];
    }
    else
    {
        configuredkey = [self getButtonOne:&coordinates];
    }
    
    if([configuredkey isEqualToString:@"Joypad"])
    {
        TheJoyStick->setButtonOneState(FireButtonDown);
        [delegate fireButton:FireButtonDown];
    }
    else
    {
        int asciicode = [[configuredkey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
        
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey)asciicode;
        SDL_PushEvent(&ed);
    }
}

- (NSString *)getButtonFour:(CGPoint *)coordinates {
    
    bool tophalf = (coordinates->y <= (self.frame.size.height / 2)) ? true : false;
    bool lefthalf = (coordinates->x <= (self.frame.size.width / 2)) ? true : false;
    int xposvertex = self.frame.size.width / 2; //Highest point of all (triangular shaped) buttons;
    
    int buttonheight = tophalf ? self.frame.size.height / 2 : (self.frame.size.height / 2) - 1; //Height of button
    int xpointsreltovertex = lefthalf ? coordinates->x : (coordinates->x - self.frame.size.width)*-1; //X-Axis relative to highest point of triangle
    
    int xposbuttonyheight = ((double)xpointsreltovertex/ (double) xposvertex) * (double) buttonheight;
    
    NSString *configuredkey;
    
    if(tophalf && (coordinates->y <= xposbuttonyheight))
    //Button Y
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_Y]];
        _buttonypressed = true;
    }
    else if(!tophalf && coordinates->y >= buttonheight - xposbuttonyheight + (self.frame.size.height / 2))
    //Button A
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_A]];
        _buttonapressed = true;
    }
    else if(lefthalf)
    //Button X
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_X]];
        _buttonxpressed = true;
    }
    else
    //Button B
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_B]];
        _buttonbpressed = true;
    }
    
    if(configuredkey)
    //If any result display needs to be refreshed
    {
        [self setNeedsDisplay];
    }
    
    return configuredkey;    
}

-(NSString *)getButtonOne:(CGPoint *)coordinates {
    
    _buttonapressed = true;
    [self setNeedsDisplay];
    return [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_A]];
}

-(NSString *)releasebutton {
    
    NSString *configuredkey;
    
    if(_buttonypressed)
        //Button Y
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_Y]];
        _buttonypressed = false;
    }
    else if(_buttonapressed)
        //Button A
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_A]];
        _buttonapressed = false;
    }
    else if(_buttonxpressed)
        //Button X
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_X]];
        _buttonxpressed = false;
    }
    else if(_buttonbpressed)
        //Button B
    {
        configuredkey = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", BTN_B]];
        _buttonbpressed = false;
    }
    
    if(configuredkey)
        //If any result display needs to be refreshed
    {
        [self setNeedsDisplay];
    }
    
    return configuredkey;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// ignore
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSString *configuredkey = [self releasebutton];
    
    if([configuredkey isEqualToString:@"Joypad"])
    {
        TheJoyStick->setButtonOneState(FireButtonUp);
        [delegate fireButton:FireButtonUp];
    }
    else
    {
        int asciicode = [[configuredkey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
        
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) asciicode;
        SDL_PushEvent(&ed);
    }
    _clickedscreen = YES;
    
}

- (void)dealloc {
    if (fireImage) {
		[fireImage release];
    }
	
    [_joypadstyle release];
    [_leftorright release];
    
	[super dealloc];
}

@end

@interface InputControllerView(PrivateMethods)

- (void)calculateDPadState;
- (void)setDPadState:(TouchStickDPadState)state;

@end

@interface InputControllerView()
- (void)configure;
@end

@implementation InputControllerView {
    CGFloat _kButtonWidthPortraitPct;
    CGFloat _kButtonWidthLandscapePct;
    NSString *_joypadstyle;
    NSString *_leftorright;
    BOOL _showbuttontouch;
    Settings *_settings;
    int _asciicodekeytoreleasehorizontal;
    int _asciicodekeytoreleasevertical;
    TouchStickDPadState _oldstate;
    KeyButtonViewHandler *_keyButtonViewHandler;
}

@synthesize delegate;
@synthesize clickedscreen = _clickedscreen;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    
    return self;
}

- (void)awakeFromNib {
	[self configure];
}

- (void)configure {
    
    // Initialization code
    button = [[FireButtonView alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor clearColor];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:button];
    _deadZone = 20.0f;	// radius, in pixels of the dead zone.
    _trackingStick = NO;
    _stickVector = new CGVector2D();
    sharedInstance = self;
    TheJoyStick = &g_touchStick;
    _oldstate = DPadCenter;
    
    _settings = [[Settings alloc] init];
    
    _keyButtonViewHandler = [[KeyButtonViewHandler alloc] initWithSuperview:self];
}

- (void)onJoypadActivated {
    button.showControls = YES;
    [button initShowControlsTimer];
    [_keyButtonViewHandler addConfiguredKeyButtonViews];
}

- (void)reloadJoypadSettings {
    [self setJoypadstyle:_settings.joypadstyle];
    [self setLeftOrRight:_settings .joypadleftorright];
    [self setShowButtontouch:_settings.joypadshowbuttontouch];
    [_keyButtonViewHandler addConfiguredKeyButtonViews];
}

- (void)setJoypadstyle:(NSString *)strjoypadstyle {
    _joypadstyle = strjoypadstyle;
    button.joypadstyle = _joypadstyle;
}

- (void)setLeftOrRight:(NSString *)strLeftOrRight {
    _leftorright = strLeftOrRight;
    button.leftorright = _leftorright;
    [self setButtonSubview];
}

- (void)setShowButtontouch:(BOOL)showbuttontouch {
    _showbuttontouch = showbuttontouch;
    button.showbuttontouch = _showbuttontouch;
}

- (void)setDelegate:(id<InputControllerChangedDelegate>)theDelegate {
	delegate = theDelegate;
	button->delegate = theDelegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setButtonSubview];
}

- (void)setButtonSubview {
    
    if([_joypadstyle isEqualToString:kJoyStyleFourButton])
    {
        _kButtonWidthLandscapePct = 0.5;
        _kButtonWidthPortraitPct = 0.5;
    }
    else
    {
        _kButtonWidthLandscapePct = 0.25;
        _kButtonWidthPortraitPct = 0.25;
    }
    
    CGSize size = self.frame.size;
    
    BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    if (isLandscape) {
        if ([_leftorright isEqualToString:@"Left"])
        {
            button.frame = CGRectMake(0, 0, size.width * _kButtonWidthLandscapePct, size.height);
        }
        else
        {
            button.frame = CGRectMake(size.width * (1.00 - _kButtonWidthLandscapePct), 0, size.width * _kButtonWidthLandscapePct, size.height);
        }
    } else {
        button.frame = CGRectMake(0, 0, size.width * _kButtonWidthPortraitPct, size.height);
    }
}

- (void)didAddSubview:(UIView*)theView {
	[self bringSubviewToFront:button];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	_stickCenter = [touch locationInView:self];
	_stickVector->x = _stickVector->y = 0;
	
	[self setDPadState:DPadCenter];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {	
	UITouch *touch = [touches anyObject];
	_stickLocation = [touch locationInView:self];
	_stickVector->UpdateFromPoints(_stickCenter, _stickLocation);
	[self calculateDPadState];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _clickedscreen = YES;
	_stickVector->x = _stickVector->y = 0;
	[self setDPadState:DPadCenter];
}

- (BOOL)clickedscreen {
    // did the user move the joypad, use fire button(s) or use key buttons?
    return _clickedscreen || button.clickedscreen || _keyButtonViewHandler.anyButtonWasTouched;
}

- (void)setClickedscreen:(BOOL)clickedscreen {
    _clickedscreen = clickedscreen;
    button.clickedscreen = clickedscreen;
    _keyButtonViewHandler.anyButtonWasTouched = clickedscreen;
}

- (void)dealloc {
    [_joypadstyle release];
    [_keyButtonViewHandler release];
    [_settings release];
	delete _stickVector;
    [super dealloc];
}

- (void)calculateDPadState {
	if (_stickVector->length() <= _deadZone) {
		[self setDPadState:DPadCenter];
		return;
	}
	
	CGFloat angle = _stickVector->angle();
	if (angle < 0) angle = 360 + angle;
	
	const CGFloat deg = 22.5;
	TouchStickDPadState dPadState;
    
	if (angle <= 0 + deg || angle > 360 - deg)
		dPadState = DPadRight;
	else if (angle <= 45 + deg && angle > 45 - deg)
		dPadState = DPadDownRight;
	else if (angle <= 90 + deg && angle > 90 - deg)
		dPadState = DPadDown;
	else if (angle <= 135 + deg && angle > 135 - deg)
		dPadState = DPadDownLeft;
	else if (angle <= 180 + deg && angle > 180 - deg)
		dPadState = DPadLeft;
	else if (angle <= 225 + deg && angle > 225 - deg)
		dPadState = DPadUpLeft;
	else if (angle <= 270 + deg && angle > 270 - deg)
		dPadState = DPadUp;
	else if (angle <= 315 + deg && angle > 315 - deg)
		dPadState = DPadUpRight;
	else
		dPadState = DPadCenter;

	[self setDPadState:dPadState];
}

- (void)setDPadState:(TouchStickDPadState)state {
	if (_oldstate != state) {
        [self pushKey:state];
		[delegate joystickStateChanged:state];
    }
    
    _oldstate = state;
}

- (void)pushKey:(TouchStickDPadState)dpadstate {
    
    NSString *configuredkeyhorizontal = NULL;
    NSString *configuredkeyvertical = NULL;
    int asciicodehorizontal = NULL;
    int asciicodevertical = NULL;
    
    if([self dpadstatetojoypadkey:dpadstate direction:@"horizontal"])
    {
        configuredkeyhorizontal = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: dpadstate direction:@"horizontal"]]];
        asciicodehorizontal = [[configuredkeyhorizontal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if([self dpadstatetojoypadkey:dpadstate direction:@"vertical"])
    {
       configuredkeyvertical = [_settings stringForKey:[NSString stringWithFormat: @"_BTN_%d", [self dpadstatetojoypadkey: dpadstate direction:@"vertical"]]];
        asciicodevertical = [[configuredkeyvertical stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"KEY_"]] intValue];
    }
    
    if(_asciicodekeytoreleasehorizontal)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) _asciicodekeytoreleasehorizontal;
        SDL_PushEvent(&ed);
        _asciicodekeytoreleasehorizontal = NULL;
    }
    
    if(_asciicodekeytoreleasevertical)
    {
        SDL_Event ed = { SDL_KEYUP };
        ed.key.keysym.sym = (SDLKey) _asciicodekeytoreleasevertical;
        SDL_PushEvent(&ed);
        _asciicodekeytoreleasevertical = NULL;
    }
    
    if(dpadstate == DPadCenter)
    {
        //In case multiple "Joypads" get implemented this line needs to be checked
        TheJoyStick->setDPadState(DPadCenter);
        return;
    }
    
    if([configuredkeyhorizontal isEqualToString:@"Joypad"] && [configuredkeyvertical isEqual:@"joypad"])
    {
        TheJoyStick->setDPadState(dpadstate);
        return;
    }
    
    if([configuredkeyhorizontal isEqualToString:@"Joypad"])
    {
        TheJoyStick->setDPadState(dpadstate);
    }
    else if(configuredkeyhorizontal)
    {
        _asciicodekeytoreleasehorizontal = asciicodehorizontal;
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodehorizontal;
        SDL_PushEvent(&ed);
    }
   
    if([configuredkeyvertical isEqualToString:@"Joypad"])
    {
        TheJoyStick->setDPadState(dpadstate);
    }
    else if (configuredkeyvertical)
    {
        _asciicodekeytoreleasevertical = asciicodevertical;
        SDL_Event ed = { SDL_KEYDOWN };
        ed.key.keysym.sym = (SDLKey) asciicodevertical;
        SDL_PushEvent(&ed);
    }
    
}

- (int)dpadstatetojoypadkey:(TouchStickDPadState)dpadstate direction:(NSString *)direction {
    
    if(dpadstate == DPadUp)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return NULL;
    }
    else if(dpadstate == DPadUpLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_UP;
        else
            return BTN_LEFT;
    }
    else if(dpadstate == DPadUpRight)
    {
        if([direction isEqual:@"horizontal"])
            return BTN_UP;
        else
            return BTN_RIGHT;
    }
    else if(dpadstate == DPadDown)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return NULL;
    }
    else if (dpadstate == DPadDownLeft)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_LEFT;
    }
    else if (dpadstate == DPadDownRight)
    {
        if([direction isEqual:@"vertical"])
            return BTN_DOWN;
        else
            return BTN_RIGHT;
    }
    else if (dpadstate == DPadLeft)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_LEFT;
    }
    else if (dpadstate == DPadRight)
    {
        if([direction isEqual:@"vertical"])
            return NULL;
        else
            return BTN_RIGHT;
    }
    return NULL;
}

@end