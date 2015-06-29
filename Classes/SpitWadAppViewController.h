/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad app view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad app view controller imported services.
 *
 ******************************************************************************/

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Spit wad app view controller class definition.
 *
 * Properties:
 *
 *   parentAppViewController    Parent spit wad app view controller.
 *
 ******************************************************************************/

@interface SpitWadAppViewController : UIViewController
{
    /*
     * mParentAppViewController Parent spit wad app view controller.
     *
     * mCurrentViewController   Current child view controller.
     */

    SpitWadAppViewController*   mParentAppViewController;

    SpitWadAppViewController*   mCurrentViewController;
}


/* Properties. */
@property(assign) SpitWadAppViewController* parentAppViewController;


/* Spit wad app view controller services. */
- (void)load:(SpitWadAppViewController*) aViewController;

- (void)unload;


@end


