//
//  AddAgile.m
//  CastleFight
//
//  Created by  DAN on 13/10/3.
//
//

#import "AddAgile.h"
#import "ActiveSkillComponent.h"
#import "Attribute.h"

@implementation AddAgile

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = YES;
    
    //suppose this skill does not need any orb conditions;
    CCLOG(@"level %d: Add Agile is Active",self.level);
    
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    ActiveSkillComponent *activeSkillCom = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
    Attribute *attribute = activeSkillCom.agile;
    
    // only for log
    int oldAttribute = attribute.value;
    
    float multiplier = 0.25 * self.level + 1;
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Agile: from %d to %d.",oldAttribute,attribute.value);
}

@end
