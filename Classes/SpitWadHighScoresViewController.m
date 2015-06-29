/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the spit wad high scores view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad high scores view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpitWadHighScoresViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Spit wad high scores view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpitWadHighScoresViewController

/* Synthesize properties. */
@synthesize scoreValue1Label = mScoreValue1Label;
@synthesize scoreName1Label = mScoreName1Label;
@synthesize scoreValue2Label = mScoreValue2Label;
@synthesize scoreName2Label = mScoreName2Label;
@synthesize scoreValue3Label = mScoreValue3Label;
@synthesize scoreName3Label = mScoreName3Label;
@synthesize scoreValue4Label = mScoreValue4Label;
@synthesize scoreName4Label = mScoreName4Label;
@synthesize scoreValue5Label = mScoreValue5Label;
@synthesize scoreName5Label = mScoreName5Label;
@synthesize doneButton = mDoneButton;


/* *****************************************************************************
 *
 * Spit wad high scores view controller NSObject implementation.
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
    /* Collect the high score name labels into an array. */
    NSMutableArray* highScoreNameLabelList =
                                        [NSMutableArray arrayWithCapacity:0];
    [highScoreNameLabelList addObject:mScoreName1Label];
    [highScoreNameLabelList addObject:mScoreName2Label];
    [highScoreNameLabelList addObject:mScoreName3Label];
    [highScoreNameLabelList addObject:mScoreName4Label];
    [highScoreNameLabelList addObject:mScoreName5Label];

    /* Collect the high score value labels into an array. */
    NSMutableArray* highScoreValueLabelList =
                                        [NSMutableArray arrayWithCapacity:0];
    [highScoreValueLabelList addObject:mScoreValue1Label];
    [highScoreValueLabelList addObject:mScoreValue2Label];
    [highScoreValueLabelList addObject:mScoreValue3Label];
    [highScoreValueLabelList addObject:mScoreValue4Label];
    [highScoreValueLabelList addObject:mScoreValue5Label];

    /* Set the high score labels. */
    NSArray* highScoresList = [[NSUserDefaults standardUserDefaults]
                                                    arrayForKey:@"high_scores"];
    for (NSUInteger i = 0;
         (   (i < highScoresList.count)
          && (i < highScoreNameLabelList.count)
          && (i < highScoreValueLabelList.count));
         i++)
    {
        /* Get the high score info. */
        NSArray* highScoreInfo = [highScoresList objectAtIndex:i];
        NSString* highScoreName = [highScoreInfo objectAtIndex:0];
        int highScoreValue = [[highScoreInfo objectAtIndex:1] intValue];

        /* Get the high score labels. */
        UILabel* nameLabel = [highScoreNameLabelList objectAtIndex:i];
        UILabel* valueLabel = [highScoreValueLabelList objectAtIndex:i];

        /* Set the high score labels. */
        nameLabel.text = highScoreName;
        valueLabel.text = [NSString stringWithFormat:@"%d", highScoreValue];
    }
}


/* *****************************************************************************
 *
 * Spit wad high scores view controller action handlers.
 *
 ******************************************************************************/

/*
 * handleDoneAction
 *
 *   ==> aSender                Sender of done action.
 *
 *   This function handles the done action from the sender specified by aSender.
 */

- (void)handleDoneAction:(id) aSender
{
    /* Unload self from the parent application view controller. */
    [self.parentAppViewController unload];
}


@end


