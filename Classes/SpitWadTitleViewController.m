/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad title view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad title view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadTitleViewController.h"

/* Local imports. */
#import "SpitWadGameViewController.h"
#import "SpitWadHighScoresViewController.h"
#import "SpitWadOptionsViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad title view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadTitleViewController

/* Synthesize properties. */
@synthesize startGameButton = mStartGameButton;
@synthesize optionsButton = mOptionsButton;
@synthesize highScoresButton = mHighScoresButton;


/* *****************************************************************************
 *
 * Spit wad title view controller NSObject implementation.
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
 * Spit wad title view controller action handlers.
 *
 ******************************************************************************/

/*
 * handleStartGameAction
 *
 *   ==> aSender                Sender of start game action.
 *
 *   This function handles the start game action from the sender specified by
 * aSender.
 */

- (void)handleStartGameAction:(id) aSender
{
    /* Load the game view. */
    SpitWadGameViewController* controller =
        [[SpitWadGameViewController alloc] initWithNibName:@"SpitWadGameView"
                                           bundle:[NSBundle mainBundle]];
    [self.parentAppViewController load:controller];

    /* Release objects. */
    [controller release];
}


/*
 * handleOptionsAction
 *
 *   ==> aSender                Sender of options action.
 *
 *   This function handles the options action from the sender specified by
 * aSender.
 */

- (void)handleOptionsAction:(id) aSender
{
    /* Load the high scores view. */
    SpitWadOptionsViewController* controller =
                                    [[SpitWadOptionsViewController alloc]
                                        initWithNibName:@"SpitWadOptionsView"
                                        bundle:[NSBundle mainBundle]];
    [self.parentAppViewController load:controller];

    /* Release objects. */
    [controller release];
}


/*
 * handleHighScoresAction
 *
 *   ==> aSender                Sender of high scores action.
 *
 *   This function handles the high scores action from the sender specified by
 * aSender.
 */

- (void)handleHighScoresAction:(id) aSender
{
    /* Load the high scores view. */
    SpitWadHighScoresViewController* controller =
                                    [[SpitWadHighScoresViewController alloc]
                                        initWithNibName:@"SpitWadHighScoresView"
                                        bundle:[NSBundle mainBundle]];
    [self.parentAppViewController load:controller];

    /* Release objects. */
    [controller release];
}


@end

