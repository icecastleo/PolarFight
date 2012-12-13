//
//  ModifierMap.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/17.
//
//

#import "ModifierMap.h"

@implementation ModifierMap

-(id)init {
    if(self = [super init]) {
        map = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)addAttributeModifier:(AttributeModifier*)modifier toAttribute:(CharacterAttribute)attribute onCondition:(ConditionType)condition {
    NSNumber *key = [NSNumber numberWithInt:attribute];
    
    NSMutableDictionary *temp = [map objectForKey:key];
    
    if(temp == nil) {
        temp = [[NSMutableDictionary alloc] init];
        [map setObject:temp forKey:key];
    }
    
    [temp setObject:modifier forKey:[NSNumber numberWithInt:condition]];
}

-(float)modifyAttributeValue:(float)value onAttribute:(CharacterAttribute)attribute onCondition:(ConditionType)condition {
    NSMutableDictionary *temp = [map objectForKey:[NSNumber numberWithInt:attribute]];
    
    if(temp == nil) {
        return value;
    }
    
    AttributeModifier *modifier = [temp objectForKey:[NSNumber numberWithInt:condition]];
    
    if(modifier == nil) {
        return value;
    }
    
    return [modifier modifyValue:value];
}

@end
