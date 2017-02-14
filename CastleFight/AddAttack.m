//
//  AddAttack.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/1.
//
//

#import "AddAttack.h"
#import "AttackerComponent.h"
#import "Attribute.h"

@interface AddAttack ()
{
    int orbSum;
}

@end

@implementation AddAttack

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
    orbSum = [[orbInfo objectForKey:[NSNumber numberWithInt:OrbRed]] intValue] +3 ;
    if (orbSum > 0) {
        CCLOG(@"level %d: Add Attack is Active",self.level);
        _isActivated = YES;
    }
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    AttackerComponent *attackCom = (AttackerComponent *)[entity getComponentOfName:[AttackerComponent name]];
    Attribute *attribute = attackCom.attack;
    
    // only for log
    int oldAttribute = attribute.value;
    
    // basic rate: 0.25
    float multiplier = 0.25 * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Attack: from %d to %d.",oldAttribute,attribute.value);
}

@end
