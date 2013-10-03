//
//  AddSpeed.m
//  CastleFight
//
//  Created by  DAN on 13/10/3.
//
//

#import "AddSpeed.h"
#import "MoveComponent.h"
#import "Attribute.h"

@implementation AddSpeed

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = YES;
    
    //suppose this skill does not need any orb conditions;
    CCLOG(@"level %d: Add Speed is Active",self.level);
    
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    Attribute *attribute = moveCom.speed;
    
    // only for log
    int oldAttribute = attribute.value;
    
    float multiplier = 0.25 * self.level + 1;
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Speed: from %d to %d.",oldAttribute,attribute.value);
}

@end
