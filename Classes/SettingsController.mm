//
//  SettingsController.m
//  iAmiga
//
//  Created by Stuart Carnie on 9/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//  Changed by Emufr3ak on 17.11.2014
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
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "SettingsController.h"
#import "EMUROMBrowserViewController.h"
#import "EmulationViewController.h"
#import "SelectEffectController.h"
#import "EMUFileInfo.h"
#import "sysconfig.h"
#import "sysdeps.h"
#import "options.h"
#import "SDL.h"
#import "UIKitDisplayView.h"
#import "savestate.h"

#if DISASSEMBLER
#import "DisaSupport.h"
#endif

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;
extern int joystickselected;

@implementation SettingsController


static NSMutableArray *Filename;
extern int do_disa;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    if(!Filename)
    {
        Filename = [[NSMutableArray alloc] init];
        [Filename addObject:[NSMutableString new]];
        [Filename addObject:[NSMutableString new]];
    }
    
    stretchscreen.on = mainMenu_stretchscreen ? YES : NO;
	status.on = mainMenu_showStatus ? YES : NO;
	displayModeNTSC.on = mainMenu_ntsc ? YES : NO;
    
    
    
    NSString *controllername;
    
    switch(joystickselected)
    {
        case 4:
            controllername = @"MFI";
            break;
        case 3:
            controllername = @"iCADE";
            break;
        default:
            controllername = @"iControlPAD";
            break;
    }
    
    [controller setTitle:controllername forState:UIControlStateNormal];
	
#if DISASSEMBLER
	resetLog.hidden = NO;
	logging.hidden = NO;
	loggingLabel.hidden = NO;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
#if DISASSEMBLER
	logging.on = do_disa == 0 ? NO : YES;
#endif
    
    NSString *df0title = [[Filename objectAtIndex:0] length] == 0 ? @"Empty" : [Filename objectAtIndex:0];
    NSString *df1title = [[Filename objectAtIndex:1] length] == 0 ? @"Empty" : [Filename objectAtIndex:0];
    
    [df0 setTitle:df0title forState:UIControlStateNormal];
    [df1 setTitle:df1title forState:UIControlStateNormal];
}

- (IBAction)selectDrive:(UIButton*)sender {
    
    NSString *xibfile = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"EMUROMBrowserView-ipad" : @"EMUROMBrowserView";
    
	EMUROMBrowserViewController *browser = [[EMUROMBrowserViewController alloc] initWithNibName:xibfile bundle:nil];
	browser.delegate = self;
	browser.context = sender;
	//[self presentModalViewController:browser animated:YES];
	[self.navigationController pushViewController:browser animated:YES];
    [browser release];
}

- (IBAction)selectEffect:(id)sender {
	SelectEffectController *ctl = [[SelectEffectController alloc] initWithNibName:@"SelectEffectController" bundle:nil];
	[ctl setDelegate:self];
	//[self presentModalViewController:ctl animated:YES];
	[self.navigationController pushViewController:ctl animated:YES];
    [ctl release];
}

- (void)didSelectEffect:(int)aEffect name:(NSString*)name {
	SDL_Surface *video = SDL_GetVideoSurface();
	id<DisplayViewSurface> display = (id<DisplayViewSurface>)video->userdata;
	display.displayEffect = (DisplayEffect)aEffect;
	[effect setTitle:name forState:UIControlStateNormal];
}

- (IBAction)selectController:(id)sender {
    SelectHardware *ctl = [[SelectHardware alloc] initWithNibName:@"SelectHardware" bundle:nil];
	[ctl setDelegate:self];
	//[self presentModalViewController:ctl animated:YES];
    [self.navigationController pushViewController:ctl animated:YES];
	[ctl release];
}

extern void switch_joystick(int joynum);

- (void)didSelectHardware:(int)joystick name:(NSString *)name {
    [controller setTitle:name forState:UIControlStateNormal];
    switch_joystick(joystick);
}

- (void)didSelectROM:(EMUFileInfo *)fileInfo withContext:(UIButton*)sender {
	NSString *path = [fileInfo path];
	int df = sender.tag;
	[sender setTitle:[fileInfo fileName] forState:UIControlStateNormal];
    [Filename replaceObjectAtIndex:df withObject:[NSMutableString stringWithString:[fileInfo fileName]]];
    
	[path getCString:changed_df[df] maxLength:256 encoding:[NSString defaultCStringEncoding]];
    real_changed_df[df]=1;
}

extern "C" void uae_reset();

- (void)resetAmiga:(id)sender {
	uae_reset();
}

- (IBAction)integralSize:(UISwitch*)sender {
	g_emulatorViewController.integralSize = !sender.on;
}

- (IBAction)toggleStatus:(UISwitch*)sender {
	mainMenu_showStatus = sender.on ? 1 : 0;
}

- (IBAction)toggleStretchScreen:(id)sender {
    mainMenu_stretchscreen = stretchscreen.on ? 1 : 0;
}

- (IBAction)resetLog:(id)sender {
#if DISASSEMBLER
	DisaCloseFile();
	DisaCreateFile(1);
#endif
}

- (IBAction)toggleLogging:(UISwitch*)sender {
#if DISASSEMBLER
	do_disa = sender.on ? 1 : 0;
#endif
}

- (IBAction)otherAction:(UIControl*)sender {
	int tag = sender.tag;
    
    static char statefile[1024];
    NSString *stateFileString = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"savestate.asf"];
    [stateFileString getCString:statefile maxLength:sizeof(statefile) encoding:[NSString defaultCStringEncoding]];

    
    switch (tag) {
        case 1000:  // save
            savestate_filename = statefile;
            savestate_state = STATE_DOSAVE;
            break;
            
        case 1001:  // restore
            savestate_filename = statefile;
            savestate_state = STATE_DORESTORE;            
            break;
            
        default:
            break;
    }
}

- (IBAction)toggleNTSC:(UISwitch*)sender {
	mainMenu_ntsc = sender.on ? 1 : 0;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [controller release];
    controller = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[status release];
}


- (void)dealloc {
    [controller release];
    [super dealloc];
}


@end
