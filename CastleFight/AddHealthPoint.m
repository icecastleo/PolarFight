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

@interface AddHealthPoint ()
{
    int orbSum;
}

@end

@implementation AddHealthPoint

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = NO;
    
    // suppose if red color > 0, is active.
    //FIXME: +3 is for test.
    orbSum = [[orbInfo objectForKey:[NSNumber numberWithInt:OrbPurple]] intValue] +3 ;
    if (orbSum > 0) {
        CCLOG(@"level %d: Add HealthPoint is Active",self.level);
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
    
    // basic rate: 0.25
    float multiplier = 0.25 * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Hp: from %d to %d.",oldAttribute,attribute.value);
}

@end
