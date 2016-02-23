//
//  od-joy.h
//  iUAE
//
//  Created by mithrendal on 16.02.16.
//
//
#ifndef __MYOBJECT_C_INTERFACE_H__
#define __MYOBJECT_C_INTERFACE_H__

// This is the C "trampoline" function that will be used
// to invoke a specific Objective-C method FROM C++
void sendJoystickDataToServer (void *myObjectInstance, unsigned int ijoydir);
#endif