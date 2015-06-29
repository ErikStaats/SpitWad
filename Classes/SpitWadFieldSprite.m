/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad field sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad field sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadFieldSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad field sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadFieldSprite

/*
 * Spit wad field sprite class configuration.
 *
 *   START_OF_DAY_DISPLAY_TIME  Amount of time in seconds to display the start
 *                              of day.
 *   START_OF_LEVEL_DISPLAY_TIME
 *                              Amount of time in seconds to display the start
 *                              of level.
 *   gLevelSequence             Sequence of levels.
 */

#define START_OF_DAY_DISPLAY_TIME   2.0
#define START_OF_LEVEL_DISPLAY_TIME 2.0
static char* gLevelSequence[] =
{
    "LevelAmbushSprite",
    "LevelRecessSprite",
    NULL,

    "LevelClassroomSprite",
    "LevelRecessSprite",
    NULL,

    "LevelGroundsSprite",
    "LevelRecessSprite",
    NULL,

    NULL
};


/* Synthesize properties. */
@synthesize score = mScore;
@synthesize levelView = mLevelView;
@synthesize levelInfoView = mLevelInfoView;
@synthesize dayNumberLabel = mDayNumberLabel;
@synthesize levelNumberLabel = mLevelNumberLabel;
@synthesize levelNameLabel = mLevelNameLabel;
@synthesize levelReadyWaitIndicator = mLevelReadyWaitIndicator;
@synthesize scoreLabel = mScoreLabel;
@synthesize healthLabel = mHealthLabel;
@synthesize pauseButton = mPauseButton;
@synthesize resumeButton = mResumeButton;
@synthesize fieldNotificationDelegate = mFieldNotificationDelegate;


/* *****************************************************************************
 *
 * Spit wad field sprite NSObject implementation.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the spit wad field sprite.
 */

- (id)init
{
    /* Initialize the super class with the spit wad field view. */
    self = [super initWithNibName:@"SpitWadFieldView"
                  bundle:[NSBundle mainBundle]];
    if (!self)
        return nil;

    /* Set the sprite views. */
    self.spriteView = self.view;
    self.childSpritesView = mLevelView;

    /* Initialize the day number. */
    mDayNum = 1;

    /* Create the player sprite. */
    mPlayerSprite = [[PlayerSprite alloc] init];

    /* Seed the random number generator. */
    srandom(time(NULL));

    /* Update the UI. */
    [self update];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Remove the day start sprite. */
    if (mDayStartSprite)
    {
        [self removeChild:mDayStartSprite];
        [mDayStartSprite release];
        mDayStartSprite = nil;
    }

    /* Remove level sprite. */
    if (mLevelSprite)
    {
        [self removeChild:mLevelSprite];
        [mLevelSprite release];
    }

    /* Remove the player sprite. */
    [mPlayerSprite release];
    mPlayerSprite = nil;

    /* Release objects. */
    [mLevelView release];
    [mLevelInfoView release];
    [mDayNumberLabel release];
    [mLevelNumberLabel release];
    [mLevelNameLabel release];
    [mLevelReadyWaitIndicator release];
    [mScoreLabel release];
    [mHealthLabel release];
    [mPauseButton release];
    [mResumeButton release];

    /* Call the super-class dealloc. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Spit wad field sprite UIViewController implementation.
 *
 ******************************************************************************/

/*
 * shouldAutorotateToInterfaceOrientation
 *
 *   ==> aInterfaceOrientation  The orientation of the application's user
 *                              interface after the rotation.
 *
 *   <==                        YES if the view controller autorotates its view
 *                              to the specified orientation; otherwise, NO.
 *
 *   Returns a Boolean value indicating whether the view controller autorotates
 * its view.
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)    aInterfaceOrientation
{
    /* Don't allow any orientation except portrait. */
    if (aInterfaceOrientation != UIDeviceOrientationPortrait)
      return NO;

    return YES;
}


/* *****************************************************************************
 *
 * Spit wad field sprite SpriteNotificationDelegate services.
 *
 ******************************************************************************/

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
    /* Remove self as sprite notification delegate. */
    [aSprite removeNotificationDelegate:self];

    /* Update the UI. */
    [self update];
}


/*
 * scoreTallied
 *
 *   ==> aSprite                Sprite for which score was tallied.
 *   ==> aScore                 Tallied score.
 *
 *   This notification is sent when the score specified by aScore has been
 * tallied for the sprite specified by aSprite.
 */

- (void)scoreTallied:(SpriteViewController*) aSprite
        score:(NSInteger)                    aScore
{
    /* Do nothing unless score is tallied for self. */
    if (aSprite != self)
        return;

    /* Update the score. */
    mScore += aScore;

    /* Update the UI. */
    [self update];
}


/* *****************************************************************************
 *
 * Spit wad field sprite SpriteViewController services.
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
    /* Game is over if the player is defeated. */
    if (mPlayerSprite && (mPlayerSprite.health <= 0.0))
        [self handleGameOver];

    /* Step the day if the game is not over. */
    if (!mGameOver)
        [self stepDay:aStepTime];

    /* Update the UI. */
    [self update];

    /* Step the super class. */
    [super step:aStepTime];
}


/*
 * stepDay
 *
 *   ==> aStepTime              Time of step.
 *
 *   This function steps the sprite day to the time specified by aStepTime.
 */

- (void)stepDay:(NSTimeInterval) aStepTime
{
    /* Initialize the day start time. */
    if (!mDayStartTime)
        mDayStartTime = aStepTime;

    /* Get the current day time. */
    mDayTime = aStepTime - mDayStartTime;

    /* Step the day start if not complete. */
    if (!mDayStartComplete)
        [self stepDayStart:aStepTime];
    if (!mDayStartComplete)
        return;

    /* Step the level. */
    [self stepLevel:aStepTime];
}


/*
 * stepDayStart
 *
 *   ==> aStepTime              Time of step.
 *
 *   This function steps the sprite day start to the time specified by
 * aStepTime.
 */

- (void)stepDayStart:(NSTimeInterval) aStepTime
{
    /* Create and add the start of day sprite. */
    if (!mDayStartSprite)
    {
        mDayStartSprite = [[DayStartSprite alloc] init];
        [self addChild:mDayStartSprite];
    }

    /* Update the level info view. */
    mDayNumberLabel.text = [NSString stringWithFormat:@"Day %d", mDayNum];
    mLevelNumberLabel.text = nil;
    mLevelNameLabel.text = nil;
    mLevelInfoView.hidden = NO;

    /* Wait until the start of day display time has expired. */
    if (mDayTime <= START_OF_DAY_DISPLAY_TIME)
        return;

    /* Wait until the level is ready. */
    if (!mLevelSprite.levelReady)
    {
        /* Start the waiting for level ready indicator. */
        if (![mLevelReadyWaitIndicator isAnimating])
            [mLevelReadyWaitIndicator startAnimating];

        return;
    }

    /* Stop the waiting for level ready indicator. */
    if ([mLevelReadyWaitIndicator isAnimating])
        [mLevelReadyWaitIndicator stopAnimating];

    /* Hide the start of level info. */
    mLevelInfoView.hidden = YES;

    /* Remove the start of day sprite. */
    [self removeChild:mDayStartSprite];
    [mDayStartSprite release];
    mDayStartSprite = nil;

    /* The start of day is complete. */
    mDayStartComplete = YES;
}


/*
 * stepLevel
 *
 *   ==> aStepTime              Time of step.
 *
 *   This function steps the sprite level to the time specified by aStepTime.
 */

- (void)stepLevel:(NSTimeInterval) aStepTime
{
    /* Add the level sprite. */
    if (!mLevelSprite.parentSprite)
    {
        /* Add the level player sprite. */
        [mLevelSprite addChild:mPlayerSprite];

        /* Add level sprite to the field. */
        [self addChild:mLevelSprite];
    }

    /* Play the level start sound. */
    if (!mPlayedLevelStartSound)
    {
        [[mLevelSprite levelStartAudioPlayer] play];
        mPlayedLevelStartSound = YES;
    }

    /* Initialize the level start time. */
    if (!mLevelStartTime)
        mLevelStartTime = aStepTime;

    /* Get the current level time. */
    mLevelTime = aStepTime - mLevelStartTime;

    /* Display the start of level info. */
    if (mLevelTime <= START_OF_LEVEL_DISPLAY_TIME)
    {
        mDayNumberLabel.text = [NSString stringWithFormat:@"Day %d", mDayNum];
        mLevelNumberLabel.text =
                            [NSString stringWithFormat:@"Level %d", mLevelNum];
        mLevelNameLabel.text = mLevelSprite.levelName;
        mLevelInfoView.hidden = NO;
        return;
    }

    /* Wait until the level is ready. */
    if (!mLevelSprite.levelReady)
    {
        /* Start the waiting for level ready indicator. */
        if (![mLevelReadyWaitIndicator isAnimating])
            [mLevelReadyWaitIndicator startAnimating];

        return;
    }

    /* Stop the waiting for level ready indicator. */
    if ([mLevelReadyWaitIndicator isAnimating])
        [mLevelReadyWaitIndicator stopAnimating];

    /* Hide the start of level info. */
    mLevelInfoView.hidden = YES;

    /* Start the level. */
    [mLevelSprite startLevel];

    /* Check for the end of the level. */
    if ([mLevelSprite levelComplete])
    {
        /* Reset level state. */
        mLevelStartTime = 0;
        mLevelTime = 0;
        mPlayedLevelStartSound = NO;

        /* Dispose of the completed level sprite. */
        [self removeChild:mLevelSprite];
        [mLevelSprite release];
        mLevelSprite = nil;
    }
}


/* *****************************************************************************
 *
 * Spit wad field sprite handlers.
 *
 ******************************************************************************/

/*
 * handleShootStartAction
 *
 *   ==> aSender                Sender of shoot start action.
 *
 *   This function handles the shoot start action from the sender specified by
 * aSender.
 */

- (void)handleShootStartAction:(id) aSender
{
    /* Forward action to the player sprite if it's in play. */
    if (mPlayerSprite.parentSprite)
        [mPlayerSprite startShooting];
}


/*
 * handleShootStopAction
 *
 *   ==> aSender                Sender of shoot stop action.
 *
 *   This function handles the shoot stop action from the sender specified by
 * aSender.
 */

- (void)handleShootStopAction:(id) aSender
{
    /* Forward action to the player sprite. */
    [mPlayerSprite stopShooting];
}


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
    /* Forward action to the player sprite if it's in play. */
    if (mPlayerSprite.parentSprite)
    {
        [mPlayerSprite handleMoveAction:self
                       moveSpeedXFactor:aMoveSpeedXFactor
                       moveSpeedYFactor:aMoveSpeedYFactor];
    }
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
    /* Forward action to the player sprite if it's in play. */
    if (mPlayerSprite.parentSprite)
    {
        [mPlayerSprite handleMoveToAction:self
                       moveToXFactor:aMoveToXFactor
                       moveToYFactor:aMoveToYFactor];
    }
}


/*
 * handleGameOver
 *
 *   This functions handles a game over event.
 */

- (void)handleGameOver
{
    /* Stop the level. */
    [mLevelSprite stopLevel];

    /* Remove the player sprite. */
    [mPlayerSprite release];
    mPlayerSprite = nil;

    /* Notify the field delegate. */
    if (mFieldNotificationDelegate)
    {
        if ([mFieldNotificationDelegate
                                    respondsToSelector:@selector(gameEnded)])
        {
            [mFieldNotificationDelegate gameEnded];
        }
    }

    /* Set game over. */
    mGameOver = YES;
}


/* *****************************************************************************
 *
 * Spit wad field sprite action handlers.
 *
 ******************************************************************************/

/*
 * handlePauseAction
 *
 *   ==> aSender                Sender of play action.
 *
 *   This function handles the pause action from the sender specified by
 * aSender.
 */

- (void)handlePauseAction:(id) aSender
{
    /* Pause the sprite. */
    [self pauseSprite];

    /* Update the UI. */
    [self update];
}


/*
 * handleResumeAction
 *
 *   ==> aSender                Sender of resume action.
 *
 *   This function handles the resume action from the sender specified by
 * aSender.
 */

- (void)handleResumeAction:(id) aSender
{
    /* Resume the sprite. */
    [self resumeSprite];

    /* Update the UI. */
    [self update];
}


/* *****************************************************************************
 *
 * Internal spit wad field sprite services.
 *
 ******************************************************************************/

/*
 * update
 *
 *   This function updates the spit wad field sprite.
 */

- (void)update
{
    /* Update the score and health labels. */
    mScoreLabel.text = [NSString stringWithFormat:@"Score: %d", mScore];
    mHealthLabel.text = [NSString stringWithFormat:@"Health: %d",
                                                   (int) mPlayerSprite.health];

    /* Update the play/pause buttons. */
    if (self.spritePaused)
    {
        mPauseButton.hidden = YES;
        mResumeButton.hidden = NO;
    }
    else
    {
        mPauseButton.hidden = NO;
        mResumeButton.hidden = YES;
    }

    /* Update the level sprite. */
    if (!mLevelSprite)
    {
        /* Update the level number. */
        mLevelNum++;

        /* Get the next level in the sequence. */
        id levelClass;
        levelClass = objc_getClass(gLevelSequence[mLevelSequenceIndex++]);

        /* Check for end of day marker.  Update day if it ended. */
        if (!levelClass)
        {
            /* Update the day number. */
            mDayNum++;

            /* Reset day state. */
            mDayStartTime = 0;
            mDayTime = 0;
            mDayStartComplete = NO;

            /* Get the next level. */
            levelClass = objc_getClass(gLevelSequence[mLevelSequenceIndex++]);
        }

        /* Check for end of sequence marker.  Loop the sequence if it ended. */
        if (!levelClass)
        {
            mLevelSequenceIndex = 0;
            levelClass = objc_getClass(gLevelSequence[mLevelSequenceIndex++]);
        }

        /* Create the level sprite. */
        mLevelSprite = [[levelClass alloc] init];
    }
}


@end

