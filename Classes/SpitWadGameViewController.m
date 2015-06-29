/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad game view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad game view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadGameViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad game view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadGameViewController

/*
 * Spit wad game view class configuration.
 *
 *   MOVE_ACCELEROMETER_THRESHOLD   Accelerometer acceleration threshold for
 *                                  moving.
 */

#define MOVE_ACCELEROMETER_THRESHOLD    0.05


/* Synthesize properties. */
@synthesize fieldContainerView = mFieldContainerView;
@synthesize shootButton = mShootButton;
@synthesize moveShootButton = mMoveShootButton;
@synthesize gameOverView = mGameOverView;
@synthesize playAgainButton = mPlayAgainButton;
@synthesize quitButton = mQuitButton;
@synthesize highScoreView = mHighScoreView;
@synthesize highScoreNameTextField = mHighScoreNameTextField;


/* *****************************************************************************
 *
 * Spit wad game view controller NSObject implementation.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Ensure the game is ended. */
    [self endGame];

    /* Release objects. */
    [mFieldContainerView release];
    [mShootButton release];
    [mMoveShootButton release];
    [mGameOverView release];
    [mPlayAgainButton release];
    [mQuitButton release];
    [mHighScoreView release];
    [mHighScoreNameTextField release];
    [mSpitWadFieldSprite release];

    /* Call the super-class dealloc. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Spit wad game view controller UIViewController services.
 *
 ******************************************************************************/

/*
 * viewDidLoad
 *
 *   Invoked when the view is finished loading.
 */

- (void)viewDidLoad
{
    /* Start a game. */
    [self startGame];
}


/* *****************************************************************************
 *
 *   Spit wad game view controller SpitWadFieldSpriteNotificationDelegate
 * services.
 *
 ******************************************************************************/

/*
 * gameEnded
 *
 *   The game has ended.
 */

- (void)gameEnded
{
    /* Update the high scores. */
    [self updateHighScores];

    /* Show game over view. */
    mGameOverView.hidden = NO;
}


/* *****************************************************************************
 *
 * Spit wad game view controller SliderButtonControlDelegate services.
 *
 ******************************************************************************/

/*
 * sliderButtonControlChanged
 *
 *   ==> aSliderButtonControl   Slider button control that changed.
 *
 *   This method is called when the slider button control specified by
 * aSliderButtonControl has changed.
 */

- (void) sliderButtonControlChanged:(SliderButtonControl*) aSliderButtonControl
{
    /* Send actions to the spit wad field sprite. */
    if (mMoveShootButton.isButtonDown)
    {
        [mSpitWadFieldSprite handleMoveToAction:self
                             moveToXFactor:mMoveShootButton.sliderXFactor
                             moveToYFactor:mMoveShootButton.sliderYFactor];
        [mSpitWadFieldSprite handleShootStartAction:self];
    }
    else
    {
        [mSpitWadFieldSprite handleShootStopAction:self];
    }
}


/* *****************************************************************************
 *
 * Spit wad field sprite UITextFieldDelegate services.
 *
 ******************************************************************************/

/*
 * textFieldShouldReturn
 *
 *   ==> aTextField             The text field whose return button was pressed.
 *
 *   <==                        The text field should implement its default
 *                              behavior for the return button.
 *
 *   Asks the delegate if the text field should process the pressing of the
 * return button.
 */

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    /* Handle new high score name text field return button. */
    if (aTextField == mHighScoreNameTextField)
    {
        /* Remove focus from the new high score name field. */
        [mHighScoreNameTextField resignFirstResponder];
    }

    /* Perform any default actions. */
    return YES;
}


/*
 * textFieldDidEndEditing
 *
 *   ==> aTextField             The text field for which editing ended.
 *
 *   Tells the delegate that editing stopped for the specified text field.
 */

- (void)textFieldDidEndEditing:(UITextField *)aTextField
{
    /* Handle new high score name text field completion. */
    if (aTextField == mHighScoreNameTextField)
    {
        /* Update the new high score name. */
        [self updateNewHighScoreName];
    }
}


/* *****************************************************************************
 *
 * Spit wad game view controller UIAccelerometerDelegate services.
 *
 ******************************************************************************/

/*
 * accelerometer:didAccelerate:
 *
 *   ==> aAccelerometer         The application-wide accelerometer object.
 *   ==> aAcceleration          The most recent acceleration data.
 *
 *   Delivers the latest acceleration data to the delegate.
 */

- (void)accelerometer:(UIAccelerometer *)   aAccelerometer
        didAccelerate:(UIAcceleration *)    aAcceleration
{
    /* Set the player velocity. */
    if (aAcceleration.x > MOVE_ACCELEROMETER_THRESHOLD)
    {
        [mSpitWadFieldSprite handleMoveAction:self
                             moveSpeedXFactor:1.0
                             moveSpeedYFactor:0.0];
    }
    else if (aAcceleration.x < -MOVE_ACCELEROMETER_THRESHOLD)
    {
        [mSpitWadFieldSprite handleMoveAction:self
                             moveSpeedXFactor:-1.0
                             moveSpeedYFactor:0.0];
    }
    else
    {
        [mSpitWadFieldSprite handleMoveAction:self
                             moveSpeedXFactor:0.0
                             moveSpeedYFactor:0.0];
    }
}


/* *****************************************************************************
 *
 * Spit wad game view controller action handlers.
 *
 ******************************************************************************/

/*
 * handleStartShootingAction
 *
 *   ==> aSender                Sender of start shooting action.
 *
 *   This function handles the start shooting action from the sender specified
 * by aSender.
 */

- (void)handleStartShootingAction:(id) aSender
{
    /* Send a start shooting action to the spit wad field sprite. */
    [mSpitWadFieldSprite handleShootStartAction:self];
}


/*
 * handleStopShootingAction
 *
 *   ==> aSender                Sender of stop shooting action.
 *
 *   This function handles the stop shooting action from the sender specified by
 * aSender.
 */

- (void)handleStopShootingAction:(id) aSender
{
    /* Send a stop shooting action to the spit wad field sprite. */
    [mSpitWadFieldSprite handleShootStopAction:self];
}


/*
 * handlePlayAgainAction
 *
 *   ==> aSender                Sender of play again action.
 *
 *   This function handles the play again action from the sender specified by
 * aSender.
 */

- (void)handlePlayAgainAction:(id) aSender
{
    /* Restart game. */
    [self endGame];
    [self startGame];
}


/*
 * handleQuitAction
 *
 *   ==> aSender                Sender of quit action.
 *
 *   This function handles the quit action from the sender specified by aSender.
 */

- (void)handleQuitAction:(id) aSender
{
    /* End the game. */
    [self endGame];

    /* Unload self from the parent application view controller. */
    [self.parentAppViewController unload];
}


/* *****************************************************************************
 *
 * Spit wad game view controller high score services.
 *
 ******************************************************************************/

/*
 * updateHighScores
 *
 *   This function checks if a new high score has been achieved and updates the
 * high score list if so.  In addition, it presents the new high score UI.
 */

- (void)updateHighScores
{
    /* Get the list of high scores. */
    NSArray* highScoresList = [[NSUserDefaults standardUserDefaults]
                                                    arrayForKey:@"high_scores"];

    /* Check if current game score is a new high score. */
    for (NSUInteger i = 0; i < highScoresList.count; i++)
    {
        /* Get the next high score info. */
        NSArray* highScoreInfo = [highScoresList objectAtIndex:i];
        int highScoreValue = [[highScoreInfo objectAtIndex:1] intValue];

        /* Check for a new high score. */
        if (mSpitWadFieldSprite.score > highScoreValue)
        {
            mNewHighScoreIndex = i;
            break;
        }
    }

    /* If there's a new high score, update the list of high scores. */
    if (mNewHighScoreIndex >= 0)
    {
        /* Make a mutable copy of the high score list. */
        NSMutableArray* newHighScoresList =
                                [NSMutableArray arrayWithArray:highScoresList];

        /* Create a high score list entry. */
        NSMutableArray* newHighScoreInfo = [NSMutableArray arrayWithCapacity:2];
        [newHighScoreInfo addObject:@""];
        [newHighScoreInfo addObject:[NSString stringWithFormat:@"%d",
                                              mSpitWadFieldSprite.score]];

        /* Add the new high score to the list. */
        [newHighScoresList insertObject:newHighScoreInfo
                           atIndex:mNewHighScoreIndex];

        /* Limit the list of high score to 5 entries. */
        while (newHighScoresList.count > 5)
            [newHighScoresList removeLastObject];

        /* Save the new high score list. */
        [[NSUserDefaults standardUserDefaults] setObject:newHighScoresList
                                               forKey:@"high_scores"];
    }

    /* If there's a new high score, present    */
    /* the high score UI.  Otherwise, hide it. */
    if (mNewHighScoreIndex >= 0)
    {
        /* Show the new high score view. */
        mHighScoreView.hidden = NO;

        /* Move focus to new high score name text field. */
        [mHighScoreNameTextField becomeFirstResponder];
    }
    else
    {
        mHighScoreView.hidden = YES;
    }
}


/*
 * updateNewHighScoreName
 *
 *   This function updates the new high score name.
 */

- (void)updateNewHighScoreName
{
    /* Get a mutable new high scores list from the current high scores list. */
    NSArray* highScoresList = [[NSUserDefaults standardUserDefaults]
                                                    arrayForKey:@"high_scores"];
    NSMutableArray* newHighScoresList =
                                [NSMutableArray arrayWithArray:highScoresList];

    /* Get the new high score info as a mutable array. */
    NSMutableArray* newHighScoreInfo =
        [NSMutableArray arrayWithArray:
                            [highScoresList objectAtIndex:mNewHighScoreIndex]];

    /* Set the new high score name. */
    [newHighScoreInfo replaceObjectAtIndex:0
                      withObject:mHighScoreNameTextField.text];
    [newHighScoresList replaceObjectAtIndex:mNewHighScoreIndex
                       withObject:newHighScoreInfo];

    /* Save the new high score list. */
    [[NSUserDefaults standardUserDefaults] setObject:newHighScoresList
                                           forKey:@"high_scores"];
}


/* *****************************************************************************
 *
 * Spit wad game view controller player controls services.
 *
 ******************************************************************************/

/*
 * initializePlayerControls
 *
 *   This function initializes the player controls.
 */

- (void)initializePlayerControls
{
    /* Get the player control type. */
    NSString* controlType = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"player_control_type"];

    /* Initialize the player control. */
    if ([controlType isEqual:@"Slider"])
        [self initializeSliderControl];
    else
        [self initializeAccelerometerControl];
}


/*
 * finalizePlayerControls
 *
 *   This function finalizes the player controls.
 */

- (void)finalizePlayerControls
{
    /* Finalize player controls. */
    [self finalizeAccelerometerControl];
    [self finalizeSliderControl];
}


/*
 * initializeAccelerometerControl
 *
 *   This function initializes the accelerometer control.
 */

- (void)initializeAccelerometerControl
{
    /* Set self as accelerometer delegate. */
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}


/*
 * finalizeAccelerometerControl
 *
 *   This function finalizes the accelerometer control.
 */

- (void)finalizeAccelerometerControl
{
    /* Remove self as accelerometer delegate. */
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    if (accelerometer.delegate == self)
        accelerometer.delegate = nil;
}


/*
 * initializeSliderControl
 *
 *   This function initializes the slider control.
 */

- (void)initializeSliderControl
{
    /* Show move/shoot slider control. */
    mMoveShootButton.hidden = NO;
}


/*
 * finalizeSliderControl
 *
 *   This function finalizes the slider control.
 */

- (void)finalizeSliderControl
{
    /* Hide move/shoot slider control. */
    mMoveShootButton.hidden = YES;
}


/* *****************************************************************************
 *
 * Internal spit wad game view controller services.
 *
 ******************************************************************************/

/*
 * startGame
 *
 *   This function starts a game.
 */

- (void)startGame
{
    /* Remove focus from the new high score name field. */
    [mHighScoreNameTextField resignFirstResponder];

    /* Hide game over view. */
    mGameOverView.hidden = YES;

    /* Initialize the new high score index. */
    mNewHighScoreIndex = -1;

    /* Create and initialize the spit wad field       */
    /* sprite and add it to the field container view. */
    mSpitWadFieldSprite = [[SpitWadFieldSprite alloc] init];
    [mFieldContainerView addSubview:mSpitWadFieldSprite.view];

    /* Add self as the field notification delegate. */
    mSpitWadFieldSprite.fieldNotificationDelegate = self;

    /* Initialize the player controls. */
    [self initializePlayerControls];

    /* Set self as move shoot button delegate. */
    mMoveShootButton.sliderButtonControlDelegate = self;

    /* Start the spit wad field sprite. */
    [mSpitWadFieldSprite start];
}


/*
 * endGame
 *
 *   This function ends a game.
 */

- (void)endGame
{
    /* Do nothing if no game started. */
    if (!mSpitWadFieldSprite)
        return;

    /* Remove focus from the new high score name field. */
    [mHighScoreNameTextField resignFirstResponder];

    /* Finalize player controls. */
    [self finalizePlayerControls];

    /* Remove self as the field notification delegate. */
    mSpitWadFieldSprite.fieldNotificationDelegate = nil;

    /* Remove spit wad field sprite view and release the sprite. */
    [mSpitWadFieldSprite.view removeFromSuperview];
    [mSpitWadFieldSprite release];
    mSpitWadFieldSprite = nil;
}


@end

