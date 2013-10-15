//
//  AddReward.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "AddReward.h"

@interface AddReward()
{
    float bonus;
}

@end

@implementation AddReward

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypeAfterBattle;
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
        CCLOG(@"level %d: AddReward is Active",self.level);
        _isActivated = YES;
    }
    
    return _isActivated;
}

-(float)bonusReward {
    return bonus;
}

@end
