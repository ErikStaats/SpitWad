/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the level sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Level sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "LevelSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Level sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation LevelSprite

/* Synthesize properties. */
@synthesize levelReady = mLevelReady;
@synthesize levelComplete = mLevelComplete;
@synthesize levelName = mLevelName;
@synthesize levelStartAudioPlayer = mLevelStartAudioPlayer;


/* *****************************************************************************
 *
 * Level sprite NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Release objects. */
    [mLevelName release];
    [mLevelStartAudioPlayer release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Level sprite services.
 *
 ******************************************************************************/

/*
 * startLevel
 *
 *   This function starts the level.
 */

- (void)startLevel
{
    /* The level is started. */
    mLevelStarted = YES;
}


/*
 * stopLevel
 *
 *   This function stops the level.
 */

- (void)stopLevel
{
    /* The level is stopped. */
    mLevelStopped = YES;
}


@end


