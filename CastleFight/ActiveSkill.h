//
//  Skill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import <Foundation/Foundation.h>
#import "Range.h"
#import "Entity.h"

@interface ActiveSkill : NSObject {
    Range *range;
}

@property (nonatomic) Entity *owner;

@property float cooldown;
@property NSString *animationKey;
@property NSMutableDictionary *combo;

@property BOOL canActive;
@property BOOL isFinish;

-(void)active;
-(void)activeEffect;

-(BOOL)checkRange;

@end
