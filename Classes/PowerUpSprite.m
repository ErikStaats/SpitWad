/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the power-up sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Power-up sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "PowerUpSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Power-up sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation PowerUpSprite

/* Synthesize properties. */
@synthesize lifeTime = mLifeTime;


/* *****************************************************************************
 *
 * Power-up sprite NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Power-up sprite SpriteViewController services.
 *
 ******************************************************************************/

/*
 * step
 *
 *   ==> aStepTime              Time of step.
 *
 *   This function steps the sprite to the time specified by aStepTime.
 */

- (void)step:(NSTimeInterval) aStepTime
{
    /* Initialize the sprite start time. */
    if (!mSpriteStartTime)
        mSpriteStartTime = aStepTime;

    /* Remove power-up if it's expired. */
    NSTimeInterval spriteTime = aStepTime - mSpriteStartTime;
    if (mLifeTime && (spriteTime >= mLifeTime))
        [mParentSprite removeChild:self];

    /* Step the super class. */
    [super step:aStepTime];
}


@end


