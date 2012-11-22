//
//  MultiplyModifier.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/16.
//
//

#import "AttributeModifier.h"

@interface MultiplyModifier : AttributeModifier {
    float mutiplier;
}
+(id)modifierWithValue:(float)value;
-(id)initWithValue:(float)value;

@end
