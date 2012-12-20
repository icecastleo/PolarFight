//
//  AttackCalculator.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/6.
//
//

#import <Foundation/Foundation.h>
#import "AttackEvent.h"
#import "Character.h"

@interface AttackEventHandler : NSObject

+(void)handleAttackEvent:(AttackEvent*)attackEvent toCharacter:(Character*)defender;

@end
