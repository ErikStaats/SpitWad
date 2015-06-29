/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad title view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad title view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpitWadAppViewController.h"


/* *****************************************************************************
 *
 * Spit wad title view controller class definition.
 *
 * Properties:
 *
 *   startGameButton            Button used to start the game.
 *   optionsButton              Button used to show options.
 *   highScoresButton           Button used to show high scores.
 *
 ******************************************************************************/

@interface SpitWadTitleViewController : SpitWadAppViewController
{
    /*
     * mStartGameButton         Button used to start the game.
     * mOptionsButton           Button used to show options.
     * mHighScoresButton        Button used to show high scores.
     */

    UIButton*                   mStartGameButton;
    UIButton*                   mOptionsButton;
    UIButton*                   mHighScoresButton;
}

@property(retain) IBOutlet UIButton*    startGameButton;
@property(retain) IBOutlet UIButton*    optionsButton;
@property(retain) IBOutlet UIButton*    highScoresButton;

/* Internal spit wad title view controller services. */
- (IBAction)handleStartGameAction:(id) aSender;

- (IBAction)handleOptionsAction:(id) aSender;

- (IBAction)handleHighScoresAction:(id) aSender;


@end


