/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad high scores view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad high scores view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpitWadAppViewController.h"


/* *****************************************************************************
 *
 * Spit wad high scores controller class definition.
 *
 * Properties:
 *
 *   scoreValue1Label           High score 1 value label.
 *   scoreName1Label            High score 1 name label.
 *   scoreValue2Label           High score 2 value label.
 *   scoreName2Label            High score 2 name label.
 *   scoreValue3Label           High score 3 value label.
 *   scoreName3Label            High score 3 name label.
 *   scoreValue4Label           High score 4 value label.
 *   scoreName4Label            High score 4 name label.
 *   scoreValue5Label           High score 5 value label.
 *   scoreName5Label            High score 5 name label.
 *   doneButton                 Done button.
 *
 ******************************************************************************/

@interface SpitWadHighScoresViewController : SpitWadAppViewController
{
    /*
     * mScoreValue1Label        High score 1 value label.
     * mScoreName1Label         High score 1 name label.
     * mScoreValue2Label        High score 2 value label.
     * mScoreName2Label         High score 2 name label.
     * mScoreValue3Label        High score 3 value label.
     * mScoreName3Label         High score 3 name label.
     * mScoreValue4Label        High score 4 value label.
     * mScoreName4Label         High score 4 name label.
     * mScoreValue5Label        High score 5 value label.
     * mScoreName5Label         High score 5 name label.
     * mDoneButton              Done button.
     */

    UILabel*                    mScoreValue1Label;
    UILabel*                    mScoreName1Label;
    UILabel*                    mScoreValue2Label;
    UILabel*                    mScoreName2Label;
    UILabel*                    mScoreValue3Label;
    UILabel*                    mScoreName3Label;
    UILabel*                    mScoreValue4Label;
    UILabel*                    mScoreName4Label;
    UILabel*                    mScoreValue5Label;
    UILabel*                    mScoreName5Label;
    UIButton*                   mDoneButton;
}


/* Properties. */
@property(retain) IBOutlet UILabel*     scoreValue1Label;
@property(retain) IBOutlet UILabel*     scoreName1Label;
@property(retain) IBOutlet UILabel*     scoreValue2Label;
@property(retain) IBOutlet UILabel*     scoreName2Label;
@property(retain) IBOutlet UILabel*     scoreValue3Label;
@property(retain) IBOutlet UILabel*     scoreName3Label;
@property(retain) IBOutlet UILabel*     scoreValue4Label;
@property(retain) IBOutlet UILabel*     scoreName4Label;
@property(retain) IBOutlet UILabel*     scoreValue5Label;
@property(retain) IBOutlet UILabel*     scoreName5Label;
@property(retain) IBOutlet UIButton*    doneButton;


/* Spit wad high scores view controller action handlers. */
- (IBAction)handleDoneAction:(id) aSender;


@end


