//
//  CharacterStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import <Foundation/Foundation.h>
#import "ModifierMap.h"
#import "AttributeModifier.h"
#import "AddModifier.h"
#import "MultiplyModifier.h"

// TODO: name & imgFile;
@interface Status : NSObject {
//    StatusType *type;
    int type;
    ModifierMap *modifierMap;
    NSString *name;
    NSString *imgFile;
    BOOL isDead;
}

@property (readonly) int type;
@property (readonly) BOOL isDead;

//-(id) initWithType:(StatusType)statusType;
-(id) initWithType:(int)statusType;
-(float) modifyAttributeValue:(float)value onAttribute:(CharacterAttributeType)attribute onCondition:(ConditionType)condition;

@end
