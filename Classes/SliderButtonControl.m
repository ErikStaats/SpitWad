/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the slider button control.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Slider button control imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SliderButtonControl.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Slider button control class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SliderButtonControl

/* Synthesize properties. */
@synthesize sliderXFactor = mSliderXFactor;
@synthesize sliderYFactor = mSliderYFactor;
@synthesize isButtonDown = mIsButtonDown;
@synthesize sliderButtonControlDelegate = mSliderButtonControlDelegate;


/* *****************************************************************************
 *
 * Slider button control NSObject implementation.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Call the super-class dealloc. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Slider button control UIResponder services.
 *
 ******************************************************************************/

/*
 * touchesBegan:withEvent:
 *
 *   ==> aTouches               An set of UITouch instances that represent the
 *                              touches for the starting phase of the event
 *                              represented by event.
 *   ==> aEvent                 An object representing the event to which the
 *                              touches belong.
 *
 *   Tells the receiver when one or more fingers touch down in a view or window.
 */

- (void)touchesBegan:(NSSet*)   aTouches
    withEvent:(UIEvent*)        aEvent
{
    /* Get a single touch object. */
    UITouch* touch = [aTouches anyObject];

    /* Update the slider position. */
    CGPoint location = [touch locationInView:self];
    mSliderXFactor =   (location.x - self.bounds.origin.x)
                     / self.bounds.size.width;
    mSliderYFactor =   (location.y - self.bounds.origin.y)
                     / self.bounds.size.height;

    /* Update the slider button state. */
    mIsButtonDown = YES;

    /* Notify the delegate of the change. */
    [mSliderButtonControlDelegate sliderButtonControlChanged:self];
}


/*
 * touchesMoved
 *
 *   ==> aTouches               A set of UITouch instances that
 *                              represents the touches that are moving during
 *                              the event represented by aEvent.
 *   ==> aEvent                 An object representing the event to which the
 *                              touches belong.
 *
 *   Tells the receiver when one or more fingers associated with an event move
 * within a view or window.
 */

- (void)touchesMoved:(NSSet*)   aTouches
    withEvent:(UIEvent*)        aEvent
{
    /* Get a single touch object. */
    UITouch* touch = [aTouches anyObject];

    /* Update the slider position. */
    CGPoint location = [touch locationInView:self];
    mSliderXFactor =   (location.x - self.bounds.origin.x)
                     / self.bounds.size.width;
    mSliderYFactor =   (location.y - self.bounds.origin.y)
                     / self.bounds.size.height;

    /* Notify the delegate of the change. */
    [mSliderButtonControlDelegate sliderButtonControlChanged:self];
}


/*
 * touchesEnded
 *
 *   ==> aTouches               A set of UITouch instances that represents the
 *                              touches for the ending phase of the event
 *                              represented by aEvent.
 *   ==> aEvent                 An object representing the event to which the
 *                              touches belong.
 *
 *   Tells the receiver when one or more fingers are raised from a view or
 * window.
 */

- (void)touchesEnded:(NSSet*)   aTouches
    withEvent:(UIEvent*)        aEvent
{
    /* Update the slider button state. */
    mIsButtonDown = NO;

    /* Notify the delegate of the change. */
    [mSliderButtonControlDelegate sliderButtonControlChanged:self];
}


@end


