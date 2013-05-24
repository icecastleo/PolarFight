//
//  StateComponent.h
//  CastleFight
//
//  Created by  DAN on 13/5/24.
//
//

#import "Component.h"

@class DamageEvent;

@interface StateComponent : Component

@property float currentTime;
@property int cdTime;
@property int totalTime;
@property DamageEvent *event;

-(void)processEnity:(Entity*)enity;

@end
