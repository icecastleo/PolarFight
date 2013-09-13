//
//  PlayerArmyComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/11.
//
//

#import "Component.h"

@interface PlayerArmyComponent : Component

@property NSDictionary *remainArmies;

-(void)addCount:(int)count onOrbColor:(OrbColor)color;
-(NSMutableDictionary *)getCalculatedArmies;

@end
