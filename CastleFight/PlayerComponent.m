//
//  PlayerComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PlayerComponent.h"
#import "OrbSkill.h"
#import "FileManager.h"
#import "OrbSkillData.h"

@interface PlayerComponent() {
    NSMutableDictionary *counts;
}
@end

@implementation PlayerComponent

+(NSString *)name {
    static NSString *name = @"PlayerComponent";
    return name;
}

-(id)init {
    if ((self = [super init])) {
        counts = [[NSMutableDictionary alloc] init];
        
        _food = 10.0;
        _foodRate = 1.0;
        _maxRate = _foodRate * 4;

        _mana = 10.0;
//        _manaRate = 1.0;
//        _maxManaRate = _manaRate * 4;
        
        _interval = 0.25;
        
        _summonButtons = [[NSMutableArray alloc] init];
//        _battleTeam = [[NSMutableArray alloc] init];
        _items = [[NSMutableArray alloc] init];
        _itemsInBattle = [[NSMutableArray alloc] init];
        _magicTeam = [[NSMutableArray alloc] init];
        _magicInBattle = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEventManaChanged) {
        CCLOG(@"from :%f",self.mana);
        self.mana += [message intValue];
        CCLOG(@"to :%f",self.mana);
    }
}

-(void)addCount:(int)count onOrbColor:(OrbColor)color; {
    NSNumber *key = [NSNumber numberWithInt:color];
    NSNumber *number = [counts objectForKey:key];
    
    if (number == nil) {
        number = [NSNumber numberWithInt:0];
        [counts setObject:number forKey:key];
    }
    
    [counts setObject:[NSNumber numberWithInt:[number intValue]+count] forKey:key];
}

-(NSMutableDictionary *)getCalculatedArmies {
    NSMutableDictionary *armies = [[NSMutableDictionary alloc] init];
    
    //    for (id key in counts.allKeys) {
    //        int type = [key intValue];
    //        int count = [[counts objectForKey:key] intValue];
    //
    //        // FIXME: Link cid with user data's battle team
    //        [armies setObject:[NSNumber numberWithInt:count/3] forKey:[NSString stringWithFormat:@"00%d",type]];
    //    }
    
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"001"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"002"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"003"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"004"];
    
    return armies;
}


//-(void)setFoodRate:(float)foodRate {
//    if (foodRate > _maxRate) {
//        _foodRate = _maxRate;
//    } else {
//        _foodRate = foodRate;
//    }
//}
//
//-(void)setManaRate:(float)manaRate {
//    if (manaRate > _maxManaRate) {
//        _manaRate = _maxManaRate;
//    } else {
//        _manaRate = manaRate;
//    }
//}

-(NSDictionary *)orbInfo {
    return counts;
}

-(NSArray *)activeSkills {
    
    NSArray *allSkills = [FileManager sharedFileManager].orbSkills;
    
    // for test
    [counts setObject:[NSNumber numberWithInt:2] forKey:@"Combos"];
    
    NSMutableArray *activeSkills = [[NSMutableArray alloc] init];
    
    for (OrbSkillData *skillData in allSkills) {
        int level = skillData.level;
        if (skillData.unLocked && level > 0) {
            OrbSkill *skill = [[NSClassFromString(skillData.name) alloc] initWithLevel:level];
            NSAssert(skill != nil, @"you forgot to make this skill");
            if ([skill isActivated:counts]) {
                [activeSkills addObject:skill];
            }
        }
    }
    return activeSkills;
}

@end
