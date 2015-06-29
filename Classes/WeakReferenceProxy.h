/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the weak reference proxy.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Weak reference proxy imported services.
 *
 ******************************************************************************/

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Weak reference proxy class definition.
 *
 *   A weak reference proxy forwards messages to a target object.  The proxy
 * maintains a weak reference to the target object.  Weak reference proxy
 * objects may be used in place of the target object so that strong references
 * are made to the proxy, not the proxy target.  This is useful for avoiding
 * retain cycles.
 *
 *   target                     Proxy target.
 *
 ******************************************************************************/

@interface WeakReferenceProxy : NSObject
{
    id                          mTarget;
}

@property(assign) id target;

@end

