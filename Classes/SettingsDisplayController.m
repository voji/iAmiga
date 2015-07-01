//
//  SettingsDisplayController.m
//  iUAE
//
//  Created by Urs on 01.03.15.
//
//

#import "SelectEffectController.h"
#import "SettingsDisplayController.h"
#import "Settings.h"
#import "SDL.h"
#import "UIKitDisplayView.h"

extern int mainMenu_showStatus;
extern int mainMenu_ntsc;
extern int mainMenu_stretchscreen;

@implementation SettingsDisplayController {
    NSUInteger _selectedEffectIndex;
    SelectEffectController *_selectEffectController;
    Settings *_settings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _settings = [[Settings alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_settings initializeSettings];
    [_ntsc setOn:_settings.ntsc];
    [_showstatus setOn:_settings.showStatus];
    [_stretchscreen setOn:_settings.stretchScreen];
    
    if (_selectEffectController)
    {
        [self onSelectedEffectAtIndex:_selectEffectController.selectedEffectIndex withName:_selectEffectController.selectedEffectName];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_selectEffectController release];
    _selectEffectController = [segue.destinationViewController retain];
    _selectEffectController.selectedEffectIndex = _selectedEffectIndex;
}

- (void)toggleNTSC:(id)sender {
    _settings.ntsc = _ntsc.isOn;
    mainMenu_ntsc = _ntsc.isOn;
}

- (void)toggleShowstatus:(id)sender {
    _settings.showStatus = _showstatus.isOn;
    mainMenu_showStatus = _showstatus.isOn;
}

- (void)toggleStretchscreen:(id)sender {
    _settings.stretchScreen = _stretchscreen.isOn;
    mainMenu_stretchscreen = _stretchscreen.isOn;
}

- (void)onSelectedEffectAtIndex:(int)selectedEffectIndex withName:(NSString *)selectedEffectName {
    [_selectedEffectLabel setText:selectedEffectName];
    _selectedEffectIndex = selectedEffectIndex;
    SDL_Surface *video = SDL_GetVideoSurface();
    id<DisplayViewSurface> display = (id<DisplayViewSurface>)video->userdata;
   	display.displayEffect = selectedEffectIndex;
}

- (void)dealloc
{
    [_selectEffectController release];
    [_settings release];
    [super dealloc];
}

@end