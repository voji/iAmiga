//  Created by Simon Toens on 04.10.16
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

#include "sysconfig.h"
#include "sysdeps.h"
#include "options.h"
#include "fame.h"
#include "audio.h"

#import "AudioService.h"

@implementation AudioService

- (void)setVolume:(float)volume {
    set_audio_volume(volume);
}

- (float)getVolume {
    return get_audio_volume();
}

@end
