/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad app delegate.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad app delegate imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpitWadTopViewController.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Spit wad app delegate class definition.
 *
 ******************************************************************************/

/*
 * SpitWadAppDelegate
 *
 *   mWindow                    Application window.
 *   mSpitWadTopViewController  Spit wad top view controller.
 */

@interface SpitWadAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow*                   mWindow;
    SpitWadTopViewController*   mSpitWadTopViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


