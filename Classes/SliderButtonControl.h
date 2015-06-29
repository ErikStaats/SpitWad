/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the slider button control.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Slider button control imported services.
 *
 ******************************************************************************/

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Slider button control delegate protocol definition.
 *
 ******************************************************************************/

@class SliderButtonControl;

@protocol SliderButtonControlDelegate

/* Mark all methods as optional. */
@optional

/*
 * sliderButtonControlChanged
 *
 *   ==> aSliderButtonControl   Slider button control that changed.
 *
 *   This method is called when the slider button control specified by
 * aSliderButtonControl has changed.
 */

- (void) sliderButtonControlChanged:(SliderButtonControl*) aSliderButtonControl;

@end


/* *****************************************************************************
 *
 * Slider button control class definition.
 *
 * Properties:
 *
 *   sliderXFactor              X and y slider position factors, ranging from
 *   sliderYFactor              0.0 to 1.0.
 *   isButtonDown               If YES, slider button is down.
 *   sliderButtonControlDelegate Delegate for receiving slider button control
 *                              events.
 *
 ******************************************************************************/

@interface SliderButtonControl : UIView
{
    /*
     *   mSliderXFactor         X and y slider position factors, ranging from
     *   mSliderYFactor         0.0 to 1.0.
     *   mIsButtonDown          If YES, slider button is down.
     *   mSliderButtonControlDelegate
     *                          Delegate for receiving slider button control
     *                          events.
     */

    float                       mSliderXFactor;
    float                       mSliderYFactor;
    BOOL                        mIsButtonDown;
    id                          mSliderButtonControlDelegate;
}


/* Properties. */
@property(assign) float         sliderXFactor;
@property(assign) float         sliderYFactor;
@property(assign) BOOL          isButtonDown;
@property(assign) id<SliderButtonControlDelegate>
                                sliderButtonControlDelegate;


@end

