/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the level sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Level sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpriteViewController.h"

/* Cocoa imports. */
#import <AVFoundation/AVFoundation.h>


/* *****************************************************************************
 *
 * Level sprite class definition.
 *
 * Properties:
 *
 *   levelReady                 If YES, level is ready to start.
 *   levelComplete              If YES, level is complete.
 *   levelName                  Name of level.
 *   levelStartAudioPlayer      Player for level start audio.
 *
 ******************************************************************************/

@interface LevelSprite : SpriteViewController
{
    /*
     * mLevelReady              If YES, level is ready to start.
     * mLevelComplete           If YES, level is complete.
     * mLevelName               Name of level.
     * mLevelStartAudioPlayer   Player for level start audio.
     *
     * mLevelStarted            If YES, level has started.
     * mLevelStopped            If YES, level has stopped.
     */

    BOOL                        mLevelReady;
    BOOL                        mLevelComplete;
    NSString*                   mLevelName;
    AVAudioPlayer*              mLevelStartAudioPlayer;

    BOOL                        mLevelStarted;
    BOOL                        mLevelStopped;
}


/* Properties. */
@property(assign) BOOL              levelReady;
@property(assign) BOOL              levelComplete;
@property(retain) NSString*         levelName;
@property(retain) AVAudioPlayer*    levelStartAudioPlayer;


/* School yard level services. */
- (void)startLevel;

- (void)stopLevel;


@end


