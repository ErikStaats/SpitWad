/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * Objective-C header file for the base projectile sprite.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Base projectile sprite imported services.
 *
 ******************************************************************************/

/* Local imports. */
#import "ProjectileSprite.h"


/* *****************************************************************************
 *
 * Base projectile sprite class definition.
 *
 ******************************************************************************/

@interface ProjectileBaseSprite : ProjectileSprite
{
    /*
     * mProjectileImageFileName Projectile image file name.
     */

    NSString*                   mProjectileImageFileName;
}


/* Base projectile sprite services. */
- (void)configureProjectile;


@end


