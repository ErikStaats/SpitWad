/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad app delegate.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad app delegate imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadAppDelegate.h"
#import "Beacon.h" /*Added to implement Pinch Analytics Statistics*/


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad app delegate class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadAppDelegate

/* Synthesize properties. */
@synthesize window = mWindow;


/* *****************************************************************************
 *
 * Spit wad app delegate UIApplicationDelegate services.
 *
 ******************************************************************************/

/*
 * applicationDidFinishLaunching
 *
 *   ==> aApplication          The delegating application object.
 *
 *   Tells the delegate when the application has finished launching.
 */

- (void) applicationDidFinishLaunching:(UIApplication *)aApplication
{
    /* Start Pinch analytics. */
#if 0
    NSString *applicationCode = @"4e71c307597a2fd8b3078dde29fdfce8";
    [Beacon initAndStartBeaconWithApplicationCode:applicationCode
            useCoreLocation:YES
            useOnlyWiFi:NO];
#endif

    /* Create an initialize the spit wad top view controller. */
    mSpitWadTopViewController =
            [[SpitWadTopViewController alloc] initWithNibName:@"SpitWadTopView"
                                              bundle:[NSBundle mainBundle]];

    /* Add the spit wad top view controller to the window. */
    [mWindow addSubview:mSpitWadTopViewController.view];

    /* Make this window the key window and visible. */
    [mWindow makeKeyAndVisible];
}


/*
 * applicationWillTerminate
 *
 *   ==> aApplication           The delegating application object.
 *
 *   Tells the delegate when the application is about to terminate. This method
 * is optional.
 */

- (void)applicationWillTerminate:(UIApplication *)aApplication
{
    /* Stop Pinch analytics. */
#if 0
    [[Beacon shared] endBeacon];
#endif

    /* Create an auto-release pool, so all auto-releases */
    /* can be performed before terminating.              */
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    /* Release objects. */
    [mSpitWadTopViewController release];
    mSpitWadTopViewController = nil;
    [mWindow release];
    mWindow = nil;

    /* Release the auto-release pool. */
    [pool release];
	
	
	
}


/* *****************************************************************************
 *
 * Spit wad app delegate NSObject services.
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
    [mSpitWadTopViewController release];
    [mWindow release];

    /* Call the super-class dealloc. */
    [super dealloc];
}


@end

