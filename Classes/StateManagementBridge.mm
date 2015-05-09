//  Created by Simon Toens on 09.05.15
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

#import "sysconfig.h"
#import "sysdeps.h"
#import "savestate.h"
#import "StateManagementBridge.h"

@implementation StateManagementBridge

+ (void)saveState:(NSString *)stateFilePath {
    [StateManagementBridge setGlobalSaveStatePath:stateFilePath andState:STATE_DOSAVE];
}

+ (void)restoreState:(NSString *)stateFilePath {
    [StateManagementBridge setGlobalSaveStatePath:stateFilePath andState:STATE_DORESTORE];
}

+ (void)setGlobalSaveStatePath:(NSString *)stateFilePath andState:(int)state {
    static char path[1024];
    [stateFilePath getCString:path maxLength:sizeof(path) encoding:[NSString defaultCStringEncoding]];
    savestate_filename = path;
    savestate_state = state;
}

@end