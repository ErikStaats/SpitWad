/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the base projectile sprites.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base projectile sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "ProjectileBaseSprite.h"

/* Local imports. */
#import "TargetSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Enemy projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface ProjectileEnemySprite : ProjectileBaseSprite
@end

@implementation ProjectileEnemySprite

/*
 * canHit
 *
 *   ==> aTargetSprite          Target sprite to check.
 *
 *   <== YES                    Target sprite can be hit.
 *       NO                     Target sprite cannot be hit.
 *
 *   This function checks if the target sprite specified by aTargetSprite can be
 * hit.  If it can, this function returns YES; otherwise, it returns NO.
 */

- (BOOL)canHit:(SpriteViewController*)aTargetSprite
{
    /* Can only hit target sprites. */
    if (![aTargetSprite isKindOfClass:[TargetSprite class]])
        return NO;
    TargetSprite* targetSprite = (TargetSprite*) aTargetSprite;

    /* Can only hit players. */
    return [targetSprite isTargetType:TargetSpriteTypePlayer];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Ball projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface ProjectileBallSprite : ProjectileEnemySprite
@end

@implementation ProjectileBallSprite

/*
 * configureProjectile
 *
 *   This function sets up the projectile configuration.
 */

- (void)configureProjectile
{
    /* Invoke the super-class. */
    [super configureProjectile];

    /* Configure the projectile. */
    mDamage = 20.0;
    mProjectileImageFileName = @"ball16.png";
    mShotSoundFileName = @"BallShot.aif";
}


@end
/* *****************************************************************************
 *******************************************************************************
 *
 * Whistle projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface ProjectileWhistleSprite : ProjectileEnemySprite
@end

@implementation ProjectileWhistleSprite

/*
 * configureProjectile
 *
 *   This function sets up the projectile configuration.
 */

- (void)configureProjectile
{
    /* Invoke the super-class. */
    [super configureProjectile];
	
    /* Configure the projectile. */
    mDamage = 20.0;
    mProjectileImageFileName = @"whistle.png";
    mShotSoundFileName = @"whistle.aif";
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Player projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface ProjectilePlayerSprite : ProjectileBaseSprite
@end

@implementation ProjectilePlayerSprite

/*
 * canHit
 *
 *   ==> aTargetSprite          Target sprite to check.
 *
 *   <== YES                    Target sprite can be hit.
 *       NO                     Target sprite cannot be hit.
 *
 *   This function checks if the target sprite specified by aTargetSprite can be
 * hit.  If it can, this function returns YES; otherwise, it returns NO.
 */

- (BOOL)canHit:(SpriteViewController*)aTargetSprite
{
    /* Can only hit target sprites. */
    if (![aTargetSprite isKindOfClass:[TargetSprite class]])
        return NO;
    TargetSprite* targetSprite = (TargetSprite*) aTargetSprite;

    /* Can only hit enemies and power-ups. */
    return    [targetSprite isTargetType:TargetSpriteTypeEnemy]
           || [targetSprite isTargetType:TargetSpriteTypePowerUp];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface ProjectileSpitWadSprite : ProjectilePlayerSprite
@end

@implementation ProjectileSpitWadSprite

/*
 * configureProjectile
 *
 *   This function sets up the projectile configuration.
 */

- (void)configureProjectile
{
    /* Invoke the super-class. */
    [super configureProjectile];

    /* Configure the projectile. */
    mDamage = 20.0;
    mProjectileImageFileName = @"spitWad16.png";
    mShotSoundFileName = @"spit.aif";
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Base projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation ProjectileBaseSprite

/* *****************************************************************************
 *
 * Base projectile sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the base projectile sprite.
 */

- (id)init
{
    /* Configure the projectile. */
    [self configureProjectile];

    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the base projectile sprite view. */
    UIImageView* baseProjectileView =
        [[UIImageView alloc] initWithImage:
                                [UIImage imageNamed:mProjectileImageFileName]];
    self.spriteView = baseProjectileView;

    /* Release objects. */
    [baseProjectileView release];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Release object references. */
    [mProjectileImageFileName release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Base projectile sprite services.
 *
 ******************************************************************************/

/*
 * configureProjectile
 *
 *   This function sets up the projectile configuration.
 */

- (void)configureProjectile
{
}


@end


