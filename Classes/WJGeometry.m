/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the Windjay geometry services.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Windjay geometry services imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "WJGeometry.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Windjay point class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation WJPoint

/* Synthesize properties. */
@synthesize point = mPoint;


/*
 * get
 *
 *   ==> aCoord                 X and y coordinate values of point of type
 *                              double.
 *
 *   <==                        Windjay point.
 *
 *   This function returns a Windjay point as specified by the coordinates
 * aCoord.
 *
 * Example:
 *
 *   WJPoint* point = [WJPoint get:1.0, 2.0];
 */

+ (id)get:(double)aCoord,...
{
    /* Get the argument list. */
    va_list argList;
    va_start(argList, aCoord);

    /* Get the point. */
    CGPoint point;
    point.x = aCoord;
    point.y = va_arg(argList, double);

    /* End argument list. */
    va_end(argList);

    return [[[WJPoint alloc] initWithPoint:point] autorelease];
}


/*
 * initWithPoint
 *
 *   ==> aPoint                 Point with which to initialize.
 *
 *   <==                        Initialized Windjay point.
 *
 *   This function initializes and returns a Windjay point as specified by
 * aPoint.
 */

- (id)initWithPoint:(CGPoint) aPoint
{
    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    /* Get the point. */
    mPoint = aPoint;

    return self;
}


@end


