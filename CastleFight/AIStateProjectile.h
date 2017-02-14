//
//  AIStateProjectile.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/21.
//
//

#import "AIState.h"
#import "ProjectileEvent.h"

@interface AIStateProjectile : AIState

-(id)initWithProjectEvent:(ProjectileEvent *)pEvent;

@end
