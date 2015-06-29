/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the Windjay audio services.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Windjay audio services imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "WeakReferenceProxy.h"

/* OpenAL imports. */
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

/* Cocoa imports. */
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Windjay audio services forward declarations.
 *
 ******************************************************************************/

@class WJAudioPlayer;
@class WJAudioFile;


/* *****************************************************************************
 *
 * Windjay audio services class definition.
 *
 ******************************************************************************/

@interface WJAudio : NSObject
{
    /*
     * mAudioPlayerDictionary   Dictionary of available audio players.
     * mAudioFileDictionary     Dictionary of open audio files.
     */

    NSMutableDictionary*        mAudioPlayerDictionary;
    NSMutableDictionary*        mAudioFileDictionary;
}


/* Windjay audio class services. */
+ (void)playAudioFromResource:(NSString*) aResourceName
    ofType:(NSString*) aResourceType;

+ (WJAudioPlayer*)getAudioPlayerFromResource:(NSString*) aResourceName
                  ofType:(NSString*)                     aResourceType;

+ (WJAudioPlayer*)getAudioPlayerFromURL:(NSURL*) aURL;

+ (WJAudioFile*)getAudioFileFromResource:(NSString*) aResourceName
                ofType:(NSString*)                   aResourceType;

+ (WJAudioFile*)getAudioFileFromURL:(NSURL*) aURL;


/* Windjay audio services. */
- (WJAudioPlayer*)getAudioPlayerFromResource:(NSString*) aResourceName
                  ofType:(NSString*)                     aResourceType;

- (WJAudioPlayer*)getAudioPlayerFromURL:(NSURL*) aURL;

- (WJAudioFile*)getAudioFileFromResource:(NSString*) aResourceName
                ofType:(NSString*)                   aResourceType;

- (WJAudioFile*)getAudioFileFromURL:(NSURL*) aURL;


@end


/* *****************************************************************************
 *
 * Windjay audio player class definition.
 *
 * Properties:
 *
 *   isReady                    If YES, audio player is ready to start.
 *   isRunning                  If YES, audio player is currently running.
 *
 ******************************************************************************/

/*
 * Windjay audio player configuration.
 *
 *   AUDIO_BUFFER_SIZE          Size of audio buffers.
 *   AUDIO_BUFFER_COUNT         Number of audio buffers to use.
 */

#define AUDIO_BUFFER_SIZE       16384
#define AUDIO_BUFFER_COUNT      1


@interface WJAudioPlayer : NSObject
{
    /*
     * mIsReady                 If YES, audio player is ready to start.
     * mIsRunning               If YES, audio player is currently running.
     *
     * mSelfProxy               Weak reference proxy to self.
     * mALSource                Open AL audio source.
     * mALBuffer                Open AL audio buffer.
     * mAudioFile               Audio file.
     * mAudioBufferSize         Size of audio buffers.
     * mAudioBufferCount        Number of audio buffers.
     */

    BOOL                        mIsReady;
    BOOL                        mIsRunning;

    WeakReferenceProxy*         mSelfProxy;
    ALuint                      mALSource;
    ALuint                      mALBuffer;
    WJAudioFile*                mAudioFile;
    UInt32                      mAudioBufferSize;
    UInt32                      mAudioBufferCount;
}


/* Properties. */
@property(assign) BOOL          isReady;
@property(assign) BOOL          isRunning;


/* Windjay audio player class services. */
+ (void)addAudioPlayer:(WJAudioPlayer*) aAudioPlayer;

+ (void)removeAudioPlayer:(WJAudioPlayer*) aAudioPlayer;

+ (void)monitorAudioPlayers;


/* Windjay audio player services. */
- (id)initWithResource:(NSString*)  aResourceName
      ofType:(NSString*)            aResourceType;

- (id)initWithURL:(NSURL*) aURL;

- (void)start;
- (void)start2;


/* Internal Windjay audio player services. */
- (void)allocateAudioBuffers;

- (void)makeReady;

- (BOOL)enqueueBuffer:(ALuint) aBuffer;

- (void)update;

- (void)reset;


@end


/* *****************************************************************************
 *
 * Windjay audio file class definition.
 *
 * Properties:
 *
 *   audioDesc                  Audio content description.
 *   audioDataByteCount         Count of the number of bytes of audio data.
 *
 ******************************************************************************/

@interface WJAudioFile : NSObject
{
    /*
     * mpAudioDesc              Pointer to audio content description.
     * mAudioDataByteCount      Count of the number of bytes of audio data.
     *
     * mAudioFileID             Audio file ID.
     * mAudioDesc               Audio content description.
     */

    AudioStreamBasicDescription*    mpAudioDesc;
    UInt64                          mAudioDataByteCount;

    AudioFileID                     mAudioFileID;
    AudioStreamBasicDescription     mAudioDesc;
}


/* Properties. */
@property(assign) AudioStreamBasicDescription*  audioDesc;
@property(assign) UInt64                        audioDataByteCount;


/* Windjay audio file services. */
- (id)initWithResource:(NSString*)  aResourceName
      ofType:(NSString*)            aResourceType;

- (id)initWithURL:(NSURL*) aURL;

- (void)readBytes:(void*)       aReadBuffer
        useCache:(BOOL)         aUseCache
        startingByte:(SInt64)   aStartingByte
        byteCount:(UInt32*)     aByteCount;

- (void)readPackets:(void*)     aReadBuffer
        useCache:(BOOL)         aUseCache
        readByteCount:(UInt32*) aReadByteCount
        packetDescriptions:(AudioStreamPacketDescription*) aPacketDescriptions
        startingPacket:(SInt64) aStartingPacket
        packetCount:(UInt32*)   aPacketCount;


@end


