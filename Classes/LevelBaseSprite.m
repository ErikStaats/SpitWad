/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the base level sprites.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base level sprites imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "LevelBaseSprite.h"

/* Local imports. */
#import "PowerUpSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Ambush level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface LevelAmbushSprite : LevelBaseSprite
@end

@implementation LevelAmbushSprite

/*
 * configureLevel
 *
 *   This function sets up the level configuration.
 */

- (void)configureLevel
{
    /* Invoke the super-class. */
    [super configureLevel];

    /* Configure the level. */
    mLevelName = @"Ambush";
    mLevelStartAudioFileName = @"schoolbell.aif";
    mLevelBossAudioFileName = @"bosstheme2.aif";
    mLevelBackgroundImageFileName = @"waytoschool.jpg";
    mEnemyBossSpriteName = @"BullyBossSprite";
    mHealthPowerUpSpriteName = @"HealthPowerUpSprite";

    /* Create the enemy wave sequence. */
    id enemyWaveSequenceClass = objc_getClass("SpriteWaveSequence1");
    SpriteWaveSequence<SpriteWaveSequenceBase>*
                        enemyWaveSequenceBase = [enemyWaveSequenceClass alloc];
    mEnemyWaveSequence = [enemyWaveSequenceBase initWithSprite:@"BullySprite"
                                                spriteCount:3
                                                sequenceTime:60.0];
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * Classroom level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface LevelClassroomSprite : LevelBaseSprite
@end

@implementation LevelClassroomSprite

/*
 * configureLevel
 *
 *   This function sets up the level configuration.
 */

- (void)configureLevel
{
    /* Invoke the super-class. */
    [super configureLevel];

    /* Configure the level. */
    mLevelName = @"Classroom";
    mLevelStartAudioFileName = @"schoolbell.aif";
    mLevelBossAudioFileName = @"bosstheme2.aif";
    mLevelBackgroundImageFileName = @"classroom.jpg";
    mEnemyBossSpriteName = @"TeacherBossSprite";
    mHealthPowerUpSpriteName = @"HealthPowerUpSprite";

    /* Create the enemy wave sequence. */
    id enemyWaveSequenceClass = objc_getClass("SpriteWaveSequence1");
    SpriteWaveSequence<SpriteWaveSequenceBase>*
                        enemyWaveSequenceBase = [enemyWaveSequenceClass alloc];
    mEnemyWaveSequence = [enemyWaveSequenceBase initWithSprite:@"Bully2Sprite"
                                                spriteCount:3
                                                sequenceTime:60.0];
}


@end

/* *****************************************************************************
 *******************************************************************************
 *
 * Grounds level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface LevelGroundsSprite : LevelBaseSprite
@end

@implementation LevelGroundsSprite

/*
 * configureLevel
 *
 *   This function sets up the level configuration.
 */

- (void)configureLevel
{
    /* Invoke the super-class. */
    [super configureLevel];

    /* Configure the level. */
    mLevelName = @"Grounds";
    mLevelStartAudioFileName = @"schoolbell.aif";
    mLevelBossAudioFileName = @"bosstheme2.aif";
    mLevelBackgroundImageFileName = @"schoolscroll.jpg";
    mEnemyBossSpriteName = @"GothBullyBossSprite";
    mHealthPowerUpSpriteName = @"HealthPowerUpSprite";

    /* Create the enemy wave sequence. */
    id enemyWaveSequenceClass = objc_getClass("SpriteWaveSequence1");
    SpriteWaveSequence<SpriteWaveSequenceBase>*
                        enemyWaveSequenceBase = [enemyWaveSequenceClass alloc];
    mEnemyWaveSequence = [enemyWaveSequenceBase initWithSprite:@"BullySprite"
                                                spriteCount:3
                                                sequenceTime:60.0];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Recess level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface LevelRecessSprite : LevelBaseSprite
@end

@implementation LevelRecessSprite

/*
 * configureLevel
 *
 *   This function sets up the level configuration.
 */

- (void)configureLevel
{
    /* Invoke the super-class. */
    [super configureLevel];

    /* Configure the level. */
    mLevelName = @"Recess";
    mLevelStartAudioFileName = @"schoolbell.aif";
    mLevelBossAudioFileName = @"bosstheme2.aif";
    mLevelBackgroundImageFileName = @"SchoolBackground.png";
    mEnemyBossSpriteName = @"YardDutyBossSprite";
    mHealthPowerUpSpriteName = @"HealthPowerUpSprite";
    mScrollBackground = NO;

    /* Create the enemy wave sequence. */
    id enemyWaveSequenceClass = objc_getClass("SpriteWaveSequence1");
    SpriteWaveSequence<SpriteWaveSequenceBase>*
                        enemyWaveSequenceBase = [enemyWaveSequenceClass alloc];
    mEnemyWaveSequence = [enemyWaveSequenceBase initWithSprite:@"BullySprite"
                                                spriteCount:3
                                                sequenceTime:60.0];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Base level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation LevelBaseSprite

/*
 * Base level sprite class configuration.
 *
 *   LEVEL_MAIN_PLAY_TIME       Main play time of level.
 */

#define LEVEL_MAIN_PLAY_TIME    60.0


/* Synthesize properties. */
@dynamic levelReady;


/* *****************************************************************************
 *
 * Base level sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the base level sprite.
 */

- (id)init
{
    NSURL* soundFileURL;

    /* Configure the level. */
    [self configureLevel];

    /* Initialize the super class with the level view. */
    self = [super initWithNibName:mLevelNibName bundle:[NSBundle mainBundle]];
    if (!self)
        return nil;

    /* Set the sprite view. */
    self.spriteView = self.view;

    /* Initialize the background. */
    [self initBackground];

    /* Initialize the start of level audio. */
    soundFileURL =
            [NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:mLevelStartAudioFileName
                                       ofType:nil]];
    mLevelStartAudioPlayer =
                    [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                           error:nil];
    [mLevelStartAudioPlayer prepareToPlay];

    /* Initialize the enemy set. */
    mEnemySpriteSet = [[NSMutableSet alloc] initWithCapacity:0];

    /* Initialize the boss audio. */
    soundFileURL =
        [NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:mLevelBossAudioFileName
                                       ofType:nil]];
    mBossAudioPlayer =
                    [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                           error:nil];
    mBossAudioPlayer.numberOfLoops = -1;
    [mBossAudioPlayer prepareToPlay];

    /* Indicate that level is ready. */
    self.levelReady = YES;

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Remove all enemy sprites. */
    [self removeAllEnemySprites];

    /* Stop and release boss audio player. */
    [mBossAudioPlayer stop];
    [mBossAudioPlayer release];

    /* Stop and release level start audio player. */
    [mLevelStartAudioPlayer stop];

    /* Release objects. */
    [mBackgroundSprite release];
    [mEnemyWaveSequence release];
    [mLevelNibName release];
    [mLevelStartAudioFileName release];
    [mLevelBossAudioFileName release];
    [mLevelBackgroundImageFileName release];
    [mEnemyBossSpriteName release];
    [mHealthPowerUpSpriteName release];
    [mEnemySpriteSet release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Base level sprite SpriteViewController services.
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
    /* Do nothing if level has not started or has stopped. */
    if ((!mLevelStarted) || (mLevelStopped))
        return;

    /* Initialize the level start time. */
    if (!mLevelStartTime)
        mLevelStartTime = aStepTime;

    /* Get the current level time. */
    mLevelTime = aStepTime - mLevelStartTime;

    /* Update the enemies. */
    [self updateEnemies];

    /* Update power ups. */
    [self updatePowerUps];

    /* Check for the end of the level. */
    if (mLevelTime > LEVEL_MAIN_PLAY_TIME)
    {
        /* Wait until the boss has been added and    */
        /* all enemies are gone before ending level. */
        if (mAddedBoss && !mEnemySpriteSet.count)
            mLevelComplete = YES;
    }

    /* Step the super class. */
    [super step:aStepTime];
}


/* *****************************************************************************
 *
 * Base level sprite LevelSprite services.
 *
 ******************************************************************************/

/*
 * startLevel
 *
 *   This function starts the level.
 */

- (void)startLevel
{
    /* Do nothing if level already started. */
    if (mLevelStarted)
        return;

    /* If the background is scrolling, add a health power up at a random */
    /* location in the upper half of the background and below the final  */
    /* screen.                                                           */
    if (mScrollBackground)
    {
        /* Create a health power up that doesn't expire. */
        id healthPowerUpSpriteClass =
                        objc_getClass([mHealthPowerUpSpriteName UTF8String]);
        PowerUpSprite* healthPowerUpSprite =
                                        [[healthPowerUpSpriteClass alloc] init];
        healthPowerUpSprite.lifeTime = 0.0;

        /* Determine range of power-up locations.  Ensure the power-up is in */
        /* the upper half of the background but not on the end of level      */
        /* screen.                                                           */
        CGRect range;
        range.origin.x =   mBackgroundSprite.spriteView.bounds.origin.x
                         + healthPowerUpSprite.spriteView.bounds.size.width/2;
        range.size.width =   mBackgroundSprite.spriteView.bounds.size.width
                           - healthPowerUpSprite.spriteView.bounds.size.width;
        range.origin.y =   mBackgroundSprite.spriteView.bounds.origin.y
                         + self.spriteView.bounds.size.height
                         + healthPowerUpSprite.spriteView.bounds.size.height/2;
        range.size.height =   CGRectGetMidY(mBackgroundSprite.spriteView.bounds)
                            - range.origin.y;

        /* Randomly position health power up within range. */
        float xFactor = (((CGFloat) random()) / ((CGFloat) 0x7FFFFFFF));
        float yFactor = (((CGFloat) random()) / ((CGFloat) 0x7FFFFFFF));
        CGPoint position;
        position.x = range.origin.x + xFactor*range.size.width;
        position.y = range.origin.y + yFactor*range.size.height;
        healthPowerUpSprite.spriteView.center = position;

        /* Add the health power up to the background. */
        [mBackgroundSprite addChild:healthPowerUpSprite];
        mAddedHealthPowerUp = YES;

        /* Release objects. */
        [healthPowerUpSprite release];
    }

    /* Set the background sprite to move to its top */
    /* by the time the main level play time ends.   */
    if (mScrollBackground)
    {
        CGPoint target = mBackgroundSprite.spriteView.center;
        target.y =   self.spriteView.bounds.origin.y
                   + 0.5*mBackgroundSprite.spriteView.frame.size.height;
        float speed =   (target.y - mBackgroundSprite.spriteView.center.y)
                      / LEVEL_MAIN_PLAY_TIME;
        [mBackgroundSprite setTarget:target speed:speed];
    }

    /* Invoke the super-class. */
    [super startLevel];
}


/*
 * stopLevel
 *
 *   This function stops the level.
 */

- (void)stopLevel
{
    /* Remove all enemy sprites. */
    [self removeAllEnemySprites];

    /* Stop the boss audio player. */
    [mBossAudioPlayer stop];

    /* Invoke the super-class. */
    [super stopLevel];
}


/*
 * levelReady
 */

- (BOOL)levelReady
{
    /* The level is ready when the background sprite is ready. */
    return mBackgroundSprite.backgroundReady;
}

- (void)setLevelReady:(BOOL) aLevelReady
{
    mLevelReady = aLevelReady;
}


/* *****************************************************************************
 *
 * Base level sprite BackgroundSpriteDelegate services.
 *
 ******************************************************************************/

/*
 * backgroundReady
 *
 *   ==> aBackgroundSprite      Background sprite that is ready.
 *
 *   This function is called when the background sprite specified by
 * aBackgroundSprite is ready.
 */

- (void)backgroundReady:(BackgroundSprite*) aBackgroundSprite
{
    /* Initialize the background sprite position */
    /* so that the bottom of it is in view.      */
    CGRect frame = mBackgroundSprite.spriteView.frame;
    frame.origin = self.spriteView.bounds.origin;
    frame.origin.y -= frame.size.height - self.spriteView.bounds.size.height;
    mBackgroundSprite.spriteView.frame = frame;
}


/* *****************************************************************************
 *
 * Base level sprite services.
 *
 ******************************************************************************/

/*
 * configureLevel
 *
 *   This function sets up the level configuration.
 */

- (void)configureLevel
{
    mLevelNibName = @"LevelBase";
    mScrollBackground = YES;
}


/* *****************************************************************************
 *
 * Internal base level sprite services.
 *
 ******************************************************************************/

/*
 * initBackground
 *
 *   This function initializes the level background.
 */

- (void)initBackground
{
    /* Add a background sprite. */
    /*zzz need to have way to ensure sprite is underneath all other sprites. */
    mBackgroundSprite =
                    [[BackgroundSprite alloc]
                        initWithImageFileName:mLevelBackgroundImageFileName];
    [self addChild:mBackgroundSprite];
    mBackgroundSprite.backgroundSpriteDelegate = self;
}


/*
 * updateEnemies
 *
 *   This function updates the enemies.
 */

- (void)updateEnemies
{
    /* Remove all enemy sprites that have been removed from their parents. */
    NSArray* enemySpriteList = [mEnemySpriteSet allObjects];
    int enemySpriteCount = enemySpriteList.count;
    for (int i = 0; i < enemySpriteCount; i++)
    {
        /* Get the next enemy sprite. */
        SpriteViewController* enemySprite = [enemySpriteList objectAtIndex:i];

        /* If the enemy has no parent sprite, remove it. */
        if (!enemySprite.parentSprite)
            [self removeEnemySprite:enemySprite];
    }

    /* Send enemy waves during level main play. */
    if (mLevelTime <= LEVEL_MAIN_PLAY_TIME)
    {
        /* Get the next sprite wave info. */
        SpriteWaveInfo*
                spriteWaveInfo = [mEnemyWaveSequence getInfo:mNextEnemyWave];

        /* Start sprite wave if it's time. */
        if (spriteWaveInfo && (mLevelTime >= spriteWaveInfo.startTime))
        {
            /* Create and add the sprite wave. */
            id SpriteWaveClass =
                            objc_getClass([spriteWaveInfo.waveName UTF8String]);
            SpriteWave* spriteWave =
                    [[[SpriteWaveClass alloc]
                        initWithSprite:spriteWaveInfo.spriteName
                        spriteCount:spriteWaveInfo.spriteCount] autorelease];
            [self addChild:spriteWave];

            /* Set up the next sprite wave. */
            mNextEnemyWave++;
        }
    }

    /* Add boss at end of level main play. */
    if ((mLevelTime > LEVEL_MAIN_PLAY_TIME) && !mAddedBoss)
    {
        [self addEnemyBossSprite];
        [mBossAudioPlayer play];
        mAddedBoss = YES;
    }
}


/*
 * addEnemyBossSprite
 *
 *   This function adds an enemy boss sprite to the spit wad field view.
 */

- (void)addEnemyBossSprite
{
    /* Create an enemy boss sprite. */
    id enemyBossSpriteClass = objc_getClass([mEnemyBossSpriteName UTF8String]);
    SpriteViewController* enemyBossSprite = [[enemyBossSpriteClass alloc] init];

    /* Add enemy boss sprite as an enemy sprite. */
    [self addEnemySprite:enemyBossSprite];

    /* Release objects. */
    [enemyBossSprite release];
}


/*
 * updatePowerUps
 *
 *   This function updates the power ups.
 */

- (void)updatePowerUps
{
    /* Do nothing if health power up has already been added. */
    if (mAddedHealthPowerUp)
        return;

    /* Randomly set the add health power up time. */
    if (!mAddHealthPowerUpTime)
    {
        mAddHealthPowerUpTime =
                              LEVEL_MAIN_PLAY_TIME
                            * (((CGFloat) random()) / ((CGFloat) 0x7FFFFFFF));
    }

    /* Add a health power up if it's time. */
    if (mLevelTime >= mAddHealthPowerUpTime)
    {
        /* Create a health power up. */
        id healthPowerUpSpriteClass =
                        objc_getClass([mHealthPowerUpSpriteName UTF8String]);
        SpriteViewController* healthPowerUpSprite =
                                        [[healthPowerUpSpriteClass alloc] init];

        /* Randomly position health power up in top of field. */
        CGPoint position;
        position.x =   mSpriteView.bounds.size.width
                     * (((CGFloat) random()) / ((CGFloat) 0x7FFFFFFF));
        position.y =   (mSpriteView.bounds.size.height / 2.0)
                     * (((CGFloat) random()) / ((CGFloat) 0x7FFFFFFF));
        healthPowerUpSprite.spriteView.center = position;

        /* Add the health power up to the field. */
        [self addChild:healthPowerUpSprite];
        mAddedHealthPowerUp = YES;

        /* Release objects. */
        [healthPowerUpSprite release];
    }
}


/*
 * addEnemySprite
 *
 *   ==> aEnemySprite           Enemy sprite to add.
 *
 *   This function adds the enemy sprite specified by aEnemySprite to the spit
 * wad field view.
 */

- (void)addEnemySprite:(SpriteViewController*) aEnemySprite
{
    /* Add enemy sprite to set of enemy sprites. */
    [mEnemySpriteSet addObject:aEnemySprite];

    /* Add enemy sprite as a child sprite. */
    [self addChild:aEnemySprite];
}


/*
 * removeEnemySprite
 *
 *   ==> aEnemySprite           Enemy sprite to remove.
 *
 *   This function removes the enemy sprite specified by aEnemySprite.
 */

- (void)removeEnemySprite:(SpriteViewController*) aEnemySprite
{
    /* Remove self as a enemy sprite notification delegate. */
    [aEnemySprite removeNotificationDelegate:self];

    /* Remove enemy sprite from its parent. */
    if (aEnemySprite.parentSprite)
        [aEnemySprite.parentSprite removeChild:aEnemySprite];

    /* Remove enemy sprite from set of enemy sprites. */
    [mEnemySpriteSet removeObject:aEnemySprite];
}


/*
 * removeAllEnemySprites
 *
 *   This function removes all enemy sprites.
 */

- (void)removeAllEnemySprites
{
    /* Create an auto-release pool so all enemy sprites are released. */
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    /* Remove all enemy sprites. */
    NSArray* enemySpriteList = [mEnemySpriteSet allObjects];
    int enemySpriteCount = enemySpriteList.count;
    for (int i = 0; i < enemySpriteCount; i++)
    {
        SpriteViewController* enemySprite = [enemySpriteList objectAtIndex:i];
        [self removeEnemySprite:enemySprite];
    }

    /* Release the auto-release pool. */
    [pool release];
}


@end


