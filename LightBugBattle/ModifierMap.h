//
//  ModifierMap.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/17.
//
//

#import <Foundation/Foundation.h>
#import "AttributeModifier.h"

@interface ModifierMap : NSObject {
    NSMutableDictionary *map;
}

-(id)init;

-(void)addAttributeModifier:(AttributeModifier*)modifier toAttribute:(CharacterAttributeType)attribute onCondition:(ConditionType)condition;
-(float)modifyAttributeValue:(float)value onAttribute:(CharacterAttributeType)attribute onCondition:(ConditionType)condition;

@end
