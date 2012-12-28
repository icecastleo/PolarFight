//
//  Attack.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import <Foundation/Foundation.h>
#import "DamageEvent.h"
@class Character;

@interface AttackEvent : NSObject {
    
}

@property (retain,readonly) Character *attacker;
@property (retain,readonly) Character *defender;
@property (readonly) AttackType type;
@property float bonus;
@property float multiplier;

-(id)initWithAttacker:(Character *)anAttacker attackType:(AttackType)aType defender:(Character*)aDefender;

-(DamageEvent*)convertToDamageEvent;

@end
