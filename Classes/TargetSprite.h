/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the target sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Target sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpriteViewController.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Target sprite defs.
 *
 ******************************************************************************/

/*
 * Target sprite type enumeration.
 *
 *   TargetSpriteTypeEnemy      Target is a player enemy.
 */

typedef enum
{
    TargetSpriteTypePlayer      = 0,
    TargetSpriteTypeEnemy       = 1,
    TargetSpriteTypePowerUp     = 2
} TargetSpriteType;


/* *****************************************************************************
 *
 * Target sprite class definition.
 *
 * Properties:
 *
 *   health                     Target health.
 *   maxHealth                  Target maximum health.
 *
 ******************************************************************************/

@interface TargetSprite : SpriteViewController
{
    /*
     * mHealth                  Target health.
     * mMaxHealth               Target maximum health.
     *
     * mTargetTypeSet           Set of target types to which target sprite
     *                          belongs.
     * mHitSound                Sound to play when hit.
     * mDefeatPoints            Points added to score upon defeat.
     */

    float                       mHealth;
    float                       mMaxHealth;

    NSUInteger                  mTargetTypeSet;
    NSString*                   mHitSound;
    NSInteger                   mDefeatPoints;
}


/* Properties. */
@property(assign) float         health;
@property(assign) float         maxHealth;


/* Target sprite services. */
- (BOOL)isTargetType:(TargetSpriteType) aTargetType;

- (void)addTargetType:(TargetSpriteType) aTargetType;

- (void)handleDefeated:(SpriteViewController*) aDefeatingSprite;

- (void)powerUpHealth:(float) aHealthAmount;


@end


