/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the target sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Target sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "TargetSprite.h"

/* Local imports. */
#import "WJAudio.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Target sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation TargetSprite

/* Synthesize properties. */
@synthesize health = mHealth;
@synthesize maxHealth = mMaxHealth;


/* *****************************************************************************
 *
 * Target sprite SpriteViewController services.
 *
 ******************************************************************************/

/*
 * hit
 *
 *   ==> aSpriteViewController  Sprite that hit.
 *   ==> aDamage                Sprite damage.
 *
 *   This function handles sprite hits by the sprite specified by
 * aSpriteViewController with the damage specified by aDamage.
 */

- (void)hit:(SpriteViewController*) aSpriteViewController
    damage:(float)                  aDamage
{
    /* Play target hit sound. */
    if (mHitSound)
        [WJAudio playAudioFromResource:mHitSound ofType:nil];

    /* Adjust target health. */
    mHealth -= aDamage;
    if (mHealth < 0.0)
        mHealth = 0.0;

    /* If health drops to 0, handle the defeated event. */
    if (mHealth <= 0.0)
        [self handleDefeated:aSpriteViewController];
}


/* *****************************************************************************
 *
 * Target sprite services.
 *
 ******************************************************************************/

/*
 * isTargetType
 *
 *   ==> aTargetType            Target type for which to check.
 *
 *   <== YES                    Target sprite is of the specified type.
 *       NO                     Target sprite is not of the specified type.
 *
 *   This function checks if the target sprite is of the type specified by
 * aTargetType.  If it is, this function returns YES; otherwise, it returns NO.
 */

- (BOOL)isTargetType:(TargetSpriteType) aTargetType
{
    return (mTargetTypeSet & (1 << aTargetType));
}


/*
 * addTargetType
 *
 *   ==> aTargetType            Target type to add.
 *
 *  This function adds the target type specified by aTargetType to the set of
 * target sprite target types.
 */

- (void)addTargetType:(TargetSpriteType) aTargetType
{
    mTargetTypeSet |= 1 << aTargetType;
}


/*
 * handleDefeated
 *
 *   ==> aDefeatingSprite       Sprite that defeated target sprite.
 *
 *   This function handles a target sprite defeated event by the sprite
 * specified by aDefeatingSprite.
 */

- (void)handleDefeated:(SpriteViewController*) aDefeatingSprite
{
    /* Tally score for target. */
    if (mDefeatPoints)
        [self tallyScore:mDefeatPoints];

    /* Remove self from parent. */
    [mParentSprite removeChild:self];
}


/*
 * powerUpHealth
 *
 *   ==> aHealthAmount          Amount by which to power up health.
 *
 *   This function powers up the target sprite health by the amount specified by
 * aHealthAmount.
 */

- (void)powerUpHealth:(float) aHealthAmount
{
    /* Power up health, limited by max health. */
    mHealth += aHealthAmount;
    if (mHealth > mMaxHealth)
        mHealth = mMaxHealth;
}


@end


