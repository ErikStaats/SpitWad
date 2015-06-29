/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad field sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad field sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "DayStartSprite.h"
#import "LevelSprite.h"
#import "PlayerSprite.h"
#import "SpriteViewController.h"

/* Cocoa imports. */
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Spit wad field sprite notification delegate protocol definition.
 *
 ******************************************************************************/

@protocol SpitWadFieldSpriteNotificationDelegate

/* Mark all methods as optional. */
@optional

/*
 * gameEnded
 *
 *   The game has ended.
 */

- (void)gameEnded;


@end


/* *****************************************************************************
 *
 * Spit wad field sprite class definition.
 *
 * Properties:
 *
 *   score                      Score.
 *   levelView                  View containing level sprite.
 *   levelInfoView              View containing level info.
 *   dayNumberLabel             Day number label.
 *   levelNumberLabel           Level number label.
 *   levelNameLabel             Level name label.
 *   levelReadyWaitIndicator    Activity indicator presented when waiting for a
 *                              level to become ready.
 *   scoreLabel                 UILabel used to display the score.
 *   healthLabel                UILabel used to display the player health.
 *   pauseButton                UIButton used to pause the game.
 *   resumeButton               UIButton used to resume the game.
 *   fieldNotificationDelegate  Delegate for receiving field notifications.
 *
 ******************************************************************************/

@interface SpitWadFieldSprite : SpriteViewController <UITextFieldDelegate>
{
    /*
     * mScore                   Current score.
     * mLevelView               View containing level sprite.
     * mLevelInfoView           View containing level info.
     * mDayNumberLabel          Day number label.
     * mLevelNumberLabel        Level number label.
     * mLevelNameLabel          Level name label.
     * mLevelReadyWaitIndicator Activity indicator presented when waiting for a
     *                          level to become ready.
     * mScoreLabel              UILabel used to display the score.
     * mHealthLabel             UILabel used to display the player health.
     * mPauseButton             UIButton used to pause the game.
     * mResumeButton            UIButton used to resume the game.
     * mFieldNotificationDelegate
     *                          Delegate for receiving field notifications.
     *
     * mLevelSequenceIndex      Current level sequence index.
     * mLevelNum                Current level number.
     * mDayNum                  Current day number.
     * mLevelSprite             Current level sprite.
     * mDayStartComplete        YES if day start has completed.
     * mDayStartTime            Sprite step time at the start of the day.
     * mDayTime                 Elapsed time of the current day.
     * mDayStartSprite          Sprite used at the start of day.
     * mLevelStartTime          Sprite step time at the start of the level.
     * mLevelTime               Elapsed time of the current level.
     * mLevelPlayStartTime      Sprite step time at the start of play of the
     *                          level.
     * mLevelPlayTime           Elapsed play time of the current level.
     * mPlayedLevelStartSound   YES if the level start sound was played.
     * mPlayerSprite            Player sprite.
     * mEnemySpriteSet          Set of enemy sprites.
     * mMaxBullyCount           Maximum number of bullies.
     * mBossAudioPlayer         Boss audio player.
     * mAddedBoss               YES if the boss has been added.
     * mAddHealthPowerUpTime    Time at which to add a health power up.
     * mAddedHealthPowerUp      YES if a health power up has been added.
     * mGameOver                YES if game is over.
     * mNewHighScoreIndex       Index in high scores list of new high score.
     */

    NSInteger                   mScore;
    UIView*                     mLevelView;
    UIView*                     mLevelInfoView;
    UILabel*                    mDayNumberLabel;
    UILabel*                    mLevelNumberLabel;
    UILabel*                    mLevelNameLabel;
    UIActivityIndicatorView*    mLevelReadyWaitIndicator;
    UILabel*                    mScoreLabel;
    UILabel*                    mHealthLabel;
    UIButton*                   mPauseButton;
    UIButton*                   mResumeButton;
    id                          mFieldNotificationDelegate;

    NSUInteger                  mLevelSequenceIndex;
    NSUInteger                  mDayNum;
    NSUInteger                  mLevelNum;
    BOOL                        mDayStartComplete;
    NSTimeInterval              mDayStartTime;
    NSTimeInterval              mDayTime;
    DayStartSprite*             mDayStartSprite;
    LevelSprite*                mLevelSprite;
    NSTimeInterval              mLevelStartTime;
    NSTimeInterval              mLevelTime;
    NSTimeInterval              mLevelPlayStartTime;
    NSTimeInterval              mLevelPlayTime;
    BOOL                        mPlayedLevelStartSound;
    PlayerSprite*               mPlayerSprite;
    NSMutableSet*               mEnemySpriteSet;
    NSInteger                   mMaxBullyCount;
    AVAudioPlayer*              mBossAudioPlayer;
    BOOL                        mAddedBoss;
    NSTimeInterval              mAddHealthPowerUpTime;
    BOOL                        mAddedHealthPowerUp;
    BOOL                        mGameOver;
    NSInteger                   mNewHighScoreIndex;
}


/* Properties. */
@property(assign) IBOutlet NSInteger    score;
@property(retain) IBOutlet UIView*      levelView;
@property(retain) IBOutlet UIView*      levelInfoView;
@property(retain) IBOutlet UILabel*     dayNumberLabel;
@property(retain) IBOutlet UILabel*     levelNumberLabel;
@property(retain) IBOutlet UILabel*     levelNameLabel;
@property(retain) IBOutlet UIActivityIndicatorView*
                                        levelReadyWaitIndicator;
@property(retain) IBOutlet UILabel*     scoreLabel;
@property(retain) IBOutlet UILabel*     healthLabel;
@property(retain) IBOutlet UIButton*    pauseButton;
@property(retain) IBOutlet UIButton*    resumeButton;
@property(assign) id<SpitWadFieldSpriteNotificationDelegate>
                                        fieldNotificationDelegate;


/* Spit wad field sprite SpriteViewController services. */
- (void)stepDay:(NSTimeInterval) aStepTime;

- (void)stepDayStart:(NSTimeInterval) aStepTime;

- (void)stepLevel:(NSTimeInterval) aStepTime;


/* Spit wad field handlers. */
- (void)handleShootStartAction:(id) aSender;

- (void)handleShootStopAction:(id) aSender;

- (void)handleMoveAction:(id) aSender
    moveSpeedXFactor:(float)  aMoveSpeedXFactor
    moveSpeedYFactor:(float)  aMoveSpeedYFactor;

- (void)handleMoveToAction:(id) aSender
    moveToXFactor:(float)       aMoveToXFactor
    moveToYFactor:(float)       aMoveToYFactor;

- (void)handleGameOver;


/* Spit wad field sprite action handlers. */
- (IBAction)handlePauseAction:(id) aSender;

- (IBAction)handleResumeAction:(id) aSender;


/* Internal spit wad field sprite services. */
- (void)update;


@end

