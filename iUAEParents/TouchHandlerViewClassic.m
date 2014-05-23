//
//  TouchHandlerViewClassic.m
//  iAmiga
//
//  Created by Urs on 23.04.14.
//
//

#import "TouchHandlerViewClassic.h"
#import "SDL.h"
#import "SDL_events.h"
#import "SDL_mouse_c.h"

@implementation TouchHandlerViewClassic {
    NSTimer *timer;
    NSTimeInterval durationtouch;
    bool draggingon;
    NSDate *now;
}
    
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code.
		self.multipleTouchEnabled = YES;
    }
    
    timer=[[ NSTimer scheduledTimerWithTimeInterval:0.020 target:self
                                          selector:@selector(timerEvent:) userInfo:nil repeats:YES ] retain];
    
    draggingon = FALSE;
    
    return self;
}

-(void)timerEvent:(NSTimer*)timer{
    //Press Left Mouse Button down and keep down if tab is pressed for more than one second without moving
    
    if(starttimetouch)
    {
        now = [NSDate date];
        durationtouch = [now timeIntervalSinceDate:starttimetouch];
    }
    
    if(durationtouch > 1 && draggingon == FALSE && didMove == FALSE)
    {
        SDL_SendMouseButton(NULL, SDL_PRESSED, SDL_BUTTON_LEFT);
        draggingon = TRUE;
    }
}

- (void)awakeFromNib {
    self.multipleTouchEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    x_ratio = self.frame.size.width / 320.0f / 2.0f; /* King of Chicago */
    y_ratio = self.frame.size.height / 240.0f / 2.0f; /* King of Chicago */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *touchtype = [event allTouches];
    int touchCounts = [touchtype count];
    
    
    UITouch *touch = [touches anyObject];
    
    if (touch.phase == UITouchPhaseBegan)
    {
        if (touchCounts == 2)
        {
            rightTouch = touch;
            SDL_SendMouseButton(NULL, SDL_PRESSED, SDL_BUTTON_RIGHT);
        }
        else
        {
            leadTouch = touch;
            previousMouseLocation = [touch locationInView: self];
            didMove = NO;
            starttimetouch = [[NSDate alloc] init]; //Neccessary for dragging (long touch and then Move = Drag)
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (leadTouch)
    {
        CGPoint locationInView = [leadTouch locationInView:self];
        CGFloat relx = (locationInView.x - previousMouseLocation.x) / x_ratio;
        CGFloat rely = (locationInView.y - previousMouseLocation.y) / y_ratio;
        
        if (fabsf(relx) < 1.0f)
            relx = 0.f;
        if (fabsf(rely) < 1.0f)
            rely = 0.f;
        
        if (relx != 0.0f || rely != 0.0f)
        {
            SDL_SendMouseMotion(NULL, SDL_MOTIONRELATIVE, relx, rely);
            
            if (relx != 0.0f)
                previousMouseLocation.x = locationInView.x;
            
			if (rely != 0.0f)
                previousMouseLocation.y = locationInView.y;
            
            didMove = YES;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if (touch.phase == UITouchPhaseEnded)
        {
            if (touch == leadTouch)
            {
                leadTouch = Nil;
                //printf("Move End\n");
                
                if(draggingon == FALSE)
                {
                    if (didMove == NO)
                    {
                        SDL_SendMouseButton(NULL, SDL_PRESSED, SDL_BUTTON_LEFT);
                        //printf("Left press\n");
                        
                        // 50ms after, push up
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 50 * 1000000), dispatch_get_main_queue(), ^{
                            SDL_SendMouseButton(NULL, SDL_RELEASED, SDL_BUTTON_LEFT);
                            //printf("Left release\n");
                        });
                    }
                }
                else
                //Left Mousebutton Down while Moving Mouse on (Allows Drag and Drop among others)
                {
                   SDL_SendMouseButton(NULL, SDL_RELEASED, SDL_BUTTON_LEFT);
                    draggingon = FALSE;
                    [starttimetouch release];
                    starttimetouch = Nil;
                    durationtouch = 0;
                }
            }
            else if (touch == rightTouch)
            {
                rightTouch = Nil;
                SDL_SendMouseButton(NULL, SDL_RELEASED, SDL_BUTTON_RIGHT);
                //printf("Right release\n");
            }
        }
    }
}



- (void)dealloc
{
    [starttimetouch release];
    [timer release];
    [super dealloc];
}


@end
