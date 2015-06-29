/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C source file for the health power-up sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Health power-up sprite imported services.
 *
 ******************************************************************************/

/* Self import. */
#import "HealthPowerUpSprite.h"

/* Local imports. */
#import "ProjectileSprite.h"


/* *****************************************************************************
 *******************************************************************************
 *
 * Health power-up sprite class implementation.
 *
 *******************************************************************************
 ******************************************************************************/

/*
 * Health power-up sprite class configuration.
 *
 *   HEALTH_POWER_UP_LIFE_TIME      Life time of health power-up.
 *   HEALTH_POWER_UP_ADDED_HEALTH   Health added by health power-up.
 */

#define HEALTH_POWER_UP_LIFE_TIME       10.0
#define HEALTH_POWER_UP_ADDED_HEALTH    30.0


@implementation HealthPowerUpSprite


/* *****************************************************************************
 *
 * Health power-up sprite NSObject services.
 *
 ******************************************************************************/

/*
 * init
 *
 *   This function initializes the health power-up sprite.
 */

- (id)init
{
    /* Initialize the super class. */
    self = [super init];
    if (!self)
        return nil;

    /* Set the health power-up target properties. */
    self.lifeTime = HEALTH_POWER_UP_LIFE_TIME;
    [self addTargetType:TargetSpriteTypePowerUp];

    /* Set the health power-up sprite view. */
    UIImageView* healthPowerUpView =
                    [[UIImageView alloc]
                        initWithImage:[UIImage imageNamed:@"milkcarton.png"]];
    self.spriteView = healthPowerUpView;

    /* Release objects. */
    [healthPowerUpView release];

    return self;
}


/*
 * dealloc
 *
 *   This function deallocates the object.
 */

- (void)dealloc
{
    /* Invoke the super-class. */
    [super dealloc];
}


/* *****************************************************************************
 *
 * Health power-up sprite SpriteNotificationDelegate services.
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

- (void)spriteAdded:(SpriteViewController*) aSprite
{
    /* Invoke super-class. */
    [super spriteAdded:aSprite];
}


/* *****************************************************************************
 *
 * Health power-up sprite TargetSprite services.
 *
 ******************************************************************************/

/*
 * handleDefeated
 *
 *   ==> aDefeatingSprite       Sprite that defeated target sprite.
 *
 *   This function handles a target sprite defeated event by the sprite
 * specified by aDefeatingSprite.
 */

- (void)handleDefeated:(SpriteViewController*) aDefeatingSprite
{
    /* If defeated by a target sprite, power up its health. */
    if ([aDefeatingSprite isKindOfClass:[ProjectileSprite class]])
    {
        ProjectileSprite*
                projectileSprite = (ProjectileSprite*) aDefeatingSprite;
        if ([projectileSprite.shooter isKindOfClass:[TargetSprite class]])
        {
            TargetSprite*
                        targetSprite = (TargetSprite*) projectileSprite.shooter;
            [targetSprite powerUpHealth:HEALTH_POWER_UP_ADDED_HEALTH];
        }
    }

    /* Invoke the super class. */
    [super handleDefeated:aDefeatingSprite];
}


@end


