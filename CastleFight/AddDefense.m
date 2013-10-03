//
//  AddDefense.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/1.
//
//

#import "AddDefense.h"
#import "DefenderComponent.h"
#import "Attribute.h"

@implementation AddDefense

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = YES;
    
    //suppose this skill does not need any orb conditions;
    CCLOG(@"level %d: Add Defense is Active",self.level);
    
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    DefenderComponent *defenderCom = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
    Attribute *attribute = defenderCom.defense;
    
    // only for log
    int oldAttribute = attribute.value;
    
    float multiplier = 0.25 * self.level + 1;
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Defense: from %d to %d.",oldAttribute,attribute.value);
}

@end
