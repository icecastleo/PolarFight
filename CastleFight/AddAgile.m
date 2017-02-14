//
//  AddAgile.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "AddAgile.h"
#import "ActiveSkillComponent.h"
#import "Attribute.h"

@interface AddAgile ()
{
    int orbSum;
}

@end

@implementation AddAgile

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
        CCLOG(@"level %d: Add Agile is Active",self.level);
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
    
    // basic rate: 0.25
    float multiplier = 0.25 * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Agile: from %d to %d.",oldAttribute,attribute.value);
}

@end
