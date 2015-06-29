/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the base enemy sprites.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base enemy sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "EnemyBaseSprite.h"

/* Local imports. */
#import "PlayerSprite.h"
#import "ProjectileSprite.h"
#import "WJAudio.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Bully enemy sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface BullySprite : EnemyBaseSprite
@end

@implementation BullySprite

/*
 * configureEnemy
 *
 *   This function sets up the enemy configuration.
 */

- (void)configureEnemy
{
    /* Invoke the super-class. */
    [super configureEnemy];

    /* Configure the enemy. */
    mMaxHealth = 20.0;
    mHealth = mMaxHealth;
    mHitSound = @"BullyHit.aif";
    mDefeatPoints = 20;
    mEnemyImageFileName = @"Bully.png";
    mEnemyProjectileSpriteName = @"ProjectileBallSprite";
    mEnemyShootPeriod = 4.0;
    mEnemyProjectileSpeed = 200.0;
    self.acceleration = 500.0;
    self.targetSpeed = 100.0;
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * Bully2 enemy sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface Bully2Sprite : EnemyBaseSprite
@end

@implementation Bully2Sprite

/*
 * configureEnemy
 *
 *   This function sets up the enemy configuration.
 */

- (void)configureEnemy
{
    /* Invoke the super-class. */
    [super configureEnemy];
	
    /* Configure the enemy. */
    mMaxHealth = 40.0;
    mHealth = mMaxHealth;
    mHitSound = @"BullyHit.aif";
    mDefeatPoints = 20;
    mEnemyImageFileName = @"bully2.png";
    mEnemyProjectileSpriteName = @"ProjectileBallSprite";
    mEnemyShootPeriod = 4.0;
    mEnemyProjectileSpeed = 200.0;
    self.acceleration = 500.0;
    self.targetSpeed = 100.0;
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Base enemy sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation EnemyBaseSprite

/* *****************************************************************************
 *
 * Base enemy sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the base enemy sprite.
 */

- (id)init
{
    /* Configure the enemy. */
    [self configureEnemy];

    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the base enemy sprite view. */
    UIImageView* baseEnemyView =
                [[UIImageView alloc]
                    initWithImage: [UIImage imageNamed:mEnemyImageFileName]];
    self.spriteView = baseEnemyView;

    /* Release objects. */
    [baseEnemyView release];

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
    [mEnemyImageFileName release];
    [mEnemyProjectileSpriteName release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Base enemy sprite SpriteViewController services.
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
    /* Set previous shooting time to a valid time. */
    if (mPrevShootTime == 0.0)
        mPrevShootTime = aStepTime;

    /* Check if a projectile should be shot. */
    NSTimeInterval shootTimeInterval = aStepTime - mPrevShootTime;
    if (shootTimeInterval >= mEnemyShootPeriod)
    {
        /* Shoot and update previous shooting time. */
        [self shoot];
        mPrevShootTime = aStepTime;
    }

    /* Step the super class. */
    [super step:aStepTime];
}


/* *****************************************************************************
 *
 * Base enemy sprite services.
 *
 ******************************************************************************/

/*
 * configureEnemy
 *
 *   This function sets up the enemy configuration.
 */

- (void)configureEnemy
{
    /* Configure the enemy. */
    [self addTargetType:TargetSpriteTypeEnemy];
}


/* *****************************************************************************
 *
 * Internal base enemy sprite services.
 *
 ******************************************************************************/

/*
 * shoot
 *
 *   This function shoots a projectile.
 */

- (void)shoot
{
    /* Get the player sprite.  Do nothing if no player sprite. */
    NSArray* playerSpriteList = [PlayerSprite playerSpriteList];
    if (!playerSpriteList.count)
        return;
    PlayerSprite* playerSprite = [playerSpriteList objectAtIndex:0];

    /* Create a projectile sprite. */
    id projectileSpriteClass =
                        objc_getClass([mEnemyProjectileSpriteName UTF8String]);
    ProjectileSprite* projectileSprite = [[projectileSpriteClass alloc] init];

    /* Get the enemy and projectile geometries. */
    CGRect selfFrame = self.spriteView.frame;
    CGPoint selfCenter = self.spriteView.center;
    CGRect projectileBounds = projectileSprite.spriteView.bounds;

    /* Position the projectile below the enemy. */
    CGPoint projectileCenter;
    projectileCenter.x = selfCenter.x;
    projectileCenter.y =   CGRectGetMaxY(selfFrame)
                         + projectileBounds.size.height/2.0;
    projectileSprite.spriteView.center = projectileCenter;

    /* Get the distance to the player sprite. */
    CGPoint playerCenter = playerSprite.spriteView.center;
    CGFloat playerDist =   (playerCenter.x - projectileCenter.x)
                         * (playerCenter.x - projectileCenter.x);
    playerDist +=   (playerCenter.y - projectileCenter.y)
                  * (playerCenter.y - projectileCenter.y);
    playerDist = sqrt(playerDist);

    /* Shoot the projectile towards the player. */
    projectileSprite.velocityX =
                          mEnemyProjectileSpeed
                        * ((playerCenter.x - projectileCenter.x) / playerDist);
    projectileSprite.velocityY =
                          mEnemyProjectileSpeed
                        * ((playerCenter.y - projectileCenter.y) / playerDist);

    /* Add the projectile sprite. */
    [mParentSprite addChild:projectileSprite];

    /* Play shot sound. */
    [WJAudio playAudioFromResource:projectileSprite.shotSoundFileName
             ofType:nil];

    /* Release objects. */
    [projectileSprite release];
}


@end


