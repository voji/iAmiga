//  Created by Simon Toens on 24.03.16
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

#import "cfgfile.h"
#import "HardDriveService.h"
#import "filesys.h"

@implementation HardDriveService

- (BOOL)mounted {
    return nr_units(currprefs_mountinfo) == 1;
}

- (NSString *)getMountedHardfilePath {
    return [self mounted] ? [self getMountedHardfilePathInternal] : nil;
}

- (void)mountHardfile:(NSString *)hardfilePath {
    if (![self mounted]) {
        [hardfilePath getCString:uae4all_hard_file maxLength:sizeof(uae4all_hard_file) encoding:[NSString defaultCStringEncoding]];
        NSString *spec = [self getHardfileSpec:hardfilePath];
        char specC[256];
        [spec getCString:specC maxLength:sizeof(specC) encoding:[NSString defaultCStringEncoding]];
        parse_hardfile_spec(specC);
    }
}

- (void)unmountHardfile {
    if ([self mounted]) {
        kill_filesys_unit(currprefs_mountinfo, 0);
    }
}

- (NSString *)getHardfileSpec:(NSString *)hardfilePath {
    // the hardfile spec string is static, so we'll just build it here intead of persisting it in Settings
    //
    // from uae4all2 cfg file:
    // harddir: dir1:hd/dir1
    // hardfile: 32:1:2:512:/data/data/pandora.uae4all.sdl/files/blankdisks/empty.hdf
    return [NSString stringWithFormat:@"32:1:2:512:%@", hardfilePath];
}

- (NSString *)getMountedHardfilePathInternal {
    char *rootdir; // the one we care about
    char *volname;
    int readonly, track, surfaces, reserved, cylinders, size, blocksize;
    static int nr = 0;
    get_filesys_unit(currprefs_mountinfo,
                     nr,
                     &volname,
                     &rootdir,
                     &readonly,
                     &track,
                     &surfaces,
                     &reserved,
                     &cylinders,
                     &size,
                     &blocksize);
    return [NSString stringWithCString:rootdir encoding:[NSString defaultCStringEncoding]];
}

@end