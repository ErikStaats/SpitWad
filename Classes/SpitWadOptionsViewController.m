/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad options view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad options view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadOptionsViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad options view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadOptionsViewController

/* Synthesize properties. */
@synthesize playerControlTypeLabel = mPlayerControlTypeLabel;
@synthesize playerControlLeftButton = mPlayerControlLeftButton;
@synthesize playerControlRightButton = mPlayerControlRightButton;


/* *****************************************************************************
 *
 * Spit wad options view controller NSObject implementation.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Call the super-class dealloc. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Spit wad high scores view controller UIViewController services.
 *
 ******************************************************************************/

/*
 * viewDidLoad
 *
 *   Invoked when the view is finished loading.
 */

- (void)viewDidLoad
{
    /* Read the preferences. */
    [self readPrefs];

    /* Update UI. */
    [self update];
}


/* *****************************************************************************
 *
 * Spit wad options view controller action handlers.
 *
 ******************************************************************************/

/*
 * handleLeftPlayerControlTypeAction
 *
 *   ==> aSender                Sender of left player control type action.
 *
 *   This function handles the left player control type action from the sender
 * specified by aSender.
 */

- (void)handleLeftPlayerControlTypeAction:(id) aSender
{
    /* Change the player control type. */
    if ([mPlayerControlType isEqual:@"Slider"])
        mPlayerControlType = @"Accelerometer";

    /* Update the UI. */
    [self update];
}


/*
 * handleRightPlayerControlTypeAction
 *
 *   ==> aSender                Sender of right player control type action.
 *
 *   This function handles the right player control type action from the sender
 * specified by aSender.
 */

- (void)handleRightPlayerControlTypeAction:(id) aSender
{
    /* Change the player control type. */
    if ([mPlayerControlType isEqual:@"Accelerometer"])
        mPlayerControlType = @"Slider";

    /* Update the UI. */
    [self update];
}


/*
 * handleDoneAction
 *
 *   ==> aSender                Sender of done action.
 *
 *   This function handles the done action from the sender specified by aSender.
 */

- (void)handleDoneAction:(id) aSender
{
    /* Write the preferences. */
    [self writePrefs];

    /* Unload self from the parent application view controller. */
    [self.parentAppViewController unload];
}


/* *****************************************************************************
 *
 * Internal spit wad options view controller services.
 *
 ******************************************************************************/

/*
 * update
 *
 *   This function updates the UI.
 */

- (void)update
{
    /* Set the player control type label. */
    if ([mPlayerControlType isEqual:@"Slider"])
        mPlayerControlTypeLabel.text = @"Slider";
    else
        mPlayerControlTypeLabel.text = @"Accelerometer";

    /* Set enabled state of player control buttons. */
    if ([mPlayerControlType isEqual:@"Accelerometer"])
        mPlayerControlLeftButton.enabled = NO;
    else
        mPlayerControlLeftButton.enabled = YES;
    if ([mPlayerControlType isEqual:@"Slider"])
        mPlayerControlRightButton.enabled = NO;
    else
        mPlayerControlRightButton.enabled = YES;
}


/*
 * readPrefs
 *
 *   This function reads the preferences.
 */

- (void)readPrefs
{
    /* Read the player control type and ensure it's set to a valid value. */
    mPlayerControlType = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"player_control_type"];
    if (![mPlayerControlType isEqual:@"Slider"])
        mPlayerControlType = @"Accelerometer";
}


/*
 * writePrefs
 *
 *   This function writes the preferences.
 */

- (void)writePrefs
{
    /* Write the player control type. */
    [[NSUserDefaults standardUserDefaults] setObject:mPlayerControlType
                                           forKey:@"player_control_type"];
}


@end


