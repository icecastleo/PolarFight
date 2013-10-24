//
//  AddAgile2.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/8.
//
//

#import "AddAgile2.h"
#import "ActiveSkillComponent.h"
#import "Attribute.h"

@interface AddAgile2 ()
{
    int orbSum;
}

@end

@implementation AddAgile2

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
    orbSum = [[orbInfo objectForKey:[NSNumber numberWithInt:OrbGreen]] intValue] +3 ;
    if (orbSum > 0) {
        CCLOG(@"level %d: Add Agile2 is Active",self.level);
        _isActivated = YES;
    }
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
    
    // plus rate: 0.1
    float multiplier = 0.1 * self.level * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Agile2: from %d to %d.",oldAttribute,attribute.value);
}

@end
