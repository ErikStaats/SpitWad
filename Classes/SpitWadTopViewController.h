/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad top view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad top view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpitWadAppViewController.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Spit wad top view controller class definition.
 *
 ******************************************************************************/

@interface SpitWadTopViewController : SpitWadAppViewController
{
    /*
     * mIsLoading               If YES, a spit wad application view controller
     *                          is being loaded.
     */

    BOOL                        mIsLoading;
}


/* Internal spit wad top view controller services. */
- (void)initializeSettings;


@end


