/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the sprite waves.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Sprite wave imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpriteWave.h"

/* Local imports. */
#import "WJGeometry.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave sequence 1 implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface SpriteWaveSequence1 : SpriteWaveSequence <SpriteWaveSequenceBase>
@end

@implementation SpriteWaveSequence1

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
      sequenceTime:(NSTimeInterval) aSequenceTime
{
    NSTimeInterval sequenceTime;

    /* Initialize super-class. */
    self = [super init];
    if (!self)
        return nil;

    /* Add a set of waves to fill sequence time. */
    sequenceTime = 1.0;
    while (sequenceTime <= aSequenceTime)
    {
        [self add: sequenceTime, @"SpriteWave1", aSpriteName, aSpriteCount];
        sequenceTime += 5.0;
    }

    /* Add another set of waves to fill sequence time. */
    sequenceTime = 3.0;
    while (sequenceTime <= aSequenceTime)
    {
        [self add: sequenceTime, @"SpriteWave2", aSpriteName, aSpriteCount];
        sequenceTime += 5.0;
    }

    return self;
}
@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave 1 implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface SpriteWave1 : SpriteWaveBase
@end

@implementation SpriteWave1

/*
 * configureSpriteWave
 *
 *   This function sets up the sprite wave.
 */

- (void)configureSpriteWave
{
    /* Invoke the super-class. */
    [super configureSpriteWave];

    /* Configure the target factor list. */
    mTargetFactorList = [[NSMutableArray alloc] initWithCapacity:0];
    [mTargetFactorList addObject:[WJPoint get:0.8, -0.1]];
    [mTargetFactorList addObject:[WJPoint get:0.8, 0.33]];
    [mTargetFactorList addObject:[WJPoint get:0.66, 0.5]];
    [mTargetFactorList addObject:[WJPoint get:0.66, 0.33]];
    [mTargetFactorList addObject:[WJPoint get:0.8, -0.1]];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave 2 implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@interface SpriteWave2 : SpriteWaveBase
@end

@implementation SpriteWave2

/*
 * configureSpriteWave
 *
 *   This function sets up the sprite wave.
 */

- (void)configureSpriteWave
{
    /* Invoke the super-class. */
    [super configureSpriteWave];

    /* Configure the target factor list. */
    mTargetFactorList = [[NSMutableArray alloc] initWithCapacity:0];
    [mTargetFactorList addObject:[WJPoint get:0.2, -0.1]];
    [mTargetFactorList addObject:[WJPoint get:0.2, 0.33]];
    [mTargetFactorList addObject:[WJPoint get:0.33, 0.5]];
    [mTargetFactorList addObject:[WJPoint get:0.33, 0.33]];
    [mTargetFactorList addObject:[WJPoint get:0.2, -0.1]];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Base sprite wave implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteWaveBase

/* *****************************************************************************
 *
 * Base sprite wave NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the base sprite wave.
 */

- (id)init
{
    /* Initialize the super-class. */
    self = [super init];
    if (!self)
        return nil;

    /* Configure the sprite wave. */
    [self configureSpriteWave];

    return self;
}


/* *****************************************************************************
 *
 * Base sprite wave services.
 *
 ******************************************************************************/

/*
 * configureSpriteWave
 *
 *   This function sets up the sprite wave.
 */

- (void) configureSpriteWave
{
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave sequence implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteWaveSequence

/* *****************************************************************************
 *
 * Sprite wave sequence NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   <==                        Initialized sprite wave sequence.
 *
 *   This function initializes the sprite wave sequence.
 */

- (id)init
{
    /* Initialize super-class. */
    self = [super init];
    if (!self)
        return nil;

    /* Create the wave sequence array. */
    mWaveSequence = [[NSMutableArray alloc] initWithCapacity:0];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Release objects. */
    [mWaveSequence release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Sprite wave sequence services.
 *
 ******************************************************************************/

/*
 * add
 *
 *   ==> aStartTime             Sprite time to start wave.
 *   ==>                        Wave class name (NSString*).
 *   ==>                        Sprite class name (NSString*).
 *   ==>                        Number of sprites in wave (NSInteger).
 *
 *   This function adds a new wave to the sequence with the specified start
 * time, wave class name, sprite class name, and wave sprite count.
 */

- (void)add:(NSTimeInterval)aStartTime,...
{
    /* Get the argument list. */
    va_list argList;
    va_start(argList, aStartTime);

    /* Get the sprite wave info. */
    SpriteWaveInfo* newSpriteWaveInfo = [[SpriteWaveInfo alloc] init];
    newSpriteWaveInfo.startTime = aStartTime;
    newSpriteWaveInfo.waveName = va_arg(argList, NSString*);
    newSpriteWaveInfo.spriteName = va_arg(argList, NSString*);
    newSpriteWaveInfo.spriteCount = va_arg(argList, NSInteger);

    /* Add the sprite wave info to the sequence. */
    for (NSInteger i = 0; i < mWaveSequence.count; i++)
    {
        SpriteWaveInfo* spriteWaveInfo = [mWaveSequence objectAtIndex:i];
        if (spriteWaveInfo.startTime > newSpriteWaveInfo.startTime)
        {
            [mWaveSequence insertObject:newSpriteWaveInfo atIndex:i];
            [newSpriteWaveInfo release];
            newSpriteWaveInfo = nil;
            break;
        }
    }
    if (newSpriteWaveInfo)
    {
        [mWaveSequence addObject:newSpriteWaveInfo];
        [newSpriteWaveInfo release];
        newSpriteWaveInfo = nil;
    }

    /* End argument list. */
    va_end(argList);
}


/*
 * getInfo
 *
 *   ==> aIndex                 Index of wave in sequence for which to get info.
 *
 *   <==                        Info for wave.
 *
 *   This function returns the info for the wave with the index specified by
 * aIndex.
 */

- (SpriteWaveInfo*)getInfo:(NSInteger)aIndex
{
    /* Bounds check index. */
    if (aIndex >= mWaveSequence.count)
        return nil;

    return [[[mWaveSequence objectAtIndex:aIndex] retain] autorelease];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave info implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteWaveInfo

/* Synthesize properties. */
@synthesize startTime = mStartTime;
@synthesize waveName = mWaveName;
@synthesize spriteName = mSpriteName;
@synthesize spriteCount = mSpriteCount;

/* *****************************************************************************
 *
 * Sprite wave info NSObject services.
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
    [mWaveName release];
    [mSpriteName release];

    /* Invoke the super-class. */
    [super dealloc];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite wave implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteWave

/*
 * Sprite wave class configuration.
 *
 *   SPRITE_WAVE_SPRITE_INTERVAL    Time intervale between wave sprites.
 */

#define SPRITE_WAVE_SPRITE_INTERVAL 0.5


/* *****************************************************************************
 *
 * Sprite wave NSObject services.
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
    [mTargetFactorList release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Sprite wave SpriteViewController services.
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
    /* Get the wave time. */
    if (!mWaveStartTime)
        mWaveStartTime = aStepTime;
    mWaveTime = aStepTime - mWaveStartTime;

    /* Add specified number of sprites to wave. */
    if (mCurrentSpriteCount < mSpriteCount)
    {
        /* Add wave sprites in time intervals. */
        if (mWaveTime >= (mCurrentSpriteCount * SPRITE_WAVE_SPRITE_INTERVAL))
        {
            [self addSprite];
            mCurrentSpriteCount++;
        }
    }

    /* Remove self when wave is done. */
    if (mCurrentSpriteCount >= mSpriteCount)
        [self.parentSprite removeChild:self];
}


/* *****************************************************************************
 *
 * Sprite wave services.
 *
 ******************************************************************************/

/*
 * initWithSprite
 *
 *   ==> aSpriteName            Name of sprite to use in wave.
 *   ==> aSpriteCount           Number of sprites in wave.
 *
 *   <==                        Sprite wave object.
 *
 *   This function initializes and returns a sprite wave object that will add a
 * wave of sprites of type specified by aSpriteName to the sprite wave parent
 * sprite.  The sprite wave will add the number of sprites specified by
 * aSpriteCount.
 */

- (id)initWithSprite:(NSString*)           aSpriteName
      spriteCount:(NSUInteger)             aSpriteCount
{
    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    /* Get the sprite class and count. */
    mSpriteClass = objc_getClass([aSpriteName UTF8String]);
    mSpriteCount = aSpriteCount;

    return self;
}


/* *****************************************************************************
 *
 * Internal sprite wave services.
 *
 ******************************************************************************/

/*
 * addSprite
 *
 *   This function adds a wave sprite.
 */

- (void)addSprite
{
    /* Create a new sprite. */
    SpriteViewController* sprite = [[[mSpriteClass alloc] init] autorelease];

    /* Add the sprite targets. */
    if (mTargetFactorList)
    {
        for (int i = 0; i < mTargetFactorList.count; i++)
        {
            /* Get the next target factor. */
            WJPoint* targetFactor = [mTargetFactorList objectAtIndex:i];

            /* Get the next target. */
            CGRect bounds = mParentSprite.spriteView.bounds;
            CGPoint target = bounds.origin;
            target.x += targetFactor.point.x * bounds.size.width;
            target.y += targetFactor.point.y * bounds.size.height;

            /* Add the target. */
            if (i == 0)
                sprite.spriteView.center = target;
            else
                [sprite addTarget:target];
        }
    }

    /* Set to remove sprite after reaching last target. */
    sprite.removeAfterLastTarget = YES;

    /* Add sprite to parent. */
    [mParentSprite addChild:sprite];
}


@end


