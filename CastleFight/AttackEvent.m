//
//  Attack.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import "AttackEvent.h"
#import "Attribute.h"
#import "RenderComponent.h"
#import "AttackerComponent.h"
#import "DefenderComponent.h"

@implementation AttackEvent

-(id)initWithAttacker:(Entity *)attacker attackerComponent:(AttackerComponent *)attack damageType:(DamageType)type damageSource:(DamageSource)source defender:(Entity *)defender {
    if(self = [super init]) {
//        NSAssert([attacker getComponentOfClass:[AttackerComponent class]], @"Invalid attacker!");
//        NSAssert([defender getComponentOfClass:[DefenderComponent class]], @"Invalid defender!");
        
        _attacker = attacker;
        _attack = attack;
        _defender = defender;
        _type = type;
        _source = source;
        bonus = 0;
        multiplier = 1;
        _sideEffects = [NSMutableArray  new];
        _customDamage = 0;
        _isIgnoreDefense = NO;
        _customDamage = NO;
        
        RenderComponent *render = (RenderComponent *)[_attacker getComponentOfClass:[RenderComponent class]];
        if (render) {
            // Set dafault attack position as attack position.
            _position = render.sprite.position;
        }
    }
    return self;
}

-(int)damage {
    DefenderComponent *defendCom = (DefenderComponent *)[_defender getComponentOfClass:[DefenderComponent class]];
    
    int defense = defendCom.defense ? defendCom.defense.value : 0;
    
    if (self.isIgnoreDefense && self.isCustomDamage) {
        return self.customDamage;
    }else if (self.isIgnoreDefense) {
        return _attack.attack.value;
    }else if (self.isCustomDamage) {
        return self.customDamage - defense;
    }
    
    // Attack damage formula
    return _attack.attack.value - defense;
}

-(DamageEvent*)convertToDamageEvent {
    DamageEvent *event = [[DamageEvent alloc] initWithSender:_attacker damage:[self damage] damageType:_type damageSource:_source receiver:_defender];
    event.position = _position;
    event.knockOutPower = _knockOutPower;
    event.knouckOutCollision = _knouckOutCollision;
    event.isCustomDamage = self.isCustomDamage;
    return event;
}

@end
