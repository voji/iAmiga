//
//  MPCConnectionStates.h
//  iUAE
//
//  Created by mithrendil on 25.02.16.
//
//

#ifndef MPCConnectionStates_h
#define MPCConnectionStates_h

typedef NS_ENUM(int, MPCStateType) {
    kConnectionIsOff = 0,
    kServeAsHostForIncomingJoypadSignals= 1,
    kServeAsController = 2,
} ;
#endif /* MPCConnectionStates_h */
