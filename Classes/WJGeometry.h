/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the Windjay geometry services.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Windjay point class definition.
 *
 * Properties:
 *
 *   point                      Point value.
 *
 ******************************************************************************/

@interface WJPoint : NSObject
{
    /*
     * mPoint                   Point value.
     */

    CGPoint                     mPoint;
}


/* Properties. */
@property(assign) CGPoint       point;


/* Windjay point services. */
+ (id)get:(double)aCoord,...;

- (id)initWithPoint:(CGPoint) aPoint;


@end


