/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the sprite view controller.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Sprite view controller imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "SpriteViewController.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite view controller class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteViewController

/* Synthesize properties. */
@synthesize parentSprite = mParentSprite;
@synthesize spriteView = mSpriteView;
@synthesize childSpritesView = mChildSpritesView;
@synthesize acceleration = mAcceleration;
@synthesize velocityX = mVelocityX;
@synthesize velocityY = mVelocityY;
@dynamic speed;
@synthesize targetList = mTargetList;
@synthesize targetSpeed = mTargetSpeed;
@synthesize removeAfterLastTarget = mRemoveAfterLastTarget;
@synthesize cantLeaveView = mCantLeaveView;
@synthesize spriteRunning = mSpriteRunning;
@synthesize spritePaused = mSpritePaused;


/* *****************************************************************************
 *
 * Sprite view controller UIViewController services.
 *
 ******************************************************************************/

/*
 * initWithNibName
 *
 *   ==> aNibName               The name of the nib file, without any leading
 *                              path information.
 *   ==> aNibBundle             The bundle in which to search for the nib file.
 *
 *   Returns a newly initialized view controller with the nib file in the
 * specified bundle.
 */

- (id)initWithNibName:(NSString *)  aNibName
      bundle:(NSBundle *)           aNibBundle
{
    /* Invoke the super class. */
    self = [super initWithNibName:aNibName bundle:aNibBundle];
    if (!self)
        return nil;

    /* Initialize. */
    [self spriteViewControllerInit];

    return self;
}


/* *****************************************************************************
 *
 * Sprite view controller NSObject services.
 *
 ******************************************************************************/

/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Remove all child sprites. */
    [self removeAllChildren];

    /* Stop step timer. */
    if (mStepTimer)
    {
        [mStepTimer invalidate];
        [mStepTimer release];
        mStepTimer = nil;
    }

    /* Release objects. */
    [mSpriteView release];
    [mChildSpriteSet release];
    [mTargetList release];

    /* Release self proxy. */
    mSelfProxy.target = nil;
    [mSelfProxy release];

    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Sprite view controller properties.
 *
 ******************************************************************************/

/*
 * speed
 */

- (float)speed
{
    return sqrt(mVelocityX*mVelocityX + mVelocityY*mVelocityY);
}

- (void)setSpeed:(float) aSpeed
{
    float currentSpeed = self.speed;
    if (currentSpeed)
    {
        mVelocityX *= aSpeed / currentSpeed;
        mVelocityY *= aSpeed / currentSpeed;
    }
}


/* *****************************************************************************
 *
 * Sprite view controller services.
 *
 ******************************************************************************/

/*
 * start
 *
 *   This function starts running the sprite stepping.
 */

- (void)start
{
    /* Set the sprite running. */
    mSpriteRunning = YES;

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * stop
 *
 *   This function stops running the sprite stepping.
 */

- (void)stop
{
    /* Set the sprite not running. */
    mSpriteRunning = NO;

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * addChild
 *
 *   ==> aSprite                Child sprite to add.
 *
 *   This function adds the sprite specified by aSprite as a child sprite and
 * starts it.
 */

- (void)addChild:(SpriteViewController*) aSprite
{
    /* Remove sprite from any current parent. */
    if (aSprite.parentSprite)
        [aSprite.parentSprite removeChild:aSprite];

    /* Add sprite to child set. */
    [mChildSpriteSet addObject:aSprite];
    aSprite.parentSprite = self;

    /* Add child sprite to sprite view. */
    UIView* childSpritesView = mChildSpritesView;
    if (!childSpritesView)
        childSpritesView = mSpriteView;
    [childSpritesView addSubview:aSprite.spriteView];

    /* Notify delegates, including the added sprite. */
    if ([aSprite respondsToSelector:@selector(spriteAdded:)])
        [aSprite spriteAdded:aSprite];
    if (mNotificationDelegate)
    {
        if ([mNotificationDelegate respondsToSelector:@selector(spriteAdded:)])
            [mNotificationDelegate spriteAdded:aSprite];
    }

    /* Start child sprite. */
    [aSprite start];

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * removeChild
 *
 *   ==> aSprite                Child sprite to remove.
 *
 *   This function removes the sprite specified by aSprite as a child sprite and
 * stops it.
 */

- (void)removeChild:(SpriteViewController*) aSprite
{
    /* Stop child sprite. */
    [aSprite stop];

    /* Notify delegates, including the removed sprite. */
    if ([aSprite respondsToSelector:@selector(beforeSpriteRemoved:)])
        [aSprite beforeSpriteRemoved:aSprite];
    if (mNotificationDelegate)
    {
        if ([mNotificationDelegate
                            respondsToSelector:@selector(beforeSpriteRemoved:)])
        {
            [mNotificationDelegate beforeSpriteRemoved:aSprite];
        }
    }

    /* Remove child sprite from sprite view. */
    [aSprite.spriteView removeFromSuperview];

    /* Remove child sprite from child set. */
    aSprite.parentSprite = nil;
    [mChildSpriteSet removeObject:aSprite];

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * removeAllChildren
 *
 *   This function removes all child sprites.
 */

- (void)removeAllChildren
{
    /* Create an auto-release pool so all child sprites are released. */
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    /* Remove all child sprites. */
    NSArray* childSpriteList = [mChildSpriteSet allObjects];
    int childSpriteCount = childSpriteList.count;
    for (int i = 0; i < childSpriteCount; i++)
    {
        SpriteViewController* childSprite = [childSpriteList objectAtIndex:i];
        [self removeChild:childSprite];
    }

    /* Release the auto-release pool. */
    [pool release];
}


/*
 * addTarget
 *
 *   ==> aTargetPosition        Target position.
 *
 *   This function adds the target specified by aTargetPosition to the list of
 * sprite targets.
 */

- (void)addTarget:(CGPoint) aTargetPosition
{
    /* Add the target to the target list. */
    [mTargetList addObject:[SpriteTarget target:aTargetPosition]];
}


/*
 * setTarget
 *
 *   ==> aPosition              Target position.
 *   ==> aSpeed                 Target speed in pixels per second.
 *
 *   This function sets the sprite target to the position specified by
 * aPosition.  The sprite will move towards the target position with the speed
 * specified by aSpeed.
 */

- (void)setTarget:(CGPoint) aPosition
    speed:(float)           aSpeed
{
    /* Set the target list to the single target and set the target speed. */
    [mTargetList removeAllObjects];
    [mTargetList addObject:[SpriteTarget target:aPosition]];
    mTargetSpeed = aSpeed;
}


/*
 * clearTarget
 *
 *   This function clears the sprite target and stops sprite movement.
 */

- (void)clearTarget
{
    /* Clear the target list and set the velocity and acceleration to 0. */
    [mTargetList removeAllObjects];
    mVelocityX = 0.0;
    mVelocityY = 0.0;
    mAcceleration = 0.0;
}


/*
 * step
 *
 *   ==> aStepTime              Time of step.
 *
 *   This function steps the sprite to the time specified by aStepTime.
 */

- (void)step:(NSTimeInterval) aStepTime
{
    /* Initialize the previous step time. */
    /*zzz should be able to do this in init. */
    if (!mPrevStepTime)
        mPrevStepTime = aStepTime;

    /* Get the time interval since the previous step time. */
    NSTimeInterval stepTimeInterval = aStepTime - mPrevStepTime;

    /* Step the sprite target list if it's not      */
    /* empty.  Otherwise, step the sprite velocity. */
    if (mTargetList.count > 0)
        [self stepTarget:stepTimeInterval];
    else
        [self stepVelocity:stepTimeInterval];

    /* Get the sprite position. */
    CGPoint center = mSpriteView.center;

    /* Ensure sprite doesn't leave view if it's set not to. */
    if (mCantLeaveView)
    {
        /* Get the sprite and its parent's geometries. */
        CGRect spriteFrame = self.spriteView.frame;
        CGRect parentBounds = mParentSprite.spriteView.bounds;

        /* Limit minimum X position and velocity. */
        float spriteFrameMinX = CGRectGetMinX(spriteFrame);
        float parentBoundsMinX = CGRectGetMinX(parentBounds);
        if (spriteFrameMinX < parentBoundsMinX)
        {
            center.x = parentBoundsMinX + spriteFrame.size.width/2;
            mSpriteView.center = center;
            if (mVelocityX < 0.0)
                mVelocityX = 0.0;
        }

        /* Limit maximum X position and velocity. */
        float spriteFrameMaxX = CGRectGetMaxX(spriteFrame);
        float parentBoundsMaxX = CGRectGetMaxX(parentBounds);
        if (spriteFrameMaxX > parentBoundsMaxX)
        {
            center.x = parentBoundsMaxX - spriteFrame.size.width/2;
            mSpriteView.center = center;
            if (mVelocityX > 0.0)
                mVelocityX = 0.0;
        }

        /* Limit minimum Y position and velocity. */
        float spriteFrameMinY = CGRectGetMinY(spriteFrame);
        float parentBoundsMinY = CGRectGetMinY(parentBounds);
        if (spriteFrameMinY < parentBoundsMinY)
        {
            center.y = parentBoundsMinY + spriteFrame.size.height/2;
            mSpriteView.center = center;
            if (mVelocityY < 0.0)
                mVelocityY = 0.0;
        }

        /* Limit maximum Y position and velocity. */
        float spriteFrameMaxY = CGRectGetMaxY(spriteFrame);
        float parentBoundsMaxY = CGRectGetMaxY(parentBounds);
        if (spriteFrameMaxY > parentBoundsMaxY)
        {
            center.y = parentBoundsMaxY - spriteFrame.size.height/2;
            mSpriteView.center = center;
            if (mVelocityY > 0.0)
                mVelocityY = 0.0;
        }
    }

    /* Update the previous step time. */
    mPrevStepTime = aStepTime;
}


/*
 * hit
 *
 *   ==> aSpriteViewController  Sprite that hit.
 *   ==> aDamage                Sprite damage.
 *
 *   This function handles sprite hits by the sprite specified by
 * aSpriteViewController with the damage specified by aDamage.
 */

- (void)hit:(SpriteViewController*) aSpriteViewController
    damage:(float)                  aDamage
{
}


/*
 * tallyScore
 *
 *   ==> aScore                 Score to tally.
 *
 *   This function tallies the score specified by aScore for the sprite.  A
 * scoreTallied notification is sent for all notification delegates.
 */

- (void)tallyScore:(NSInteger)aScore
{
    /* Notify sprite and sprite delegates. */
    if ([self respondsToSelector:@selector(scoreTallied:score:)])
        [self scoreTallied:self score:aScore];
    if (mNotificationDelegate)
    {
        if ([mNotificationDelegate
                            respondsToSelector:@selector(scoreTallied:score:)])
        {
            [mNotificationDelegate scoreTallied:self score:aScore];
        }
    }

    /* Tally score for parent. */
    [mParentSprite tallyScore:aScore];
}


/*
 * addNotificationDelegate
 *
 *   ==> aNotificationDelegate  Notification delegate to add.
 *
 *   This function adds the delegate specified by aNotificationDelegate to the
 * list of sprite notification delegates.
 *zzz add support for more than one.
 */

- (void)addNotificationDelegate:
    (id<SpriteNotificationDelegate>) aNotificationDelegate
{
    mNotificationDelegate = aNotificationDelegate;
}


/*
 * removeNotificationDelegate
 *
 *   ==> aNotificationDelegate  Notification delegate to add.
 *
 *   This function removes the delegate specified by aNotificationDelegate from
 * the list of sprite notification delegates.
 *zzz add support for more than one.
 */

- (void)removeNotificationDelegate:
    (id<SpriteNotificationDelegate>) aNotificationDelegate
{
    mNotificationDelegate = nil;
}


/*
 * getCollisionList
 *
 *   ==> aSprite                Target child sprite.
 *
 *   <==                        List of child sprites with which the target
 *                              child sprite collides.
 *
 *   This function creates and returns a list of all child sprites that collide
 * with the target child sprite specified by aSprite.
 */

- (NSArray*)getCollisionList:(SpriteViewController*) aSprite
{
    /* Create an empty collision list. */
    NSMutableArray* collisionList = [[NSMutableArray alloc] initWithCapacity:0];

    /* Check each child sprite for a collision. */
    NSEnumerator* childSpriteEnum = [mChildSpriteSet objectEnumerator];
    SpriteViewController* childSprite;
    while (childSprite = [childSpriteEnum nextObject])
    {
        /* Skip target sprite. */
        if (childSprite == aSprite)
            continue;

        /* If the child sprite intersects the target */
        /* sprite, add it to the collision list.     */
        if ([SpriteViewController doesIntersect:aSprite sprite2:childSprite])
        {
            [collisionList addObject:childSprite];
        }

        /* Add any collisions with any of the child's children. */
        [collisionList
                    addObjectsFromArray:[childSprite getCollisionList:aSprite]];
    }

    return [collisionList autorelease];
}


/*
 * leftView
 *
 *   ==> aSprite                Child sprite to check.
 *
 *   <== YES                    Child sprite has left the view.
 *       NO                     Child sprite has not left the view.
 *
 *   This function checks if the child sprite specified by aSprite has left the
 * sprite view.  If it has, this function returns YES; otherwise, it returns NO.
 */

- (BOOL)leftView:(SpriteViewController*) aSprite
{
    return ![SpriteViewController doesIntersect:aSprite sprite2:self];
}


/*
 * pauseSprite
 *
 *   This function pauses the sprite.
 */

- (void)pauseSprite
{
    /* Indicate that the sprite is paused. */
    mSpritePaused = YES;

    /* Update the step timer. */
    [self updateStepTimer];

    /* Pause all child sprites. */
    [mChildSpriteSet makeObjectsPerformSelector:@selector(pauseSprite)];
}


/*
 * resumeSprite
 *
 *   This function resumes the sprite.
 */

- (void)resumeSprite
{
    /* Indicate that the sprite is not paused. */
    mSpritePaused = NO;

    /* Update system step time so that the sprite    */
    /* step time will have not changed during pause. */
    mSystemStepTime = [NSDate timeIntervalSinceReferenceDate];

    /* Update the step timer. */
    [self updateStepTimer];

    /* Resume all child sprites. */
    [mChildSpriteSet makeObjectsPerformSelector:@selector(resumeSprite)];
}


/* *****************************************************************************
 *
 * Sprite view controller SpriteNotificationDelegate services.
 *
 ******************************************************************************/

/*
 * spriteAdded
 *
 *   ==> aSprite                Sprite that has been added.
 *
 *   This notification is sent when the sprite specified by aSprite has been
 * added as a child of another sprite.
 */

- (void)spriteAdded:(SpriteViewController*) aSprite;
{
    /* Reset the sprite time. */
    /*zzz there should be a better way to do this. */
    mSpriteStepTime = 1.0;
    mSystemStepTime = [NSDate timeIntervalSinceReferenceDate];
    mPrevStepTime = 0.0;

    /* Notify delegates. */
    if (mNotificationDelegate)
    {
        if ([mNotificationDelegate respondsToSelector:@selector(spriteAdded:)])
            [mNotificationDelegate spriteAdded:aSprite];
    }

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * beforeSpriteRemoved
 *
 *   ==> aSprite                Sprite that is about to be removed.
 *
 *   This notification is sent before the sprite specified by aSprite is removed
 * as a child of another sprite.
 */

- (void)beforeSpriteRemoved:(SpriteViewController*) aSprite;
{
    /* Notify delegates. */
    if (mNotificationDelegate)
    {
        if ([mNotificationDelegate
                         respondsToSelector:@selector(beforeSpriteRemoved:)])
        {
            [mNotificationDelegate beforeSpriteRemoved:aSprite];
        }
    }

    /* Update the step timer. */
    [self updateStepTimer];
}


/* *****************************************************************************
 *
 * Internal sprite view controller services.
 *
 ******************************************************************************/

/*
 * spriteViewControllerInit
 *
 *   This function initializes the sprite view controller.
 */

- (void)spriteViewControllerInit
{
    /* Create a self weak reference proxy. */
    mSelfProxy = [[WeakReferenceProxy alloc] init];
    mSelfProxy.target = self;

    /* Initialize object fields. */
    mTargetList = [[NSMutableArray alloc] initWithCapacity:0];

    /* Initialize the step time. */
    /*zzz 1.0 is the starting step time because */
    /*zzz 0.0 is invalid.  Should make < 0.0 invalid. */
    mSpriteStepTime = 1.0;
    mSystemStepTime = [NSDate timeIntervalSinceReferenceDate];

    /* Create the child sprite set. */
    mChildSpriteSet = [[NSMutableSet alloc] initWithCapacity:0];

    /* Update the step timer. */
    [self updateStepTimer];
}


/*
 * stepSprites
 *
 *   ==> aTimer                 Sprite stepping timer.
 *
 *   This function steps all of the child sprites.  It also steps the self
 * sprite if it's the root.
 */

- (void)stepSprites:(NSTimer*) aTimer
{
    /* Update the sprite step time. */
    NSTimeInterval systemStepTime = [NSDate timeIntervalSinceReferenceDate];
    mSpriteStepTime += systemStepTime - mSystemStepTime;
    mSystemStepTime = systemStepTime;

    /* Step all child sprites.  The step method */
    /* may modify the set of child sprites.     */
    NSArray* childSpriteList = [mChildSpriteSet allObjects];
    int childSpriteCount = childSpriteList.count;
    for (int i = 0; i < childSpriteCount; i++)
    {
        /* Get the next child sprite. */
        SpriteViewController* childSprite = [childSpriteList objectAtIndex:i];

        /* Step the child sprite. */
        [childSprite step:mSpriteStepTime];

        /* Step the child sprite's children. */
        [childSprite stepSprites:aTimer];
    }

    /* Step self if it's the root sprite. */
    if (!mParentSprite)
        [self step:mSpriteStepTime];
}


/*
 * updateStepTimer
 *
 *   This function ensures that the step timer runs when it needs to.
 */

- (void)updateStepTimer
{
    /* If the sprite is running and is the root sprite, ensure the  */
    /* step timer is running.  Otherwise, ensure it is not running. */
    if (mSpriteRunning && !mSpritePaused && !mParentSprite)
    {
        if (!mStepTimer)
        {
            /* Start the step timer. */
            mStepTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                  target:mSelfProxy
                                  selector:@selector(stepSprites:)
                                  userInfo:nil
                                  repeats:YES];
            [mStepTimer retain];
        }
    }
    else
    {
        if (mStepTimer)
        {
            [mStepTimer invalidate];
            [mStepTimer release];
            mStepTimer = nil;
        }
    }
}


/*
 * stepTarget
 *
 *   ==> aStepTimeInterval      Time interval of step.
 *
 *   This function steps the sprite for the current sprite target for the time
 * interval specified by aStepTimeInterval.
 */

- (void)stepTarget:(NSTimeInterval) aStepTimeInterval
{
    /* Get the sprite center. */
    CGPoint spriteCenter = mSpriteView.center;

    /* Get the sprite target. */
    SpriteTarget* target = [mTargetList objectAtIndex:0];
    CGPoint targetPosition = target.target;
    float targetDist = [self getTargetDist];

    /* If the sprite is within one step of the target, switch to the next    */
    /* target.  If no more targets remain, move directly to final target and */
    /* stop sprite.                                                          */
    if (targetDist <= (mTargetSpeed * aStepTimeInterval))
    {
        /* Remove current target. */
        [mTargetList removeObjectAtIndex:0];

        /* If no more targets remain, move directly */
        /* to target, stop, and do nothing more.    */
        /* If no more targets remain, finish up and do nothing more. */
        if (!mTargetList.count)
        {
            /* Remove sprite if set to remove after last target. */
            /* Otherwise, move directly to target and stop.      */
            if (mRemoveAfterLastTarget)
            {
                [self.parentSprite removeChild:self];
            }
            else
            {
                mSpriteView.center = targetPosition;
                mVelocityX = 0.0;
                mVelocityY = 0.0;
                mAcceleration = 0.0;
            }
            return;
        }

        /* Switch to next target. */
        target = [mTargetList objectAtIndex:0];
        targetPosition = target.target;
        targetDist = [self getTargetDist];
    }

    /* If a valid acceleration is set, accelerate the sprite towards the */
    /* target. Otherwise, set the sprite velocity towards the target.    */
    if (mAcceleration > 0.0)
    {
        /* Get the sprite target acceleration vector. */
        Vector targetAccelerationVector = [self getTargetAccelerationVector];

        /* Update the sprite velocity. */
        mVelocityX += targetAccelerationVector.v0 * aStepTimeInterval;
        mVelocityY += targetAccelerationVector.v1 * aStepTimeInterval;

        /* Limit the sprite speed. */
        if ([self speed] > mTargetSpeed)
            [self setSpeed:mTargetSpeed];
    }
    else
    {
        /* Set the sprite velocity towards the target. */
        mVelocityX =   mTargetSpeed
                     * ((targetPosition.x - spriteCenter.x) / targetDist);
        mVelocityY =   mTargetSpeed
                     * ((targetPosition.y - spriteCenter.y) / targetDist);
    }

    /* Step the sprite velocity. */
    [self stepVelocity:aStepTimeInterval];
}


/*
 * stepVelocity
 *
 *   ==> aStepTimeInterval      Time interval of step.
 *
 *   This function steps the sprite for the current sprite velocity for the time
 * interval specified by aStepTimeInterval.
 */

- (void)stepVelocity:(NSTimeInterval) aStepTimeInterval
{
    /* Update the sprite position. */
    CGPoint center = mSpriteView.center;
    center.x += mVelocityX * aStepTimeInterval;
    center.y += mVelocityY * aStepTimeInterval;
    mSpriteView.center = center;
}


/*
 * getTargetAccelerationVector
 *
 *   <==                        Acceleration vector towards target.
 *
 *   This function computes and returns a sprite acceleration vector to direct
 * the sprite to the target.
 */

- (Vector)getTargetAccelerationVector
{
    /* Get the sprite center. */
    CGPoint spriteCenter = mSpriteView.center;

    /* Get the sprite target. */
    SpriteTarget* target = [mTargetList objectAtIndex:0];
    CGPoint targetPosition = target.target;

    /* Get the vector to the target. */
    Vector targetVector = { targetPosition.x - spriteCenter.x,
                            targetPosition.y - spriteCenter.y };
    Vector targetUnitVector = VectorGetUnit(targetVector);

    /* Get the components of the sprite velocity vector that */
    /* are parallel and perpendicular to the target vector.  */
    Vector spriteVelocityVector = { mVelocityX, mVelocityY };
    Vector spriteTargetVelocityVector =
                            VectorScale(targetUnitVector,
                                        VectorDotProduct(spriteVelocityVector,
                                                         targetUnitVector));
    Vector spriteTargetPerpVelocityVector =
            VectorDifference(spriteVelocityVector, spriteTargetVelocityVector);

    /* Determine the amount of time to reach the target if */
    /* the sprite target perpendicular velocity was zero.  */
    float timeToTarget =   VectorGetLength(targetVector)
                         / VectorGetLength(spriteTargetVelocityVector);

    /* Set the sprite target perpendicular acceleration to reduce the sprite */
    /* target perpendicular velocity to zero within the time to target.      */
    Vector spriteTargetPerpAccelerationVector =
                                    VectorScale(spriteTargetPerpVelocityVector,
                                                -1.0 / timeToTarget);
    float spriteTargetPerpAcceleration =
                            VectorGetLength(spriteTargetPerpAccelerationVector);
    if (spriteTargetPerpAcceleration > mAcceleration)
    {
        spriteTargetPerpAccelerationVector =
            VectorSetLength(spriteTargetPerpAccelerationVector, mAcceleration);
    }

    /* Set the sprite target acceleration to */
    /* the remaining sprite acceleration.    */
    float spriteTargetAcceleration =
                      mAcceleration*mAcceleration
                    - spriteTargetPerpAcceleration*spriteTargetPerpAcceleration;
    if (spriteTargetAcceleration > 0.0)
        spriteTargetAcceleration = sqrt(spriteTargetAcceleration);
    else
        spriteTargetAcceleration = 0.0;
    Vector spriteTargetAccelerationVector =
                                        VectorScale(targetUnitVector,
                                                    spriteTargetAcceleration);

    /* Get the total sprite acceleration vector. */
    Vector spriteAccelerationVector =
                                VectorSum(spriteTargetAccelerationVector,
                                          spriteTargetPerpAccelerationVector);

    return spriteAccelerationVector;
}


/*
 * getTargetDist
 *
 *   <==                        Distance to current target.
 *
 *   This function computes and returns the distance between the sprite and the
 * sprite target.
 */

- (float)getTargetDist
{
    /* Get the sprite center. */
    CGPoint spriteCenter = mSpriteView.center;

    /* Get the sprite target. */
    SpriteTarget* target = [mTargetList objectAtIndex:0];
    CGPoint targetPosition = target.target;

    /* Compute distance to target. */
    CGFloat targetDist =   (targetPosition.x - spriteCenter.x)
                         * (targetPosition.x - spriteCenter.x);
    targetDist +=   (targetPosition.y - spriteCenter.y)
                  * (targetPosition.y - spriteCenter.y);
    targetDist = sqrt(targetDist);

    return targetDist;
}


/* *****************************************************************************
 *
 * Sprite view controller class services.
 *
 ******************************************************************************/

/*
 * doesIntersect
 *
 *   ==> aSprite1               First sprite.
 *   ==> aSprite2               Second sprite.
 *
 *   <== YES                    Sprites intersect.
 *       NO                     Sprites do not intersect.
 *
 *   This function determines whether the two sprites specified by aSprite1 and
 * aSprite2 intersect.  If they do, this function returns YES; otherwise, it
 * returns NO.
 */

+ (BOOL)doesIntersect:(SpriteViewController*) aSprite1
    sprite2:(SpriteViewController*)           aSprite2
{
    /* Get the view frame rects, ensuring     */
    /* they're in the same coordinate system. */
    CGRect rect1 = aSprite1.spriteView.frame;
    CGRect rect2 =
                [aSprite2.spriteView convertRect:aSprite2.spriteView.bounds
                                     toView:aSprite1.parentSprite.spriteView];

    /* Get the view frame bounds. */
    float leftMost1 = CGRectGetMinX(rect1);
    float leftMost2 = CGRectGetMinX(rect2);
    float rightMost1 = CGRectGetMaxX(rect1);
    float rightMost2 = CGRectGetMaxX(rect2);
    float topMost1 = CGRectGetMinY(rect1);
    float topMost2 = CGRectGetMinY(rect2);
    float bottomMost1 = CGRectGetMaxY(rect1);
    float bottomMost2 = CGRectGetMaxY(rect2) ;

    /* Check for intersection. */
    if (   (topMost1 < bottomMost2)
        && (bottomMost1 > topMost2)
        && (leftMost1 < rightMost2)
        && (rightMost1 > leftMost2))
    {
        return YES;
    }

    return NO;
}


/*
 * doesIntersect
 *
 *   ==> aView1                 First view.
 *   ==> aView2                 Second view.
 *
 *   <== YES                    Views intersect.
 *       NO                     Views do not intersect.
 *
 *   This function determines whether the two views specified by aView1 and
 * aView2 intersect.  If they do, this function returns YES; otherwise, it
 * returns NO.
 */

+ (BOOL)doesIntersect:(UIView*) aView1
    view2:(UIView*)             aView2
{
    /* Get the view frame rects. */
    CGRect rect1 = [aView1 frame];
    CGRect rect2 = [aView2 frame];

    /* Get the view frame bounds. */
    float leftMost1 = CGRectGetMinX(rect1);
    float leftMost2 = CGRectGetMinX(rect2);
    float rightMost1 = CGRectGetMaxX(rect1);
    float rightMost2 = CGRectGetMaxX(rect2);
    float topMost1 = CGRectGetMinY(rect1);
    float topMost2 = CGRectGetMinY(rect2);
    float bottomMost1 = CGRectGetMaxY(rect1);
    float bottomMost2 = CGRectGetMaxY(rect2) ;

    /* Check for intersection. */
    if (   (topMost1 < bottomMost2)
        && (bottomMost1 > topMost2)
        && (leftMost1 < rightMost2)
        && (rightMost1 > leftMost2))
    {
        return YES;
    }

    return NO;
}


/*
 * doesIntersect
 *
 *   ==> aRect1                 First rectangle.
 *   ==> aRect2                 Second rectangle.
 *
 *   <== YES                    Rectangles intersect.
 *       NO                     Rectangles do not intersect.
 *
 *   This function determines whether the two rectangles specified by aRect1 and
 * aRect2 intersect.  If they do, this function returns YES; otherwise, it
 * returns NO.
 */

+ (BOOL)doesIntersect:(CGRect) aRect1
    rect2:(CGRect)             aRect2
{
    /* Get the rect bounds. */
    float leftMost1 = CGRectGetMinX(aRect1);
    float leftMost2 = CGRectGetMinX(aRect2);
    float rightMost1 = CGRectGetMaxX(aRect1);
    float rightMost2 = CGRectGetMaxX(aRect2);
    float topMost1 = CGRectGetMinY(aRect1);
    float topMost2 = CGRectGetMinY(aRect2);
    float bottomMost1 = CGRectGetMaxY(aRect1);
    float bottomMost2 = CGRectGetMaxY(aRect2) ;

    /* Check for intersection. */
    if (   (topMost1 < bottomMost2)
        && (bottomMost1 > topMost2)
        && (leftMost1 < rightMost2)
        && (rightMost1 > leftMost2))
    {
        return YES;
    }

    return NO;
}

@end


/* *****************************************************************************
 *******************************************************************************
 *
 * Sprite target class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

@implementation SpriteTarget

/* Synthesize properties. */
@synthesize target = mTarget;


/*
 * target
 *
 *   ==> aTarget                Sprite target position.
 *
 *   <==                        Sprite target.
 *
 *   Return a sprite target for the sprite target position specified by aTarget.
 */

+ (id)target:(CGPoint) aTarget
{
    return [[[SpriteTarget alloc] initWithTarget:aTarget] autorelease];
}


/*
 * initWithTarget
 *
 *   ==> aTarget                Target position.
 *
 *   <==                        Sprite target.
 *
 *   This funciton initializes and returns a sprite target with the position
 * specified by aTarget
 */

- (id)initWithTarget:(CGPoint) aTarget
{
    /* Initialize. */
    self = [self init];
    if (!self)
        return nil;

    /* Set the target position. */
    mTarget = aTarget;

    return self;
}

@end


