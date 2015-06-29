/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the weak reference proxy.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Weak reference proxy imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "WeakReferenceProxy.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Weak reference proxy class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation WeakReferenceProxy

/* Synthesize properties. */
@synthesize target = mTarget;


/* *****************************************************************************
 *
 * Weak reference proxy NSObject services.
 *
 ******************************************************************************/

/*
 * forwardInvocation
 *
 *   aInvocation                The invocation to forward.
 *
 *   Overridden by subclasses to forward messages to other objects.
 */

- (void)forwardInvocation:(NSInvocation*) aInvocation
{
    [aInvocation invokeWithTarget:mTarget];
}


/*
 * respondsToSelector
 *
 *   ==> aSelector              A selector that identifies a message.
 *
 *   <== YES                    The receiver implements or inherits a method
 *                              that can respond to aSelector
 *
 *   Returns a Boolean value that indicates whether the receiver implements or
 * inherits a method that can respond to a specified message.
 */

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [mTarget respondsToSelector:aSelector];
}


/*
 * methodSignatureForSelector
 *
 *   ==> aSelector              A selector that identifies the method for which
 *                              to return the implementation address.
 *
 *   Returns an NSMethodSignature object that contains a description of the
 * method identified by a given selector.
 */

- (NSMethodSignature*) methodSignatureForSelector:(SEL)aSelector
{
    return [mTarget methodSignatureForSelector:aSelector];
}


@end


