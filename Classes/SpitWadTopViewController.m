/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad top view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad top view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadTopViewController.h"

/* Local imports. */
#import "SpitWadTitleViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad top view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadTopViewController

/* *****************************************************************************
 *
 * Spit wad top view controller NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Spit wad top view controller UIViewController services.
 *
 ******************************************************************************/

/*
 * viewDidLoad
 *
 *   Invoked when the view is finished loading.
 */

- (void)viewDidLoad
{
    /* Initialize the application settings. */
    [self initializeSettings];

    /* Load the default child view controller. */
    SpitWadTitleViewController* controller =
        [[SpitWadTitleViewController alloc] initWithNibName:@"SpitWadTitleView"
                                           bundle:[NSBundle mainBundle]];
    [self load:controller];

    /* Release objects. */
    [controller release];

    /* Invoke super-class. */
    [super viewDidLoad];
}


/* *****************************************************************************
 *
 * Spit wad top view controller SpitWadAppViewController services.
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
    /* Indicate that a load is being performed. */
    mIsLoading = YES;

    /* Invoke the super-class. */
    [super load:aViewController];

    /* Inidcate that a load is no longer being performed. */
    mIsLoading = NO;
}


/*
 * unload
 *
 *   This function unloads the current child view controller.
 */

- (void)unload
{
    /* Invoke the super-class. */
    [super unload];

    /* If a load is not being performed, load the default view controller. */
    if (!mIsLoading)
    {
        /* Load the default child view controller. */
        SpitWadTitleViewController* controller =
            [[SpitWadTitleViewController alloc]
                                            initWithNibName:@"SpitWadTitleView"
                                            bundle:[NSBundle mainBundle]];
        [self load:controller];

        /* Release objects. */
        [controller release];
    }
}


/* *****************************************************************************
 *
 * Internal spit wad top view controller services.
 *
 ******************************************************************************/

/*
 * initializeSettings
 *
 *   This function initializes the application settings.
 */

- (void)initializeSettings
{
    /* Load the default settings into the user defaults. */
    NSString* userDefaultsValuesPath =
                    [[NSBundle mainBundle] pathForResource:@"DefaultSettings"
                                           ofType:@"plist"];
    NSDictionary* userDefaultsValuesDict =
            [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    [[NSUserDefaults standardUserDefaults]
                                    registerDefaults:userDefaultsValuesDict];
}


@end


