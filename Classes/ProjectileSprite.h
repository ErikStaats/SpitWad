/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the projectile sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Projectile sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpriteViewController.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Projectile sprite class definition.
 *
 * Properties:
 *
 *   shooter                    Sprite that shot projectile.
 *   shotSoundFileName          Name of projectile shot sound file.
 *
 ******************************************************************************/

@interface ProjectileSprite : SpriteViewController
{
    /*
     * mShooter                 Sprite that shot projectile.
     * mShotSoundFileName       Name of projectile shot sound file.
     *
     * mDamage                  Amount of damage dealt by the projectile.
     */

    SpriteViewController*       mShooter;
    NSString*                   mShotSoundFileName;

    float                       mDamage;
}

/* Properties. */
@property(assign) SpriteViewController* shooter;
@property(retain) NSString*             shotSoundFileName;


/* Projectile sprite services. */
- (id)initWithShooter:(SpriteViewController*) aShooter;

- (BOOL)canHit:(SpriteViewController*)aTargetSprite;

@end


