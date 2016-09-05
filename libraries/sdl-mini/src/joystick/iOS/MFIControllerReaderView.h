//  Created by Emufr3ak on 17.11.2014.
//
//  Changed by Emufr3ak on
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Sofftware Foundation, either version 2 of the
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
#import <GameController/GameController.h>

@interface MFIControllerReaderView : UIView
    @property (readonly) BOOL buttonapressed;
    @property (readonly) BOOL buttonbpressed;
    @property (readonly) BOOL buttonxpressed;
    @property (readonly) BOOL buttonypressed;

    @property (readonly) BOOL buttonl1pressed;
    @property (readonly) BOOL buttonl2pressed;
    @property (readonly) BOOL buttonr1pressed;
    @property (readonly) BOOL buttonr2pressed;

<<<<<<< HEAD
    

    @property (readonly) int paused;

=======
    @property (readonly) int paused;

-(void)moveMouse:(NSTimer *)timer;
>>>>>>> dev

@end
