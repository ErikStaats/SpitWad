/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the power-up sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Power-up sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "TargetSprite.h"


/* *****************************************************************************
 *
 * Power-up sprite class definition.
 *
 * Properties:
 *
 *   lifeTime                   Life time of power-up.  The power-up will never
 *                              expire if the life time is set to 0.
 *
 ******************************************************************************/

@interface PowerUpSprite : TargetSprite
{
    /*
     * mLifeTime                Life time of power-up.
     *
     * mSpriteStartTime         Starting sprite step time.
     */

    NSTimeInterval              mLifeTime;

    NSTimeInterval              mSpriteStartTime;
}


/* Properties. */
@property(assign) NSTimeInterval    lifeTime;


@end


