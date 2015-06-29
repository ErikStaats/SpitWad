/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the background sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Background sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "BackgroundSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Background sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

/*
 * Background sprite class configuration.
 *
 *   BACKGROUND_BLOCK_SIZE      Size in pixels (height and width) of background
 *                              blocks. zzz must be 320.0
 */

#define BACKGROUND_BLOCK_SIZE   320.0


@implementation BackgroundSprite

/* Synthesize properties. */
@synthesize backgroundReady = mBackgroundReady;
@dynamic backgroundSpriteDelegate;


/* *****************************************************************************
 *
 * Background sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the background sprite.
 */

- (id)init
{
    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the sprite view. */
    UIView* spriteView = [[UIView alloc] initWithFrame:CGRectZero];
    self.spriteView = spriteView;

    /* Create the background block image list. */
    mBackgroundBlockImageList = [[NSMutableArray alloc] initWithCapacity:0];

    /* Create the background drawing context. */
    UIGraphicsBeginImageContext(CGSizeMake(BACKGROUND_BLOCK_SIZE,
                                           BACKGROUND_BLOCK_SIZE));
    mBackgroundDrawingContext = CGContextRetain(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();

    /* Transform the background drawing context into the iPhone geometry. */
    CGContextTranslateCTM(mBackgroundDrawingContext,
                          0.0,
                          BACKGROUND_BLOCK_SIZE);
    CGContextScaleCTM(mBackgroundDrawingContext, 1.0, -1.0);

    /* Continue initialization from a separate thread. */
    [NSThread detachNewThreadSelector:@selector(init2:)
              toTarget:self
              withObject:nil];

    /* Release object references. */
    [spriteView release];

    return self;
}

- (void)init2:(id)unused
{
    /* Create an auto-release pool for the thread. */
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    /* Load the background images. */
    [self loadBackgroundImages];

    /* Continue initialization from the main thread. */
    [self performSelectorOnMainThread:@selector(init3:)
          withObject:nil
          waitUntilDone:NO];

    /* Release the auto-release pool. */
    [pool release];
}

- (void)init3:(id)unused
{
    /* Initialize the background. */
    [self initBackground];

    /* Indicate that the background is ready. */
    mBackgroundReady = YES;
    if (mBackgroundSpriteDelegate)
    {
        if ([mBackgroundSpriteDelegate
                                respondsToSelector:@selector(backgroundReady:)])
        {
            [mBackgroundSpriteDelegate backgroundReady:self];
        }
    }
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Release objects. */
    [mBackgroundImageFileName release];
    CGImageRelease(mBackgroundImage);
    CGContextRelease(mBackgroundDrawingContext);
    [mBackgroundBlockImageList release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Background sprite services.
 *
 ******************************************************************************/

/*
 * initWithImageFileName
 *
 *   ==> aImageFileName         Name of background image file.
 *
 *   This function initializes the background sprite with the image file
 * specified by aImageFileName.
 */

- (id)initWithImageFileName:(NSString*) aImageFileName;
{
    /* Get the background image file name. */
    mBackgroundImageFileName = aImageFileName;

    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    return self;
}


/*
 * backgroundSpriteDelegate
 */

- (id<BackgroundSpriteDelegate>)backgroundSpriteDelegate
{
    return mBackgroundSpriteDelegate;
}

- (void)setBackgroundSpriteDelegate:
                        (id<BackgroundSpriteDelegate>) aBackgroundSpriteDelegate
{
    /* Set the background sprite delegate. */
    mBackgroundSpriteDelegate = aBackgroundSpriteDelegate;

    /* Invoke the delegate background ready */
    /* method if the background is ready.   */
    if (mBackgroundReady && mBackgroundSpriteDelegate)
    {
        if ([mBackgroundSpriteDelegate
                                respondsToSelector:@selector(backgroundReady:)])
        {
            [mBackgroundSpriteDelegate backgroundReady:self];
        }
    }
}


/* *****************************************************************************
 *
 * Internal background sprite services.
 *
 ******************************************************************************/

/*
 * loadBackgroundImages
 *
 *   This function loads the background images.  It runs on a background thread.
 */

- (void)loadBackgroundImages
{
    /* Get the background image file. */
    NSURL* imageFileURL =
            [NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:mBackgroundImageFileName
                                       ofType:nil]];

    /* Load the background image. */
    NSData* imageData = [NSData dataWithContentsOfURL:imageFileURL
                                options:NSMappedRead
                                error:nil];
    UIImage* uiImage = [UIImage imageWithData:imageData];
    mBackgroundImage = CGImageRetain(uiImage.CGImage);

    /* Set the sprite size to the background image size. */
    CGRect frame = self.spriteView.frame;
    frame.size.width = CGImageGetWidth(mBackgroundImage);
    frame.size.height = CGImageGetHeight(mBackgroundImage);
    self.spriteView.frame = frame;

    /* Divide the background image into multiple image blocks. */
    CGSize backgroundImageBlockSize;
    backgroundImageBlockSize.width = (float) CGImageGetWidth(mBackgroundImage);
    backgroundImageBlockSize.height = BACKGROUND_BLOCK_SIZE;
    float backgroundImageHeight = (float) CGImageGetHeight(mBackgroundImage);
    int numBlocks =   (backgroundImageHeight / backgroundImageBlockSize.height)
                    + 1;
    for (int i = 0; i < numBlocks; i++)
    {
        /* Get the block rect. */
        CGRect rect;
        rect.origin.x = 0.0;
        rect.origin.y = i * backgroundImageBlockSize.height;
        rect.size = backgroundImageBlockSize;

        /* Get the block image. */
        CGImageRef blockImage = CGImageCreateWithImageInRect(mBackgroundImage,
                                                             rect);

        /* Get the block image drawn in the background drawing context. */
        rect.origin.y = 0.0;
        CGContextDrawImage(mBackgroundDrawingContext, rect, blockImage);
        CGImageRelease(blockImage);
        blockImage = CGBitmapContextCreateImage(mBackgroundDrawingContext);

        /* Add the block image. */
        @synchronized(mBackgroundBlockImageList)
        {
            [mBackgroundBlockImageList addObject:(id)blockImage];
        }

        /* Release objects. */
        CGImageRelease(blockImage);
    }
}


/*
 * initBackground
 *
 *   This function initializes the background.
 */

- (void)initBackground
{
    /* Divide the background image into multiple image block views. */
    CGSize backgroundImageBlockSize;
    backgroundImageBlockSize.width = (float) CGImageGetWidth(mBackgroundImage);
    backgroundImageBlockSize.height = BACKGROUND_BLOCK_SIZE;
    float backgroundImageHeight = (float) CGImageGetHeight(mBackgroundImage);
    int numBlocks =   (backgroundImageHeight / backgroundImageBlockSize.height)
                    + 1;
    for (int i = 0; i < numBlocks; i++)
    {
        /* Get the block rect. */
        CGRect rect;
        rect.origin.x = 0.0;
        rect.origin.y = i * backgroundImageBlockSize.height;
        rect.size = backgroundImageBlockSize;

        /* Get the block image. */
        CGImageRef blockImage;
        @synchronized(mBackgroundBlockImageList)
        {
            blockImage =
                    (CGImageRef) [mBackgroundBlockImageList objectAtIndex:i];
        }

        /* Create a block image view and add it to the background view. */
        UIImage* blockUIImage = [UIImage imageWithCGImage:blockImage];
        UIImageView* blockImageView =
                            [[UIImageView alloc] initWithImage:blockUIImage];
        blockImageView.frame = rect;
        [self.spriteView addSubview:blockImageView];

        /* Release objects. */
        [blockImageView release];
    }
}


@end


