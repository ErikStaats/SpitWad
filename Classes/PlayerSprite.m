/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the player sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Player sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "PlayerSprite.h"

/* Local imports. */
#import "WJAudio.h"
#import "ProjectileSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Player sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation PlayerSprite

/*
 * Player sprite class configuration.
 *
 *   PLAYER_SPEED                   Speed of the player.
 *   PLAYER_HIT_SOUND               Sound to play when player is hit.
 *   PLAYER_PROJECTILE_SPEED        Speed of player projectile.
 *   PLAYER_SHOOT_PERIOD            Period of player shooting in seconds.
 *   PLAYER_MAX_HEALTH              Maximum player health.
 */

#define PLAYER_SPEED                    100.0
#define PLAYER_HIT_SOUND                @"PlayerHit.aif"
#define PLAYER_PROJECTILE_SPEED         200.0
#define PLAYER_SHOOT_PERIOD             0.5
#define PLAYER_MAX_HEALTH               100.0


/* *****************************************************************************
 *
 * Player sprite class services.
 *
 ******************************************************************************/

/*
 * gPlayerSpriteList            List of player sprites.
 */

static NSMutableArray* gPlayerSpriteList;


/*
 * initialize
 *
 *   This function initializes the player sprite class.
 */

+ (void)initialize
{
    /* Don't initialize if sub-class is being initialized. */
    if (self != [PlayerSprite class])
        return;

    /* Create the player sprite list. */
    gPlayerSpriteList = [[NSMutableArray alloc] initWithCapacity:0];
}


/*
 * addPlayerSprite
 *
 *   ==> aPlayerSprite          Player sprite to add.
 *
 *   This function adds the player sprite specified by aPlayerSprite to the list
 * of player sprites.
 */

+ (void)addPlayerSprite:(PlayerSprite*) aPlayerSprite
{
    [gPlayerSpriteList addObject:aPlayerSprite];
}


/*
 * removePlayerSprite
 *
 *   ==> aPlayerSprite          Player sprite to remove.
 *
 *   This function removes the player sprite specified by aPlayerSprite from the
 * list of player sprites.
 */

+ (void)removePlayerSprite:(PlayerSprite*) aPlayerSprite
{
    [gPlayerSpriteList removeObject:aPlayerSprite];
}


/*
 * playerSpriteList
 *
 *   <==                        List of player sprites.
 *
 *   This function returns the list of player sprites.
 */

+ (NSArray*)playerSpriteList
{
    return [[gPlayerSpriteList retain] autorelease];
}


/* *****************************************************************************
 *
 * Player sprite services.
 *
 ******************************************************************************/

/*
 * startShooting.
 *
 *   This function starts the player sprite shooting.
 */

- (void)startShooting
{
    /* Start shooting with one shot. */
    mIsShooting = YES;
    mShotsToFire = 1;
}


/*
 * stopShooting
 *
 *   This function stops the player sprite shooting.
 */

- (void)stopShooting
{
    /* Stop shooting. */
    mIsShooting = NO;
}


/* *****************************************************************************
 *
 * Player sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the player sprite.
 */

- (id)init
{
    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the player target properties. */
    mHealth = PLAYER_MAX_HEALTH;
    mMaxHealth = PLAYER_MAX_HEALTH;
    mHitSound = PLAYER_HIT_SOUND;
    [self addTargetType:TargetSpriteTypePlayer];
    mPlayerProjectileSpriteName = @"ProjectileSpitWadSprite";

    /* Player sprite cannot leave the view. */
    mCantLeaveView = YES;

    /* Set the player sprite view. */
    UIImageView* playerView =
                        [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"spitter.png"]];
    self.spriteView = playerView;

    /* Add self to list of player sprites. */
    [PlayerSprite addPlayerSprite:(PlayerSprite*)mSelfProxy];

    /* Release objects. */
    [playerView release];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Remove self from list of player sprites. */
    [PlayerSprite removePlayerSprite:(PlayerSprite*)mSelfProxy];

    /* Release object references. */
    [mPlayerProjectileSpriteName release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Player sprite SpriteNotificationDelegate services.
 *
 ******************************************************************************/

/*
 * spriteAdded
 *
 *   ==> aSprite                Sprite that has been added.
 *
 *   This notification is sent when the sprite specified by aSprite has been
 * added as a child of another sprite.
 */

- (void)spriteAdded:(SpriteViewController*) aSprite
{
    /* Reset the sprite time. */
    /*zzz should be a better way to do this. */
    mPrevShootTime = 0.0;

    /* Set the initialize position of the sprite */
    /* at the bottom middle of the parent.       */
    if (!mInitialPositionSet)
    {
        /* Get the sprite and its parent geometry. */
        CGRect spriteBounds = self.spriteView.bounds;
        CGPoint parentCenter = mParentSprite.spriteView.center;
        CGRect parentFrame = mParentSprite.spriteView.frame;

        /* Position the sprite at the bottom middle of the parent. */
        CGPoint spriteCenter;
        spriteCenter.x = parentCenter.x;
        spriteCenter.y = CGRectGetMaxY(parentFrame) - spriteBounds.size.height/2.0;
        self.spriteView.center = spriteCenter;

        /* The initial position has been set. */
        mInitialPositionSet = YES;
    }

    /* Invoke super-class. */
    [super spriteAdded:aSprite];
}


/*
 * beforeSpriteRemoved
 *
 *   ==> aSprite                Sprite that is about to be removed.
 *
 *   This notification is sent before the sprite specified by aSprite is removed
 * as a child of another sprite.
 */

- (void)beforeSpriteRemoved:(SpriteViewController*) aSprite
{
    /* Invoke super-class. */
    [super beforeSpriteRemoved:aSprite];
}


/* *****************************************************************************
 *
 * Player sprite SpriteViewController services.
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
    /* Check if it's time to fire a shot. */
    NSTimeInterval shootTimeInterval = aStepTime - mPrevShootTime;
    if (shootTimeInterval >= PLAYER_SHOOT_PERIOD)
    {
        /* Fire another shot if still shooting. */
        if (mIsShooting)
            mShotsToFire = 1;

        /* Check if a shot should be fired. */
        if (mShotsToFire > 0)
        {
            [self shoot];
            mShotsToFire--;
            mPrevShootTime = aStepTime;
        }
    }

    /* Step the super class. */
    [super step:aStepTime];
}


/* *****************************************************************************
 *
 * Player sprite handlers.
 *
 ******************************************************************************/

/*
 * handleMoveAction
 *
 *   ==> aSender                Sender of move action.
 *   ==> aMoveSpeedXFactor      Movement speed factors.
 *       aMoveSpeedYFactor
 *
 *   This function handles the player move action specified by aMoveSpeedXFactor
 * and aMoveSpeedYFactor from the sender specified by aSender.  Each factor is
 * in the range of -1.0 to 1.0, specifying the factors to apply to the maximum
 * player speed.
 */

- (void)handleMoveAction:(id) aSender
    moveSpeedXFactor:(float)  aMoveSpeedXFactor
    moveSpeedYFactor:(float)  aMoveSpeedYFactor
{
    /* Set the player velocity. */
    mVelocityX = aMoveSpeedXFactor * PLAYER_SPEED;
}


/*
 * handleMoveToAction
 *
 *   ==> aSender                Sender of move to action.
 *   ==> aMoveToXFactor         Movement target factors.
 *       aMoveToYFactor
 *
 *   This function handles the player move to action specified by aMoveToXFactor
 * and aMoveToYFactor from the sender specified by aSender.  Each factor is
 * in the range of 0.0 to 1.0, specifying the factors to apply to the player
 * target position within its range of movement.
 */

- (void)handleMoveToAction:(id) aSender
    moveToXFactor:(float)       aMoveToXFactor
    moveToYFactor:(float)       aMoveToYFactor
{
    /* Set player sprite target. */
    CGPoint target;
    target.y = mSpriteView.center.y;
    target.x =   (aMoveToXFactor * mSpriteView.superview.bounds.size.width)
               + mSpriteView.superview.bounds.origin.x;
    [self setTarget:target speed:PLAYER_SPEED];
}


/* *****************************************************************************
 *
 * Internal player sprite services.
 *
 ******************************************************************************/

/*
 * shoot
 *
 *   This function shoots a projectile.
 */

- (void)shoot
{
    /* Create a projectile sprite. */
    id projectileSpriteClass =
                        objc_getClass([mPlayerProjectileSpriteName UTF8String]);
    ProjectileSprite* projectileSprite = [[projectileSpriteClass alloc]
                                                        initWithShooter:self];
    projectileSprite.velocityY = -PLAYER_PROJECTILE_SPEED;

    /* Get the player and projectile geometries. */
    CGRect selfFrame = self.spriteView.frame;
    CGPoint selfCenter = self.spriteView.center;
    CGRect projectileBounds = projectileSprite.spriteView.bounds;

    /* Position the projectile above the player. */
    CGPoint projectileCenter;
    projectileCenter.x = selfCenter.x;
    projectileCenter.y =   CGRectGetMinY(selfFrame)
                         - projectileBounds.size.height/2.0;
    projectileSprite.spriteView.center = projectileCenter;

    /* Add the projectile sprite. */
    [mParentSprite addChild:projectileSprite];

    /* Play shot sound. */
    [WJAudio playAudioFromResource:projectileSprite.shotSoundFileName ofType:nil];

    /* Release objects. */
    [projectileSprite release];
}


@end


