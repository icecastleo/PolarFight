//
//  AddSpeed2.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/8.
//
//

#import "AddSpeed2.h"
#import "MoveComponent.h"
#import "Attribute.h"

@interface AddSpeed2 ()
{
    int orbSum;
}

@end

@implementation AddSpeed2

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
    orbSum = [[orbInfo objectForKey:[NSNumber numberWithInt:OrbYellow]] intValue] +3 ;
    if (orbSum > 0) {
        CCLOG(@"level %d: Add Speed2 is Active",self.level);
        _isActivated = YES;
    }
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
    
    // plus rate: 0.1
    float multiplier = 0.1 * self.level * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Speed2: from %d to %d.",oldAttribute,attribute.value);
}

@end
