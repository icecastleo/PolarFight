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

-(id)initWithAttacker:(Entity *)attacker damageType:(DamageType)type damageSource:(DamageSource)source defender:(Entity *)defender {
    if(self = [super init]) {
        NSAssert([attacker getComponentOfClass:[AttackerComponent class]], @"Invalid attacker!");
        NSAssert([defender getComponentOfClass:[DefenderComponent class]], @"Invalid defender!");
        
        _attacker = attacker;
        _defender = defender;
        _type = type;
        _source = source;
        bonus = 0;
        multiplier = 1;
        
        RenderComponent *render = (RenderComponent *)[_attacker getComponentOfClass:[RenderComponent class]];
        if (render) {
            // Set dafault attack position as attack position.
            _position = render.sprite.position;
        }
    }
    return self;
}

-(int)damage {
    AttackerComponent *attackCom = (AttackerComponent *)[_attacker getComponentOfClass:[AttackerComponent class]];
    DefenderComponent *defendCom = (DefenderComponent *)[_defender getComponentOfClass:[DefenderComponent class]];
    
    int attack = attackCom.attack.value;
    int defense = defendCom.defense ? defendCom.defense.value : 0;
    
    // Attack damage formula
    return attack - defense;
}

-(DamageEvent*)convertToDamageEvent {
    DamageEvent *event = [[DamageEvent alloc] initWithSender:_attacker damage:[self damage] damageType:_type damageSource:_source receiver:_defender];
    event.position = _position;
    event.knockOutPower = _knockOutPower;
    event.knouckOutCollision = _knouckOutCollision;
    return event;
}

@end
