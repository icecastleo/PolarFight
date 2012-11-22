//
//  AddModifier.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/16.
//
//

#import "AttributeModifier.h"

@interface AddModifier : AttributeModifier {
    float add;
}
+(id)modifierWithValue:(float)value;
-(id)initWithValue:(float)value;

@end
