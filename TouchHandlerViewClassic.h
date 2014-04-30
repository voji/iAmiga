//
//  TouchHandlerViewClassic.h
//  iAmiga
//
//  Created by Urs on 23.04.14.
//
//

#import <UIKit/UIKit.h>

@interface TouchHandlerViewClassic : UIView {
    UITouch			*leadTouch;
	UITouch			*rightTouch;
	CGPoint			previousMouseLocation;
	BOOL			didMove;
	CGFloat			x_ratio, y_ratio;
}
@end
