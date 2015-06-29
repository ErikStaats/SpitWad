/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the projectile sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Projectile sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "ProjectileSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Projectile sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation ProjectileSprite

/* Synthesize properties. */
@synthesize shooter = mShooter;
@synthesize shotSoundFileName = mShotSoundFileName;


/* *****************************************************************************
 *
 * Projectile sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the projectile sprite.
 */

- (id)init
{
    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

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
    [mShotSoundFileName release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Projectile sprite SpriteViewController services.
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
    /* Step the super class. */
    [super step:aStepTime];

    /* Get the list of projectile collisions. */
    NSArray* collisionList = [mParentSprite getCollisionList:self];

    /* Send hit notification to all hittable sprites in collision list. */
    int collisionCount = collisionList.count;
    NSUInteger hitCount = 0;
    for (int i = 0; i < collisionCount; i++)
    {
        /* Get the next target sprite. */
        SpriteViewController* targetSprite = [collisionList objectAtIndex:i];

        /* Hit the target sprite if it's hittable by self. */
        if ([self canHit:targetSprite])
        {
            [targetSprite hit:self damage:mDamage];
            hitCount++;
        }
    }

    /* If the projectile hit anything or left the parent view, remove it. */
    /* and notify the sprite view of the hit.  */
    if ((hitCount > 0) || [mParentSprite leftView:self])
        [mParentSprite removeChild:self];
}


/* *****************************************************************************
 *
 * Projectile sprite services.
 *
 ******************************************************************************/

/*
 * initWithShooter
 *
 *   ==> aShooter               Sprite that shot projectile.
 *
 *   This function initializes the projectile sprite with the shooter specified
 * by aShooter.
 */

- (id)initWithShooter:(SpriteViewController*) aShooter
{
    /* Perform default initialization. */
    self = [self init];
    if (!self)
        return nil;

    /* Set the shooter. */
    self.shooter = aShooter;

    return self;
}


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
    /* Default to being able to hit everything. */
    return YES;
}


@end


