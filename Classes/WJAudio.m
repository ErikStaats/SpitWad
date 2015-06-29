/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the Windjay audio services.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Windjay audio services imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "WJAudio.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Windjay audio services implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation WJAudio


/* *****************************************************************************
 *
 * Windjay audio services class static variables.
 *
 ******************************************************************************/

/*
 * gAudio                       Windjay audio services singleton.
 */

static WJAudio* gAudio;


/* *****************************************************************************
 *
 * Windjay audio services NSObject class services.
 *
 ******************************************************************************/

/*
 * initialize
 *
 *   This function initializes the Windjay audio services class.
 */

+ (void)initialize
{
    /* Don't initialize if sub-class is being initialized. */
    if (self != [WJAudio class])
        return;

    /* Initialize the Open AL context. */
    ALCdevice* alcDevice = NULL;
    ALCcontext* alcContext = NULL;
    alcDevice = alcOpenDevice(NULL);
    alcContext = alcCreateContext(alcDevice, 0);
    alcMakeContextCurrent(alcContext);

    /* Create the Windjay audio services singleton. */
    gAudio = [[WJAudio alloc] init];
}


/* *****************************************************************************
 *
 * Windjay audio services class services.
 *
 ******************************************************************************/

/*
 * playAudioFromResource
 *
 *   ==> aResourceName          Name of audio resource to play.
 *   ==> aResourceType          Type of audio resource to play.
 *
 *   This function plays the audio from the resource with the name specified by
 * aResourceName of the type specified by aResourceType.  The arguments are the
 * same as the arguments for NSBundle pathForResource:ofType:.
 */

+ (void)playAudioFromResource:(NSString*) aResourceName
    ofType:(NSString*) aResourceType
{
    /* Get an audio player. */
    WJAudioPlayer* audioPlayer =
                            [WJAudio getAudioPlayerFromResource:aResourceName
                                     ofType:aResourceType];

    /* Start playing. */
    [audioPlayer start];
}


/*
 * getAudioPlayerFromResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   <==                        Audio player.
 *
 *   This function gets a Windjay audio player for the audio resource with the
 * name specified by aResourceName of the type specified by aResourceType.  The
 * arguments are the same as the arguments for NSBundle pathForResource:ofType:.
 */

+ (WJAudioPlayer*)getAudioPlayerFromResource:(NSString*) aResourceName
                  ofType:(NSString*)                     aResourceType
{
    return [gAudio getAudioPlayerFromResource:aResourceName
                   ofType:aResourceType];
}


/*
 * getAudioPlayerFromURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio player.
 *
 *   This function gets a Windjay audio player for the audo file with the URL
 * specified by aURL.
 */

+ (WJAudioPlayer*)getAudioPlayerFromURL:(NSURL*) aURL
{
    return [gAudio getAudioPlayerFromURL:aURL];
}


/*
 * getAudioFileFromResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   <==                        Audio file.
 *
 *   This function gets a Windjay audio file with the audio resource with the
 * name specified by aResourceName of the type specified by aResourceType.  The
 * arguments are the same as the arguments for NSBundle pathForResource:ofType:.
 */

+ (WJAudioFile*)getAudioFileFromResource:(NSString*) aResourceName
                ofType:(NSString*)                   aResourceType
{
    /* Dispatch to the singleton. */
    return [gAudio getAudioFileFromResource:aResourceName
                   ofType:aResourceType];
}


/*
 * getAudioFileFromURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio file.
 *
 *   This function gets a Windjay audio file with the URL specified by aURL.
 */

+ (WJAudioFile*)getAudioFileFromURL:(NSURL*) aURL
{
    /* Dispatch to the singleton. */
    return [gAudio getAudioFileFromURL:aURL];
}


/* *****************************************************************************
 *
 * Windjay audio services NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes a Windjay audio services object.
 */

- (id)init
{
    /* Initialize super-class. */
    self = [super init];
    if (!self)
        return nil;

    /* Create the audio player and file dictionaries. */
    mAudioPlayerDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    mAudioFileDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Release references. */
    [mAudioPlayerDictionary release];
    [mAudioFileDictionary release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Windjay audio services.
 *
 ******************************************************************************/

/*
 * getAudioPlayerFromResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   <==                        Audio player.
 *
 *   This function gets a Windjay audio player for the audio resource with the
 * name specified by aResourceName of the type specified by aResourceType.  The
 * arguments are the same as the arguments for NSBundle pathForResource:ofType:.
 */

- (WJAudioPlayer*)getAudioPlayerFromResource:(NSString*) aResourceName
                  ofType:(NSString*)                     aResourceType
{
    /* Get the audio resource URL. */
    NSString* resourcePath =
                            [[NSBundle mainBundle] pathForResource:aResourceName
                                                   ofType:aResourceType];
    NSURL* resourceURL = [NSURL fileURLWithPath:resourcePath];

    return [self getAudioPlayerFromURL:resourceURL];
}


/*
 * getAudioPlayerFromURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio player.
 *
 *   This function gets a Windjay audio player for the audio file with the URL
 * specified by aURL.
 */

- (WJAudioPlayer*)getAudioPlayerFromURL:(NSURL*) aURL
{
    /* Try getting an available and ready audio player. */
    WJAudioPlayer* audioPlayer = nil;
    NSArray* audioPlayerList = [mAudioPlayerDictionary allKeysForObject:aURL];
    for (int i = 0; i < audioPlayerList.count; i++)
    {
        /* Get the next audio player. */
        WJAudioPlayer* _audioPlayer = [audioPlayerList objectAtIndex:i];

        /* Use audio player if it's not running and is ready. */
        if (!_audioPlayer.isRunning && _audioPlayer.isReady)
        {
            audioPlayer = _audioPlayer;
            break;
        }
    }

    /* Create a new audio player. */
    if (!audioPlayer)
    {
        /* Create the audio player. */
        audioPlayer = [[WJAudioPlayer alloc] initWithURL:aURL];

        /* Add the audio player to the list of audio players. */
        [mAudioPlayerDictionary setObject:aURL forKey:audioPlayer];
        [audioPlayer release];
    }

    [audioPlayer retain];
    return [audioPlayer autorelease];
}


/*
 * getAudioFileFromResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   <==                        Audio file.
 *
 *   This function gets a Windjay audio file with the audio resource with the
 * name specified by aResourceName of the type specified by aResourceType.  The
 * arguments are the same as the arguments for NSBundle pathForResource:ofType:.
 */

- (WJAudioFile*)getAudioFileFromResource:(NSString*) aResourceName
                ofType:(NSString*)                   aResourceType
{
    /* Get the audio resource URL. */
    NSString* resourcePath =
                            [[NSBundle mainBundle] pathForResource:aResourceName
                                                   ofType:aResourceType];
    NSURL* resourceURL = [NSURL fileURLWithPath:resourcePath];

    return [self getAudioFileFromURL:resourceURL];
}


/*
 * getAudioFileFromURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio file.
 *
 *   This function gets a Windjay audio file with the URL specified by aURL.
 */

- (WJAudioFile*)getAudioFileFromURL:(NSURL*) aURL
{
    /* Try getting an already opened audio file. */
    WJAudioFile* audioFile = [mAudioFileDictionary objectForKey:aURL];

    /* Open a new audio file. */
    if (!audioFile)
    {
        /* Open the audio file. */
        audioFile = [[[WJAudioFile alloc] initWithURL:aURL] autorelease];

        /* Add audio file to the open audio file dictionary. */
        [mAudioFileDictionary setObject:audioFile forKey:aURL];
    }

    return audioFile;
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Windjay audio player implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation WJAudioPlayer

/*
 * Windjay audio player class configuration.
 *
 *   AUDIO_PLAYER_MONITOR_PERIOD    Period of audio player monitoring timer.
 */

#define AUDIO_PLAYER_MONITOR_PERIOD 0.1


/* Synthesize properties. */
@synthesize isReady = mIsReady;
@synthesize isRunning = mIsRunning;


/* *****************************************************************************
 *
 * Windjay audio player NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Remove self from list of audio players. */
    [WJAudioPlayer removeAudioPlayer:(WJAudioPlayer*)mSelfProxy];

    /* Dispose of audio source and buffer. */
    alDeleteSources(1, &mALSource);
    alGenBuffers(1, &mALBuffer);

    /* Release object references. */
    mSelfProxy.target = nil;
    [mSelfProxy release];
    [mAudioFile release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Windjay audio player NSCopying services.
 *
 *   These services are provided so that Windjay audio players may be used as
 * NSDictionary keys.
 *
 ******************************************************************************/

/*
 * copyWithZone
 *
 *   ==> aZone                  The zone identifies an area of memory from which
 *                              to allocate for the new instance.
 *
 *   Returns a new instance that's a copy of the receiver.
 */

- (id)copyWithZone:(NSZone *)aZone
{
    return [self retain];
}


/* *****************************************************************************
 *
 * Windjay audio player class services.
 *
 ******************************************************************************/

/*
 * gAudioPlayerList             List of audio players.
 * gAudioPlayerMonitorTimer     Timer used to monitor the audio players.
 */

static NSMutableArray*          gAudioPlayerList = nil;
static NSTimer*                 gAudioPlayerMonitorTimer = nil;


/*
 * addAudioPlayer
 *
 *   ==> aAudioPlayer           Audio player to add.
 *
 *   This function adds the audio player specified by aAudioPlayer to the list
 * of audio players.
 */

+ (void)addAudioPlayer:(WJAudioPlayer*) aAudioPlayer
{
    /* Ensure the audio player list is initialized. */
    if (!gAudioPlayerList)
        gAudioPlayerList = [[NSMutableArray alloc] initWithCapacity:0];

    /* Add the audio player. */
    if (![gAudioPlayerList containsObject:aAudioPlayer])
        [gAudioPlayerList addObject:aAudioPlayer];

    /* Ensure the audio players are being monitored. */
    if (!gAudioPlayerMonitorTimer)
    {
        gAudioPlayerMonitorTimer =
            [NSTimer scheduledTimerWithTimeInterval:AUDIO_PLAYER_MONITOR_PERIOD
                     target:self
                     selector:@selector(monitorAudioPlayers)
                     userInfo:nil
                     repeats:YES];
    }
}


/*
 * removeAudioPlayer
 *
 *   ==> aAudioPlayer           Audio player to remove.
 *
 *   This function removes the audio player specified by aAudioPlayer from the
 * list of audio players.
 */

+ (void)removeAudioPlayer:(WJAudioPlayer*) aAudioPlayer
{
    /* Do nothing if the audio player list is not initialized. */
    if (!gAudioPlayerList)
        return;

    /* Remove the audio player. */
    [gAudioPlayerList removeObject:aAudioPlayer];

    /* Stop monitoring audio players if there aren't any. */
    if (!gAudioPlayerList.count)
    {
        [gAudioPlayerMonitorTimer invalidate];
        [gAudioPlayerMonitorTimer release];
        gAudioPlayerMonitorTimer = nil;
    }

    /* Release the audio player list if it's empty. */
    if (!gAudioPlayerList.count)
    {
        [gAudioPlayerList release];
        gAudioPlayerList = nil;
    }

}


/*
 * monitorAudioPlayers
 *
 *   This function monitors the state of all audio players.
 */

+ (void)monitorAudioPlayers
{
    /* Update all audio players. */
    for (NSUInteger i = 0; i < gAudioPlayerList.count; i++)
    {
        WJAudioPlayer* audioPlayer = [gAudioPlayerList objectAtIndex:i];
        [audioPlayer update];
    }
}


/* *****************************************************************************
 *
 * Windjay audio player services.
 *
 ******************************************************************************/

/*
 * initWithResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   This function initializes an audio player with the audio resource with the
 * name specified by aResourceName of the type specified by aResourceType.  The
 * arguments are the same as the arguments for NSBundle pathForResource:ofType:.
 */

- (id)initWithResource:(NSString*)  aResourceName
      ofType:(NSString*)            aResourceType
{
    /* Get the audio resource URL. */
    NSString* resourcePath =
                            [[NSBundle mainBundle] pathForResource:aResourceName
                                                   ofType:aResourceType];
    NSURL* resourceURL = [NSURL fileURLWithPath:resourcePath];

    /* Initialize. */
    self = [self initWithURL:resourceURL];
    if (!self)
        return nil;

    return self;
}


/*
 * initWithURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio file.
 *
 *   This function initializes a Windjay audio player with the URL specified by
 * aURL.
 */

- (id)initWithURL:(NSURL*) aURL
{
    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    /* Create a self weak reference proxy. */
    mSelfProxy = [[WeakReferenceProxy alloc] init];
    mSelfProxy.target = self;

    /* Get the audio file. */
    mAudioFile = [[WJAudio getAudioFileFromURL:aURL] retain];

    /* Create an audio source. */
    alGenSources(1, &mALSource);

    /* Add self to list of audio players. */
    [WJAudioPlayer addAudioPlayer:(WJAudioPlayer*)mSelfProxy];

    return self;
}


/*
 * start
 *
 *   This function starts the audio player playing.
 */

- (void)start
{
    /* Add a self reference so that the audio continues    */
    /* playing even if the creator releases its reference. */
    [self retain];

    /* Indicate that the audio player is running. */
    mIsRunning = YES;

    /* Start playing from a separate thread. */
    [NSThread detachNewThreadSelector:@selector(start2)
              toTarget:self
              withObject:nil];
}

- (void)start2
{
    /* Create an auto-release pool for the thread. */
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    /* Allocate audio buffers. */
    [self allocateAudioBuffers];

    /* Make the audio player ready. */
    [self makeReady];

    /* Start playing the audio source. */
    alSourcePlay(mALSource);

    /* Release the auto-release pool. */
    [pool release];
}


/* *****************************************************************************
 *
 * Internal Windjay audio player services.
 *
 ******************************************************************************/

/*
 * allocateAudioBuffers
 *
 *   This function allocates audio player buffers.
 */

- (void)allocateAudioBuffers
{
    /* Do nothing if audio buffers have already been allocated. */
    if (mAudioBufferCount > 0)
        return;

    /* Set the number of audio buffers. */
    mAudioBufferCount = AUDIO_BUFFER_COUNT;

    /* Allocate audio buffers. */
    mAudioBufferSize = AUDIO_BUFFER_SIZE;
    alGenBuffers(1, &mALBuffer);
}


/*
 * makeReady
 *
 *   This function makes the audio player ready for playback.
 */

- (void)makeReady
{
    /* Do nothing if audio player is ready. */
    if (mIsReady)
        return;

    /* Enqueue audio buffers. */
    for (int i = 0; i < mAudioBufferCount; i++)
    {
        if (![self enqueueBuffer:mALBuffer])
            break;
    }

    /* Indicate that the audio player is ready. */
    mIsReady = YES;
}


/*
 * enqueueBuffer
 *
 *   ==> aBuffer                Buffer to enqueue.
 *
 *   <== YES                    Buffer was enqueued.
 *
 *   This function fills the audio queue buffer specified by aBuffer with audio
 * data and enqueues it in the audio queue.  If the buffer was successfully
 * enqueued, this function returns YES.  If there is no more data, this function
 * does not enqueue the buffer and returns NO.
 */

- (BOOL)enqueueBuffer:(ALuint) aBuffer
{
    /* Get the buffer size. */
    ALint bufferSize;
    alGetBufferi(aBuffer, AL_SIZE, &bufferSize);

    /* Fill buffer with content if it's not already. */
    if (!bufferSize)
    {
        /* Get the amount of audio data. */
        UInt32 audioDataByteCount= mAudioFile.audioDataByteCount;

        /* Create an audio data buffer. */
        ALvoid* dataBuffer;
        dataBuffer = malloc(audioDataByteCount);
        if (!dataBuffer)
            return NO;

        /* Read the audio data. */
        [mAudioFile readBytes:dataBuffer
                    useCache:YES
                    startingByte:0
                    byteCount:&audioDataByteCount];

        /* Convert the audio data endianess. */
        for (UInt32 i = 0; i < audioDataByteCount/2; i++)
        {
            UInt16 word = ((UInt16*) dataBuffer)[i];
            word = ((word & 0xFF) << 8) | ((word & 0xFF00) >> 8);
            ((UInt16*) dataBuffer)[i] = word;
        }

        /* Get some audio format info. */
        ALenum format;
        ALsizei freq;
        if (mAudioFile.audioDesc->mChannelsPerFrame > 1)
            format = AL_FORMAT_STEREO16;
        else
            format = AL_FORMAT_MONO16;
        freq = mAudioFile.audioDesc->mSampleRate;

        /* Set up the buffer with the data. */
        alBufferData(mALBuffer, format, dataBuffer, audioDataByteCount, freq);

        /* Free the audio data buffer. */
        free(dataBuffer);
    }

    /* Enqueue buffer in the source. */
    alSourcei(mALSource, AL_BUFFER, aBuffer);

    return YES;
}


/*
 * update
 *
 *   This function updates the state of the audio player.
 */

- (void)update
{
    /* Get the running state of the audio source. */
    UInt32 isRunning;
    ALint state;
    alGetSourcei(mALSource, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING)
        isRunning = NO;

    /* Reset audio player if it's no longer running. */
    if (mIsRunning && !isRunning)
        [self reset];
}


/*
 * reset
 *
 *   This function resets the audio player.
 */

- (void)reset
{
    /* Indicate that the audio player is no   */
    /* longer running and is no longer ready. */
    mIsRunning = NO;
    mIsReady = NO;

    /* Make the audio player ready. */
    [self makeReady];

    /* Release self reference. */
    [self release];
}


@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Windjay audio file implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation WJAudioFile

/* Synthesize properties. */
@synthesize audioDesc = mpAudioDesc;
@synthesize audioDataByteCount = mAudioDataByteCount;


/* *****************************************************************************
 *
 * Windjay audio file NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes a Windjay audio player.
 */

- (id)init
{
    /* Initialize super-class. */
    self = [super init];
    if (!self)
        return nil;

    /* Initialize fields. */
    mpAudioDesc = &mAudioDesc;

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Close the audio file. */
    AudioFileClose(mAudioFileID);

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Windjay audio file services.
 *
 ******************************************************************************/

/*
 * initWithResource
 *
 *   ==> aResourceName          Name of audio resource.
 *   ==> aResourceType          Type of audio resource.
 *
 *   This function initializes a Windjay audio file with the audio resource with
 * the name specified by aResourceName of the type specified by aResourceType.
 * The arguments are the same as the arguments for NSBundle
 * pathForResource:ofType:.
 */

- (id)initWithResource:(NSString*)  aResourceName
      ofType:(NSString*)            aResourceType
{
    /* Get the audio resource URL. */
    NSString* resourcePath =
                            [[NSBundle mainBundle] pathForResource:aResourceName
                                                   ofType:aResourceType];
    NSURL* resourceURL = [NSURL fileURLWithPath:resourcePath];

    /* Initialize. */
    self = [self initWithURL:resourceURL];
    if (!self)
        return nil;

    return self;
}


/*
 * initWithURL
 *
 *   ==> aURL                   URL of audio file.
 *
 *   <==                        Audio file.
 *
 *   This function initializes a Windjay audio file with the URL specified by
 * aURL.
 */

- (id)initWithURL:(NSURL*) aURL
{
    UInt32   size;
    OSStatus status;

    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    /* Open the audio file. */
    status = AudioFileOpenURL((CFURLRef) aURL,
                              kAudioFileReadPermission,
                              0,
                              &mAudioFileID);
    if (status != noErr)
        return nil;

    /* Get the audio info. */
    size = sizeof(mAudioDesc);
    memset(&mAudioDesc, 0, size);
    status = AudioFileGetProperty(mAudioFileID,
                                  kAudioFilePropertyDataFormat,
                                  &size,
                                  &mAudioDesc);
    if (status != noErr)
        return nil;

    /* Get the audio data byte count. */
    size = sizeof(mAudioDataByteCount);
    mAudioDataByteCount = 0;
    status = AudioFileGetProperty(mAudioFileID,
                                  kAudioFilePropertyAudioDataByteCount,
                                  &size,
                                  &mAudioDataByteCount);
    if (status != noErr)
        return nil;

    return self;
}


/*
 * readBytes
 *
 *   ==> aReadBuffer            Buffer into which to read.
 *   ==> aUseCache              If YES, use a read cache.
 *   ==> aStartingByte          Byte at which to start reading.
 *   ==> aByteCount             Number of bytes to read.
 *
 *   This function reads audio byte data from the Windjay audio file into the
 * buffer specified by aReadBuffer.  It operates in a fashion similar to
 * AudioFileReadBytes.
 */

- (void)readBytes:(void*)       aReadBuffer
        useCache:(BOOL)         aUseCache
        startingByte:(SInt64)   aStartingByte
        byteCount:(UInt32*)     aByteCount
{
    OSStatus status;

    /* Read the data. */
    UInt32 byteCount = *aByteCount;
    status = AudioFileReadBytes(mAudioFileID,
                                aUseCache,
                                aStartingByte,
                                &byteCount,
                                aReadBuffer);

    /* Return results. */
    if (status == noErr)
    {
        *aByteCount = byteCount;
    }
    else
    {
        *aByteCount = 0;
    }
}


/*
 * readPackets
 *
 *   ==> aReadBuffer            Buffer into which to read.
 *   ==> aUseCache              If YES, use a read cache.
 *   <== aReadByteCount         Number of bytes read.
 *   <== aPacketDescriptions    Audio packet descriptions.
 *   ==> aStartingPacket        Packet at which to start reading.
 *   <=> aPacketCount           On input, number of packets to read.  On output,
 *                              number of packets actually read.
 *
 *   This function reads audio packet data from the Windjay audio file into the
 * buffer specified by aReadBuffer.  It operates in a fashion similar to
 * AudioFileReadPackets.
 */

- (void)readPackets:(void*)     aReadBuffer
        useCache:(BOOL)         aUseCache
        readByteCount:(UInt32*) aReadByteCount
        packetDescriptions:(AudioStreamPacketDescription*) aPacketDescriptions
        startingPacket:(SInt64) aStartingPacket
        packetCount:(UInt32*)   aPacketCount
{
    OSStatus status;

    /* Read the packet data. */
    UInt32 readByteCount;
    UInt32 packetCount = *aPacketCount;
    status = AudioFileReadPackets(mAudioFileID,
                                  aUseCache,
                                  &readByteCount,
                                  aPacketDescriptions,
                                  aStartingPacket,
                                  &packetCount,
                                  aReadBuffer);

    /* Return results. */
    if (status == noErr)
    {
        *aReadByteCount = readByteCount;
        *aPacketCount = packetCount;
    }
    else
    {
        *aReadByteCount = 0;
        *aPacketCount = 0;
    }
}

@end


