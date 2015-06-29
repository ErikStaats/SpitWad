/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the base enemy sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base enemy sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "TargetSprite.h"


/* *****************************************************************************
 *
 * Base enemy sprite class definition.
 *
 ******************************************************************************/

@interface EnemyBaseSprite : TargetSprite
{
    /*
     * mEnemyImageFileName      Enemy image file name.
     * mEnemyProjectileSpriteName
     *                          Enemy projectile sprite name.
     * mEnemyShootPeriod        Enemy projectile shooting period.
     * mEnemyProjectileSpeed    Speed of enemy projectiles.
     *
     * mPrevShootTime           Time previous projectile was shot.
     */

    NSString*                   mEnemyImageFileName;
    NSString*                   mEnemyProjectileSpriteName;
    float                       mEnemyShootPeriod;
    float                       mEnemyProjectileSpeed;

    NSTimeInterval              mPrevShootTime;
}


/* Base enemy sprite services. */
- (void)configureEnemy;


/* Internal base enemy sprite services. */
- (void)shoot;


@end


