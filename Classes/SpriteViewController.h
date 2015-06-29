/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the sprite view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Sprite view controller imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "Vector.h"
#import "WeakReferenceProxy.h"

/* Cocoa imports. */
#import <UIKit/UIKit.h>


/* *****************************************************************************
 *
 * Sprite notification delegate protocol definition.
 *
 ******************************************************************************/

@class SpriteViewController;

@protocol SpriteNotificationDelegate

/* Mark all methods as optional. */
@optional

/*
 * spriteAdded
 *
 *   ==> aSprite                Sprite that has been added.
 *
 *   This notification is sent when the sprite specified by aSprite has been
 * added as a child of another sprite.
 */

- (void)spriteAdded:(SpriteViewController*) aSprite;


/*
 * beforeSpriteRemoved
 *
 *   ==> aSprite                Sprite that is about to be removed.
 *
 *   This notification is sent before the sprite specified by aSprite is removed
 * as a child of another sprite.
 */

- (void)beforeSpriteRemoved:(SpriteViewController*) aSprite;


/*
 * scoreTallied
 *
 *   ==> aSprite                Sprite for which score was tallied.
 *   ==> aScore                 Tallied score.
 *
 *   This notification is sent when the score specified by aScore has been
 * tallied for the sprite specified by aSprite.
 */

- (void)scoreTallied:(SpriteViewController*) aSprite
        score:(NSInteger)                    aScore;

@end


/* *****************************************************************************
 *
 * Sprite view controller class definition.
 *
 * Properties.
 *
 *   parentSprite               Parent sprite.
 *   spriteView                 Sprite's view.
 *   childSpritesView           View in which to place child sprites.  If not
 *                              specified, child sprites are placed in the
 *                              sprite view.
 *   acceleration               Sprite acceleration.
 *   velocityX                  X and y velocity.
 *   velocityY
 *   speed                      Sprite speed.
 *   targetList                 List of sprite targets.
 *   targetSpeed                Sprite target speed.
 *   removeAfterLastTarget      If YES, remove sprite after reaching the last
 *                              target.
 *   cantLeaveView              If YES, sprite cannot leave its parent's view.
 *   spriteRunning              If YES, sprite is running (but may be paused).
 *   spritePaused               If YES, sprite is paused.
 *
 * Internal fields.
 *
 *   mParentSprite              Parent sprite.
 *   mSpriteView                Sprite's view.
 *   mChildSpritesView          View in which to place child sprites.
 *   mAcceleration              Sprite acceleration.
 *   mVelocityX                 X and y velocity.
 *   mVelocityY
 *   mTargetList                List of sprite targets.
 *   mTargetSpeed               Sprite target speed.
 *   mRemoveAfterLastTarget     If YES, remove sprite after reaching the last
 *                              target.
 *   mCantLeaveView             If YES, sprite cannot leave its parent's view.
 *   mSpriteRunning             If YES, sprite is running (but may be paused).
 *   mSpritePaused              If YES, sprite is paused.
 *
 *   mSelfProxy                 Weak reference proxy to self.
 *   mChildSpriteSet            Set of child sprites.
 *   mStepTimer                 Sprite stepping timer.
 *   mNotificationDelegate      Delegate for receiving sprite notifications.
 *   mSpriteStepTime            Current step time in sprite time.
 *   mSystemStepTime            Current step time in system time.
 *   mPrevStepTime              Time of previous step.
 *
 ******************************************************************************/

@class SpriteView;

@interface SpriteViewController : UIViewController <SpriteNotificationDelegate>
{
    SpriteViewController*       mParentSprite;
    UIView*                     mSpriteView;
    UIView*                     mChildSpritesView;
    float                       mAcceleration;
    float                       mVelocityX;
    float                       mVelocityY;
    NSMutableArray*             mTargetList;
    float                       mTargetSpeed;
    BOOL                        mRemoveAfterLastTarget;
    BOOL                        mCantLeaveView;
    BOOL                        mSpriteRunning;
    BOOL                        mSpritePaused;

    WeakReferenceProxy*         mSelfProxy;
    NSMutableSet*               mChildSpriteSet;
    NSTimer*                    mStepTimer;
    id                          mNotificationDelegate;
    NSTimeInterval              mSpriteStepTime;
    NSTimeInterval              mSystemStepTime;
    NSTimeInterval              mPrevStepTime;
}

/* Properties. */
@property(assign) SpriteViewController* parentSprite;
@property(nonatomic, retain) UIView*    spriteView;
@property(nonatomic, retain) UIView*    childSpritesView;
@property(assign) float                 acceleration;
@property(assign) float                 velocityX;
@property(assign) float                 velocityY;
@property(assign) float                 speed;
@property(retain) NSArray*              targetList;
@property(assign) float                 targetSpeed;
@property(assign) BOOL                  removeAfterLastTarget;
@property(assign) BOOL                  cantLeaveView;
@property(assign) BOOL                  spriteRunning;
@property(assign) BOOL                  spritePaused;


/* Methods. */
- (void)start;

- (void)stop;

- (void)addChild:(SpriteViewController*) aSprite;

- (void)removeChild:(SpriteViewController*) aSprite;

- (void)removeAllChildren;

- (void)addTarget:(CGPoint) aTargetPosition;

- (void)setTarget:(CGPoint) aPosition
    speed:(float)           aSpeed;

- (void)clearTarget;

- (void)step:(NSTimeInterval) aStepTime;

- (void)hit:(SpriteViewController*) aSpriteViewController
    damage:(float)                  aDamage;

- (void)tallyScore:(NSInteger)aScore;

- (void)addNotificationDelegate:
    (id<SpriteNotificationDelegate>) aNotificationDelegate;

- (void)removeNotificationDelegate:
    (id<SpriteNotificationDelegate>) aNotificationDelegate;

- (NSArray*)getCollisionList:(SpriteViewController*) aSprite;

- (BOOL)leftView:(SpriteViewController*) aSprite;

- (void)pauseSprite;

- (void)resumeSprite;


/* Internal methods. */
- (void)spriteViewControllerInit;

- (void)stepSprites:(NSTimer*) aTimer;

- (void)updateStepTimer;

- (void)stepTarget:(NSTimeInterval) aStepTimeInterval;

- (void)stepVelocity:(NSTimeInterval) aStepTimeInterval;

- (Vector)getTargetAccelerationVector;

- (float)getTargetDist;


/* Class methods. */
+ (BOOL)doesIntersect:(SpriteViewController*) aSprite1
    sprite2:(SpriteViewController*)           aSprite2;

+ (BOOL)doesIntersect:(UIView*) aView1
    view2:(UIView*)             aView2;

+ (BOOL)doesIntersect:(CGRect) aRect1
    rect2:(CGRect)             aRect2;

@end


/* *****************************************************************************
 *
 * Sprite target class definition.
 *
 * Properties.
 *
 *   target                     Sprite target position.
 *
 ******************************************************************************/

@interface SpriteTarget: NSObject
{
    /*
     * mTarget                  Sprite target position.
     */

    CGPoint                     mTarget;
}


/* Properties. */
@property(assign) CGPoint target;


/* Sprite target services. */
+ (id)target:(CGPoint) aTarget;

- (id)initWithTarget:(CGPoint) aTarget;

@end


