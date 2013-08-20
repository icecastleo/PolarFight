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
#import "DefenderComponent.h"

@implementation AttackEvent

-(id)initWithAttacker:(Entity *)attacker attackerComponent:(AttackerComponent *)attack damageType:(DamageType)type damageSource:(DamageSource)source defender:(Entity *)defender {
    if(self = [super init]) {
//        NSAssert([attacker getComponentOfName:[AttackerComponent name]], @"Invalid attacker!");
//        NSAssert([defender getComponentOfName:[DefenderComponent name]], @"Invalid defender!");
        
        _attacker = attacker;
        _attack = attack;
        _defender = defender;
        _type = type;
        _source = source;
        bonus = 0;
        multiplier = 1;
        _sideEffects = [[NSMutableArray  alloc] init];
        _customDamage = 0;
        _isIgnoreDefense = NO;
        _customDamage = NO;
        
        RenderComponent *render = (RenderComponent *)[_defender getComponentOfName:[RenderComponent name]];
        if (render) {
            if (!render.isSpineNode)
                NSAssert(render.sprite.anchorPoint.x == 0.5 && render.sprite.anchorPoint.y == 0.5, @"It's recommended not to change the anchor point, and let the position to be the center of sprite!");
            
            // Set dafault event position as defender's sprite position.
            _position = [render.node.parent convertToWorldSpace:render.node.position];
        }
    }
    return self;
}

-(int)damage {
    DefenderComponent *defendCom = (DefenderComponent *)[_defender getComponentOfName:[DefenderComponent name]];
    
    int defense = defendCom.defense ? defendCom.defense.value : 0;
    
    if (self.isIgnoreDefense && self.isCustomDamage) {
        return self.customDamage;
    } else if (self.isIgnoreDefense) {
        return _attack.attack.value;
    } else if (self.isCustomDamage) {
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
