//  Created by Simon Toens on 11.11.15
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

#import "adfresolver.h"
#import "EMUBrowser.h"
#import "EMUFileInfo.h"

// wrapper around EMUBrowser
const char* get_updated_adf_path(const char *adf_path) {
    NSString *adfPath = [NSString stringWithCString:adf_path encoding:[NSString defaultCStringEncoding]];
    NSString *updatedAdfPath = @"";
    if ([adfPath length] > 0) {
        NSString *adfFileName = [adfPath lastPathComponent];
        EMUBrowser *browser = [[[EMUBrowser alloc] init] autorelease];
        EMUFileInfo *fileInfo = [browser getFileInfoForFileName:adfFileName];
        if (fileInfo) {
            updatedAdfPath = fileInfo.path;
        }
    }
    static char adf[256];
    [updatedAdfPath getCString:adf maxLength:sizeof(adf) encoding:[NSString defaultCStringEncoding]];
    return adf;
}