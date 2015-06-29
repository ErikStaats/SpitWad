/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the sprite waves.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Sprite wave imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpriteViewController.h"


/* *****************************************************************************
 *
 * Forward declarations.
 *
 ******************************************************************************/

@class SpriteWaveInfo;


/* *****************************************************************************
 *
 * Sprite wave sequence class definition.
 *
 ******************************************************************************/

@interface SpriteWaveSequence : NSObject
{
    /*
     * mWaveSequence            Sequence of sprite waves.
     */

    NSMutableArray*             mWaveSequence;
}


/* Sprite wave sequence services. */
- (void)add:(NSTimeInterval)aStartTime,...;

- (SpriteWaveInfo*)getInfo:(NSInteger)aIndex;

@end


/* *****************************************************************************
 *
 * Sprite wave sequence base definition.
 *
 ******************************************************************************/

@protocol SpriteWaveSequenceBase

/*
 * initWithSprite
 *
 *   ==> aSpriteName            Name of sprite to use in waves.
 *   ==> aSpriteCount           Number of sprites in wave.
 *   ==> aSequenceTime          Time length of sequence.
 *
 *   <==                        Initialized sprite wave sequence.
 *
 *   This function initializes and returns a sprite wave sequence using the
 * sprite specified by aSpriteName, with the number of sprites specified by
 * aSpriteCount, and lasting the time specified by aSequenceTime.
 */

- (id)initWithSprite:(NSString*)    aSpriteName
      spriteCount:(NSUInteger)      aSpriteCount
      sequenceTime:(NSTimeInterval) aSequenceTime;


@end


/* *****************************************************************************
 *
 * Sprite wave info class definition.
 *
 * Properties:
 *
 *   mStartTime                 Time at which to start wave.
 *   mWaveName                  Name of sprite wave class.
 *   mSpriteName                Name of sprite class.
 *   mSpriteCount               Number of sprites in wave.
 *
 ******************************************************************************/

@interface SpriteWaveInfo : NSObject
{
    /*
     *   mStartTime             Time at which to start wave.
     *   mWaveName              Name of sprite wave class.
     *   mSpriteName            Name of sprite class.
     *   mSpriteCount           Number of sprites in wave.
     */

    NSTimeInterval              mStartTime;
    NSString*                   mWaveName;
    NSString*                   mSpriteName;
    NSUInteger                  mSpriteCount;
}

/* Properties. */
@property(assign) NSTimeInterval    startTime;
@property(retain) NSString*         waveName;
@property(retain) NSString*         spriteName;
@property(assign) NSUInteger        spriteCount;

@end


/* *****************************************************************************
 *
 * Sprite wave class definition.
 *
 ******************************************************************************/

@interface SpriteWave : SpriteViewController
{
    /*
     * mSpriteClass             Class of sprites in wave.
     * mSpriteCount             Number of sprites in wave.
     * mCurrentSpriteCount      Number of sprites currently in wave.
     * mTargetFactorList        List of target factors.
     * mWaveStartTime           Sprite step time of wave start.
     * mWaveTime                Elapsed sprite step time since start of wave.
     */

    id                          mSpriteClass;
    NSUInteger                  mSpriteCount;
    NSInteger                   mCurrentSpriteCount;
    NSMutableArray*             mTargetFactorList;
    NSTimeInterval              mWaveStartTime;
    NSTimeInterval              mWaveTime;
}


/* Sprite wave services. */
- (id)initWithSprite:(NSString*)    aSpriteName
      spriteCount:(NSUInteger)      aSpriteCount;


/* Internal sprite wave services. */
- (void)addSprite;


@end


/* *****************************************************************************
 *
 * Base sprite wave class definition.
 *
 ******************************************************************************/

@interface SpriteWaveBase : SpriteWave

/* Base sprite wave services. */
- (void)configureSpriteWave;


@end


