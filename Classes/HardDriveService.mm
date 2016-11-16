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
    if(!currprefs_mountinfo) return 0;
    return nr_units(currprefs_mountinfo) == 1;
}

- (BOOL)readOnly {
    return [self mounted] ? [self readOnlyInternal] : YES;
}

- (NSString *)getMountedHardfilePath {
    return [self mounted] ? [self getMountedHardfilePathInternal] : nil;
}

- (void)mountHardfile:(NSString *)hardfilePath asReadOnly:(BOOL)readOnly {
    if (![self mounted]) {
        [hardfilePath getCString:uae4all_hard_file maxLength:sizeof(uae4all_hard_file) encoding:[NSString defaultCStringEncoding]];
        
        int readOnlyInt = readOnly ? 1 : 0;

        // hardcoded values are defaults from uae4all2 cfg file:
        // harddir: dir1:hd/dir1
        // hardfile: 32:1:2:512:/data/data/pandora.uae4all.sdl/files/blankdisks/empty.hdf
        static int secspertrack = 32;
        static int surfaces = 1;
        static int reserved = 2;
        static int blocksize = 512;
        
        add_filesys_unit(currprefs_mountinfo, 0, uae4all_hard_file, readOnlyInt, secspertrack, surfaces, reserved, blocksize);
    }
}

- (void)unmountHardfile {
    if ([self mounted]) {
        kill_filesys_unit(currprefs_mountinfo, 0);
        uae4all_hard_file[0] = '\0';
    }
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

- (BOOL)readOnlyInternal {
    int readonly; // the one we care about
    char *rootdir, *volname;
    int track, surfaces, reserved, cylinders, size, blocksize;
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
    return readonly == 1 ? YES : NO;
}

@end
