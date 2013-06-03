//
//  PassiveSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/29.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Range.h"

@interface PassiveSkill : NSObject {
    Range *range;
}

@property (nonatomic) Entity *owner;
@property float totalTime;
@property NSString *animationKey;
//@property BOOL canActive;
@property BOOL isAnimationFinish;

-(void)active;
-(void)activeEffect;

-(void)checkEvent:(EventType)eventType;
-(BOOL)checkRange;

@end
