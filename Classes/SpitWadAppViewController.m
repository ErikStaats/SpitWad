/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad app view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad app view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadAppViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad app view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadAppViewController

/* Synthesize proeprties. */
@synthesize parentAppViewController = mParentAppViewController;


/* *****************************************************************************
 *
 * Spit wad app view controller NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Unload any current view controller. */
    if (mCurrentViewController)
        [self unload];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Spit wad app view controller services.
 *
 ******************************************************************************/

/*
 * load
 *
 *   ==> aViewController        View controller to load.
 *
 *   This function loads the view controller specified by aViewController as a
 * child, unloading the current child view controller.
 */

- (void)load:(SpitWadAppViewController*) aViewController
{
    /* Unload any current view controller. */
    if (mCurrentViewController)
        [self unload];

    /* Set self as the child view controller's parent. */
    aViewController.parentAppViewController = self;

    /* Add the view controller view to self view. */
    [self.view addSubview:aViewController.view];

    /* Set the new current view controller. */
    mCurrentViewController = [aViewController retain];
}


/*
 * unload
 *
 *   This function unloads the current child view controller.
 */

- (void)unload
{
    /* Do nothing if no current view controller. */
    if (!mCurrentViewController)
        return;

    /* Remove the current view controller view. */
    [mCurrentViewController.view removeFromSuperview];

    /* Release the current view controller. */
    [mCurrentViewController release];
    mCurrentViewController = nil;
}


@end


