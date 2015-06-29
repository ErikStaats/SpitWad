/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the boss sprites.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Boss sprites imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "BossSprite.h"

/* Local imports. */
#import "WJAudio.h"
#import "ProjectileSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Bully boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface BullyBossSprite : BossSprite
@end

@implementation BullyBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];

    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"goodyuck.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"BullyBoss.png";
    mBossProjectileSpriteName = @"ProjectileBallSprite";
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Yard duty boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface YardDutyBossSprite : BossSprite
@end

@implementation YardDutyBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];

    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"yack.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"yardduty.png";
    mBossProjectileSpriteName = @"ProjectileWhistleSprite";
}


@end
/* *****************************************************************************
 *******************************************************************************
 *
 * Gym teacher boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface GymTeacherBossSprite : BossSprite
@end

@implementation GymTeacherBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];
	
    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"lowyuck.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"gymteacher.png";
    mBossProjectileSpriteName = @"ProjectileBallSprite";
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * Teacher boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface TeacherBossSprite : BossSprite
@end

@implementation TeacherBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];
	
    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"ooh.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"teacher.png";
    mBossProjectileSpriteName = @"ProjectileBallSprite";
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * Goth bully boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface GothBullyBossSprite : BossSprite
@end

@implementation GothBullyBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];
	
    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"yuck.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"gothbullyshort.png";
    mBossProjectileSpriteName = @"ProjectileBallSprite";
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * SmackBully boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface SmackBullyBossSprite : BossSprite
@end

@implementation SmackBullyBossSprite

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
    /* Invoke the super-class. */
    [super configureBoss];
	
    /* Configure the boss. */
    mHealth = 300.0;
    mHitSound = @"yuck.aif";
    mDefeatPoints = 1000;
    mBossImageFileName = @"SmackBully.png";
    mBossProjectileSpriteName = @"ProjectileBallSprite";
}


@end



/* *****************************************************************************
 *******************************************************************************
 *
 * Boss sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

/*
 * Boss sprite class configuration.
 *
 *   BOSS_SPEED                 Speed of the boss.
 *   BOSS_SHOOT_PERIOD          Period of boss shooting in seconds.
 *   BOSS_PROJECTILE_SPEED      Speed of boss projectile.
 *   BOSS_TARGET_Y_MARGIN       Y axis margin below top of screen for boss
 *                              target.
 */

#define BOSS_SPEED              50.0
#define BOSS_SHOOT_PERIOD       2.0
#define BOSS_PROJECTILE_SPEED   200.0
#define BOSS_TARGET_Y_MARGIN    25.0


@implementation BossSprite

/* *****************************************************************************
 *
 * Boss sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the boss sprite..
 */

- (id)init
{
    /* Configure the boss. */
    [self configureBoss];

    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the boss target properties. */
    [self addTargetType:TargetSpriteTypeEnemy];

    /* Set the boss sprite view. */
    UIImageView* bossView =
                    [[UIImageView alloc]
                        initWithImage:[UIImage imageNamed:mBossImageFileName]];
    self.spriteView = bossView;

    /* Release objects. */
    [bossView release];

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
    [mBossImageFileName release];
    [mBossProjectileSpriteName release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Boss sprite SpriteNotificationDelegate services.
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
    /* Start the sprite in the top-middle above the super-view. */
    CGPoint center;
    center.x = CGRectGetMidX(mSpriteView.superview.bounds);
    center.y =   CGRectGetMinY(mSpriteView.superview.bounds)
               - mSpriteView.bounds.size.height/2;
    mSpriteView.center = center;

    /* Move the sprite down into view below game info. */
    CGPoint target;
    target.x = CGRectGetMidX(mSpriteView.superview.bounds);
    target.y =   CGRectGetMinY(mSpriteView.superview.bounds)
               + mSpriteView.bounds.size.height/2
               + BOSS_TARGET_Y_MARGIN;
    [self setTarget:target speed:BOSS_SPEED];

    /* Invoke super-class. */
    [super spriteAdded:aSprite];
}


/* *****************************************************************************
 *
 * Boss sprite SpriteViewController services.
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
    /* Move the sprite between top-left and top-right. */
    if (!self.targetList.count)
    {
        CGPoint target;
        if (mSpriteView.center.x <= CGRectGetMidX(mSpriteView.superview.bounds))
        {
            target.x =   CGRectGetMaxX(mSpriteView.superview.bounds);
                       - mSpriteView.bounds.size.width/2;
        }
        else
        {
            target.x =   CGRectGetMinX(mSpriteView.superview.bounds);
                       + mSpriteView.bounds.size.width/2;
        }
        target.y =   CGRectGetMinY(mSpriteView.superview.bounds)
                   + mSpriteView.bounds.size.height/2
                   + BOSS_TARGET_Y_MARGIN;
        [self setTarget:target speed:BOSS_SPEED];
    }

    /* Set previous shooting time to a valid time. */
    if (mPrevShootTime == 0.0)
        mPrevShootTime = aStepTime;

    /* Check if projectiles should be shot. */
    NSTimeInterval shootTimeInterval = aStepTime - mPrevShootTime;
    if (shootTimeInterval >= BOSS_SHOOT_PERIOD)
    {
        /* Shoot and update previous shooting time. */
        [self shoot:-0.3];
        [self shoot:0.0];
        [self shoot:0.3];
        mPrevShootTime = aStepTime;
    }

    /* Step the super class. */
    [super step:aStepTime];
}


/* *****************************************************************************
 *
 * Boss sprite services.
 *
 ******************************************************************************/

/*
 * configureBoss
 *
 *   This function sets up the boss configuration.
 */

- (void)configureBoss
{
}


/* *****************************************************************************
 *
 * Internal boss sprite services.
 *
 ******************************************************************************/

/*
 * shoot
 *
 *   ==> aShotXVelocityFactor   Shot X velocity factor.
 *
 *   This function shoots a projectile with the X velocity factor specified by
 * aShotXVelocityFactor.  The projectile is shot with a constant speed.  The X
 * velocity is the Y velocity times the X velocity factor.
 */

- (void)shoot:(float) aShotXVelocityFactor
{
    /* Create a projectile sprite. */
    id projectileSpriteClass =
                        objc_getClass([mBossProjectileSpriteName UTF8String]);
    ProjectileSprite* projectileSprite =
                                        [[projectileSpriteClass alloc] init];
    projectileSprite.velocityY = 1.0;
    projectileSprite.velocityX =   projectileSprite.velocityY
                                 * aShotXVelocityFactor;
    projectileSprite.speed = BOSS_PROJECTILE_SPEED;

    /* Get the boss and projectile geometries. */
    CGRect selfFrame = self.spriteView.frame;
    CGPoint selfCenter = self.spriteView.center;
    CGRect projectileBounds = projectileSprite.spriteView.bounds;

    /* Position the projectile below the boss. */
    CGPoint projectileCenter;
    projectileCenter.x = selfCenter.x;
    projectileCenter.y =   CGRectGetMaxY(selfFrame)
                         + projectileBounds.size.height/2.0;
    projectileSprite.spriteView.center = projectileCenter;

    /* Add the projectile sprite. */
    [mParentSprite addChild:projectileSprite];

    /* Play shot sound. */
    [WJAudio playAudioFromResource:projectileSprite.shotSoundFileName
             ofType:nil];

    /* Release objects. */
    [projectileSprite release];
}


@end


