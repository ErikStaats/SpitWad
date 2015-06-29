/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the spit wad options view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Spit wad options view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "SpitWadAppViewController.h"


/* *****************************************************************************
 *
 * Spit wad options controller class definition.
 *
 * Properties:
 *
 *   playerControlTypeLabel     Player control type label.
 *   playerControlLeftButton    Player control left button.
 *   playerControlRightButton   Player control right button.
 *
 ******************************************************************************/

@interface SpitWadOptionsViewController : SpitWadAppViewController
{
    /*
     * mPlayerControlTypeLabel  Player control type label.
     * mPlayerControlLeftButton Player control left button.
     * mPlayerControlRightButton
     *                          Player control right button.
     *
     * mPlayerControlType       Player control type.
     */

    UILabel*                    mPlayerControlTypeLabel;
    UIButton*                   mPlayerControlLeftButton;
    UIButton*                   mPlayerControlRightButton;

    NSString*                   mPlayerControlType;
}


/* Properties. */
@property(retain) IBOutlet UILabel*     playerControlTypeLabel;
@property(retain) IBOutlet UIButton*    playerControlLeftButton;
@property(retain) IBOutlet UIButton*    playerControlRightButton;


/* Spit wad options view controller action handlers. */
- (IBAction)handleDoneAction:(id) aSender;

- (IBAction)handleLeftPlayerControlTypeAction:(id) aSender;

- (IBAction)handleRightPlayerControlTypeAction:(id) aSender;


/* Internal spit wad options view controller services. */
- (void)update;

- (void)readPrefs;

- (void)writePrefs;


@end


