//
//  CharacterStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "Status.h"

@implementation Status
@synthesize type,isDead;

//-(id)init {
//    if(self = [super init]) {
//        modifierMap = [[ModifierMap alloc] init];
//    }
//    return self;
//}

-(id)initWithType:(int)statusType {
    if(self = [super init]) {
//        NSAssert(type == statusUnknown, @"Every CharacterStatus should init its type!!");
        type = statusType;
        modifierMap = [[ModifierMap alloc] init];
        isDead = false;
    }
    return self;
}

//-(void)addEffect {
//    [NSException raise:@"Called abstract method!" format:@"You should override addEffect in CharacterStatus."];
//}

//-(void)removeEffect {
//    [NSException raise:@"Called abstract method!" format:@"You should override removeEffect in CharacterStatus."];
//}

//-(void)update {
//    [NSException raise:@"Called abstract method!" format:@"You should override update in CharacterStatus."];
//}

-(void)addAttributeModifier:(AttributeModifier*)modifier toAttribute:(AttributeType)attribute onCondition:(ConditionType)condition {
    [modifierMap addAttributeModifier:modifier toAttribute:attribute onCondition:condition];
}

-(float)modifyAttributeValue:(float)value onAttribute:(AttributeType)attribute onCondition:(ConditionType)condition {
    return [modifierMap modifyAttributeValue:value onAttribute:attribute onCondition:condition];
}

@end
