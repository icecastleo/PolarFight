//
//  StateComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/5/24.
//
//

#import "Component.h"

@class DamageEvent;

@protocol StateComponentDelegate
@optional
-(void)process;
@end

@interface StateComponent : Component <StateComponentDelegate>

@property float currentTime;
@property float cdTime;   //second
@property float totalTime;    //second
@property DamageEvent *event;

@end
