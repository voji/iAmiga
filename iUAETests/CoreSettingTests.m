//  Created by Simon Toens on 11.05.16
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

#import <XCTest/XCTest.h>
#import "CoreSetting.h"

@interface CoreSettingTests : XCTestCase

@end

@implementation CoreSettingTests

- (void)tearDown {
    [CoreSettings onReset];
    [super tearDown];
}

- (void)testRomSettingSingleton {
    RomCoreSetting *rom1 = [CoreSettings romCoreSetting];
    RomCoreSetting *rom2 = [CoreSettings romCoreSetting];
    
    XCTAssertNotNil(rom1);
    XCTAssertTrue(rom1 == rom2);
}

- (void)testHasUnappliedValue {
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"v1" toNewValue:@"v2"];
    XCTAssertTrue([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

- (void)testHasUnappliedValue_backToOriginalValue {
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"v1" toNewValue:@"v2"];
    XCTAssertTrue([[CoreSettings romCoreSetting] hasUnappliedValue]);
    
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"v2" toNewValue:@"v3"];
    XCTAssertTrue([[CoreSettings romCoreSetting] hasUnappliedValue]);
    
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"v3" toNewValue:@"v1"];
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

- (void)testToggleSameValue {
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"v101" toNewValue:@"v101"];
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

- (void)testToggleSameValue_nils {
    [[CoreSettings romCoreSetting] toggleFromOldValue:nil toNewValue:nil];
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

- (void)testOldValueIsNil {
    [[CoreSettings romCoreSetting] toggleFromOldValue:nil toNewValue:@"new"];
    XCTAssertTrue([[CoreSettings romCoreSetting] hasUnappliedValue]);
    
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"new" toNewValue:nil];
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

- (void)testNewValueIsNil {
    [[CoreSettings romCoreSetting] toggleFromOldValue:@"old" toNewValue:nil];
    XCTAssertTrue([[CoreSettings romCoreSetting] hasUnappliedValue]);
    
    [[CoreSettings romCoreSetting] toggleFromOldValue:nil toNewValue:@"old"];
    XCTAssertFalse([[CoreSettings romCoreSetting] hasUnappliedValue]);
}

@end
