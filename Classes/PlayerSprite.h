/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the player sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Player sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "TargetSprite.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Player sprite class definition.
 *
 ******************************************************************************/

@interface PlayerSprite : TargetSprite <SpriteNotificationDelegate>
{
    /*
     * mPlayerProjectileSpriteName
     *                          Name of player projectile sprite.
     *
     * mInitialPositionSet      True if the initial sprite position has been
     *                          set.
     * mPrevShootTime           Previous shooting time.
     * mIsShooting              YES if player sprite is shooting.
     * mShotsToFire             Number of shots left to fire.
     */

    NSString*                   mPlayerProjectileSpriteName;

    BOOL                        mInitialPositionSet;
    NSTimeInterval              mPrevShootTime;
    BOOL                        mIsShooting;
    NSInteger                   mShotsToFire;
}


/* Player sprite class services. */
+ (void)addPlayerSprite:(PlayerSprite*) aPlayerSprite;

+ (void)removePlayerSprite:(PlayerSprite*) aPlayerSprite;

+ (NSArray*)playerSpriteList;


/* Player sprite services. */
- (void)startShooting;

- (void)stopShooting;


/* Player sprite handlers. */
- (void)handleMoveAction:(id) aSender
    moveSpeedXFactor:(float)  aMoveSpeedXFactor
    moveSpeedYFactor:(float)  aMoveSpeedYFactor;

- (void)handleMoveToAction:(id) aSender
    moveToXFactor:(float)       aMoveToXFactor
    moveToYFactor:(float)       aMoveToYFactor;


/* Internal player sprite services. */
- (void)shoot;


@end


