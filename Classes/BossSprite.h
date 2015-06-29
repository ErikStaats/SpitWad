/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the boss sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Boss sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "TargetSprite.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Boss sprite class definition.
 *
 ******************************************************************************/

@interface BossSprite : TargetSprite
{
    /*
     * mBossImageFileName       Boss image file name.
     * mBossProjectileSpriteName
     *                          Name of boss projectile sprite.
     *
     * mPrevShootTime           Previous shooting time.
     */

    NSString*                   mBossImageFileName;
    NSString*                   mBossProjectileSpriteName;

    NSTimeInterval              mPrevShootTime;
}

/* Boss sprite services. */
- (void)configureBoss;


/* Internal methods. */
- (void)shoot:(float) aShotXVelocityFactor;

@end


