//
//  AddCharacterSum.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/1.
//
//

#import "AddCharacterSum.h"

@implementation AddCharacterSum

-(id)initWithLevel:(int)level {
    if (self = [super initWithLevel:level]) {
        _skillType = OrbSkillTypePrepareBattle;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    _isActivated = NO;
    
    if (self.level > 0) {
        _isActivated = YES;
    }
    
    //suppose this skill does not need any orb conditions;
    CCLOG(@"level %d: AddCharacterSum is Active",self.level);
    
    return _isActivated;
}

-(void)affectOnEntity:(Entity *)entity {
    if (!self.isActivated) {
        return;
    }
    //TODO: this method.
    CCLOG(@"Decrease character's attributes 30 percent. (Not yet)");
}

-(int)characterBonusCount {
    if (!self.isActivated) {
        return 0;
    }
    //FIXME: change the logic.
    int count = 0;
    switch (self.level) {
        case 1:
            count = 1;
            break;
        
        case 2:
            count = 2;
            break;
            
        case 3:
            count = 3;
            break;
            
        default:
            break;
    }
    return count;
}

@end
