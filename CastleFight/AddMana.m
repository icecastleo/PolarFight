//
//  AddMana.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "AddMana.h"

@interface AddMana()
{
    float bonus;
}

@end

@implementation AddMana

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
        bonus = 0;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = NO;
    
    int combos = [[orbInfo objectForKey:@"Combos"] intValue];
    
    //FIXME: change the logic.
    bonus = 0.1 * self.level * combos;
    
    if (bonus > 0) {
        CCLOG(@"level %d: AddMana is Active",self.level);
        _isActivated = YES;
    }
    
    return _isActivated;
}

-(float)bonusMana {
    return bonus;
}

@end
