/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad game view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad game view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SliderButtonControl.h"
#import "SpitWadAppViewController.h"
#import "SpitWadFieldSprite.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Spit wad game view controller class definition.
 *
 * Properties:
 *
 *   fieldContainerView         View that contains the playing field.
 *   shootButton                Button used for shooting.
 *   moveShootButton            Button used for moving and shooting.
 *   gameOverView               View displayed when the game is over.
 *   playAgainButton            Button used to play again.
 *   quitButton                 Button used to quit.
 *   highScoreView              View displayed when a new high score is
 *                              achieved.
 *   highScoreNameTextField     Text field for entering high score name.
 *
 ******************************************************************************/

@interface SpitWadGameViewController : SpitWadAppViewController
                                        <SpitWadFieldSpriteNotificationDelegate,
                                         SliderButtonControlDelegate,
                                         UITextFieldDelegate,
                                         UIAccelerometerDelegate>
{
    /*
     * mFieldContainerView      View that contains the playing field.
     * mShootButton             Button used for shooting.
     * mMoveShootButton         Button used for moving and shooting.
     * mGameOverView            View displayed when the game is over.
     * mPlayAgainButton         Button used to play again.
     * mQuitButton              Button used to quit.
     * mHighScoreView           View displayed when a new high score is
     *                          achieved.
     * mHighScoreNameTextField  Text field for entering high score name.
     *
     * mSpitWadFieldSprite      Game playing field sprite.
     * mNewHighScoreIndex       Index in high scores list of new high score.
     */

    UIView*                     mFieldContainerView;
    UIButton*                   mShootButton;
    SliderButtonControl*        mMoveShootButton;
    UIView*                     mGameOverView;
    UIButton*                   mPlayAgainButton;
    UIButton*                   mQuitButton;
    UIView*                     mHighScoreView;
    UITextField*                mHighScoreNameTextField;

    SpitWadFieldSprite*         mSpitWadFieldSprite;
    NSInteger                   mNewHighScoreIndex;
}


/* Properties. */
@property(retain) IBOutlet UIView*              fieldContainerView;
@property(retain) IBOutlet UIButton*            shootButton;
@property(retain) IBOutlet SliderButtonControl* moveShootButton;
@property(retain) IBOutlet UIView*              gameOverView;
@property(retain) IBOutlet UIButton*            playAgainButton;
@property(retain) IBOutlet UIButton*            quitButton;
@property(retain) IBOutlet UIView*              highScoreView;
@property(retain) IBOutlet UITextField*         highScoreNameTextField;


/* Spit wad game view controller action handlers. */
- (IBAction)handleStartShootingAction:(id) aSender;

- (IBAction)handleStopShootingAction:(id) aSender;

- (IBAction)handlePlayAgainAction:(id) aSender;

- (IBAction)handleQuitAction:(id) aSender;


/* Spit wad game view controller high score services. */
- (void)updateHighScores;

- (void)updateNewHighScoreName;


/* Spit wad game view controller player controls services. */
- (void)initializePlayerControls;

- (void)finalizePlayerControls;

- (void)initializeAccelerometerControl;

- (void)finalizeAccelerometerControl;

- (void)initializeSliderControl;

- (void)finalizeSliderControl;


/* Internal spit wad game view controller services. */
- (void)startGame;

- (void)endGame;


@end


