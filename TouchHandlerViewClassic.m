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

@implementation TouchHandlerViewClassic

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.multipleTouchEnabled = YES;
    }
    return self;
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
    
    /*for (UITouch *touch in touches)
     {*/
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
        }
        
        /*if (!leadTouch)
         {
         leadTouch = touch;
         previousMouseLocation = [touch locationInView: self];
         didMove = NO;
         //printf("Move begin\n");
         }
         else if(!rightTouch)
         {
         
         //printf("Right press\n");
         }*/
    }
    /*}*/
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
    [super dealloc];
}


@end
