/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the background sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Background sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpriteViewController.h"


/* *****************************************************************************
 *
 * Background sprite delegate protocol definition.
 *
 ******************************************************************************/

@class BackgroundSprite;

@protocol BackgroundSpriteDelegate

/* Mark all methods as optional. */
@optional

/*
 * backgroundReady
 *
 *   ==> aBackgroundSprite      Background sprite that is ready.
 *
 *   This function is called when the background sprite specified by
 * aBackgroundSprite is ready.
 */

- (void)backgroundReady:(BackgroundSprite*) aBackgroundSprite;


@end


/* *****************************************************************************
 *
 * Background sprite class definition.
 *
 * Properties:
 *
 *   backgroundReady            If YES, background is ready to be used.
 *   backgroundSpriteDelegate   Delegate for background sprite.
 *
 ******************************************************************************/

@interface BackgroundSprite : SpriteViewController
{
    /*
     * mBackgroundReady         If YES, background is ready to be used.
     * mBackgroundSpriteDelegate
     *                          Delegate for background sprite.
     *
     * mBackgroundImageFileName Name of background image file.
     * mBackgroundImage         Background image.
     * mBackgroundDrawingContext
     *                          Context for drawing background images.
     * mBackgroundBlockImageList
     *                          List of background block images.
     */

    BOOL                        mBackgroundReady;
    id                          mBackgroundSpriteDelegate;

    NSString*                   mBackgroundImageFileName;
    CGImageRef                  mBackgroundImage;
    CGContextRef                mBackgroundDrawingContext;
    NSMutableArray*             mBackgroundBlockImageList;
}


/* Properties. */
@property(assign) BOOL          backgroundReady;
@property(assign) id<BackgroundSpriteDelegate>
                                backgroundSpriteDelegate;


/* Background sprite services. */
- (id)initWithImageFileName:(NSString*) aImageFileName;


/* Background sprite NSObject services. */
- (void)init2:(id)unused;

- (void)init3:(id)unused;


/* Internal background sprite services. */
- (void)loadBackgroundImages;

- (void)initBackground;


@end


