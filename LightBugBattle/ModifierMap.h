//
//  ModifierMap.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/17.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "AttributeModifier.h"

@interface ModifierMap : NSObject {
    NSMutableDictionary *map;
}

-(id)init;

-(void)addAttributeModifier:(AttributeModifier*)modifier toAttribute:(CharacterAttribute)attribute onCondition:(ConditionType)condition;
-(float)modifyAttributeValue:(float)value onAttribute:(CharacterAttribute)attribute onCondition:(ConditionType)condition;

@end
