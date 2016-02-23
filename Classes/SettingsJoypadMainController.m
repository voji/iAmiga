//  Created by Emufreak on 31.1.2016
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
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import "SettingsJoypadMainController.h"
#import <GameController/GameController.h>
extern int mainMenu_servermode;

@interface SettingsJoypadMainController ()

@end

@implementation SettingsJoypadMainController

- (void)viewDidLoad {
    [super viewDidLoad];

    _LabelDetection.text = [[GCController controllers] count] >=1 ? @"MFI Game Controller Detected" : @"No Controller or iCade connected";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_openServer setOn:mainMenu_servermode == 1];
    [_sendToPort0 setOn:mainMenu_servermode == 2];
    [_sendToPort1 setOn:mainMenu_servermode == 3];
}

- (IBAction)actionOpenServer:(id)sender {
    if(_openServer.isOn)
        mainMenu_servermode = 1;
    else
        mainMenu_servermode = 0;
    
    [_sendToPort0 setOn:false];
    [_sendToPort1 setOn:false];
}
- (IBAction)actionSendToPort0:(id)sender {
    if(_sendToPort0.isOn)
        mainMenu_servermode = 2;
    else
        mainMenu_servermode = 0;
    
    [_openServer setOn:false];
    [_sendToPort1 setOn:false];
}
- (IBAction)actionSendToPort1:(id)sender {
    if(_sendToPort1.isOn)
        mainMenu_servermode = 3;
    else
        mainMenu_servermode = 0;
    [_openServer setOn:false];
    [_sendToPort0 setOn:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_LabelDetection release];
    [_openServer release];
    [_sendToPort0 release];
    [_sendToPort1 release];
    [super dealloc];
}
@end
