//
//  AddHealthPoint.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "AddHealthPoint.h"
#import "DefenderComponent.h"
#import "Attribute.h"

@implementation AddHealthPoint

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = NO;
    
    // suppose if red color > 2, is active;
    int redColorOrb = [[orbInfo objectForKey:[NSNumber numberWithInt:OrbRed]] intValue] +3 ;
    if (redColorOrb > 2) {
        CCLOG(@"level %d: Add Hp is Active",self.level);
        _isActivated = YES;
    }
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    DefenderComponent *defenderCom = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
    Attribute *attribute = defenderCom.hp;
    
    // only for log
    int oldAttribute = attribute.value;
    
    float multiplier = 0.25 * self.level + 1;
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Hp: from %d to %d.",oldAttribute,attribute.value);
}

@end
