//
//  AddSpeed.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "AddSpeed.h"
#import "MoveComponent.h"
#import "Attribute.h"

@interface AddSpeed ()
{
    int orbSum;
}

@end

@implementation AddSpeed

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
        CCLOG(@"level %d: Add Speed is Active",self.level);
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
    
    // basic rate: 0.25
    float multiplier = 0.25 * orbSum;
    
    [attribute addMultiplier:multiplier];
    
    CCLOG(@"Add Speed: from %d to %d.",oldAttribute,attribute.value);
}

@end
