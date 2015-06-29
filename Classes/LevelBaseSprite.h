/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the base level sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base level sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "BackgroundSprite.h"
#import "LevelSprite.h"
#import "SpriteWave.h"


/* *****************************************************************************
 *
 * Base level sprite class definition.
 *
 ******************************************************************************/

@interface LevelBaseSprite : LevelSprite<BackgroundSpriteDelegate>
{
    /*
     * mLevelNibName            Name of level nib.
     * mLevelStartAudioFileName Name of level start audio file.
     * mLevelBossAudioFileName  Name of level boss audio file.
     * mLevelBackgroundImageFileName
     *                          Name of level background image file.
     * mEnemyBossSpriteName     Class name of level enemy boss sprite.
     * mHealthPowerUpSpriteName Class name of health power up sprite.
     * mScrollBackground        If YES, scroll background.
     *
     * mBackgroundSprite        Sprite for level background.
     * mLevelStartTime          Sprite step time at the start of the level.
     * mLevelTime               Elapsed time of the current level.
     * mEnemyWaveSequence       Enemy wave sequence.
     * mNextEnemyWave           Next enemy wave in sequence.
     * mEnemySpriteSet          Set of enemy sprites.
     * mBossAudioPlayer         Boss audio player.
     * mAddedBoss               YES if the boss has been added.
     * mAddHealthPowerUpTime    Time at which to add a health power up.
     * mAddedHealthPowerUp      YES if a health power up has been added.
     */

    NSString*                   mLevelNibName;
    NSString*                   mLevelStartAudioFileName;
    NSString*                   mLevelBossAudioFileName;
    NSString*                   mLevelBackgroundImageFileName;
    NSString*                   mEnemyBossSpriteName;
    NSString*                   mHealthPowerUpSpriteName;
    BOOL                        mScrollBackground;

    BackgroundSprite*           mBackgroundSprite;
    NSTimeInterval              mLevelStartTime;
    NSTimeInterval              mLevelTime;
    SpriteWaveSequence*         mEnemyWaveSequence;
    NSInteger                   mNextEnemyWave;
    NSMutableSet*               mEnemySpriteSet;
    AVAudioPlayer*              mBossAudioPlayer;
    BOOL                        mAddedBoss;
    NSTimeInterval              mAddHealthPowerUpTime;
    BOOL                        mAddedHealthPowerUp;
}


/* Base level sprite services. */
- (void)configureLevel;


/* Internal base level sprite services. */
- (void)initBackground;

- (void)updateEnemies;

- (void)addEnemyBossSprite;

- (void)updatePowerUps;

- (void)addEnemySprite:(SpriteViewController*) aEnemySprite;

- (void)removeEnemySprite:(SpriteViewController*) aEnemySprite;

- (void)removeAllEnemySprites;


@end


