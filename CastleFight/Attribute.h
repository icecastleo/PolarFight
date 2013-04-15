//
//  Attribute.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import "DependentAttribute.h"


@class Character;

@interface Attribute : NSObject {
    float quadratic;
    float linear;
    float constantTerm;
    
    float baseValue;
    float bonus;
    float multiplier;
    
    int _value;
}

@property (readonly) CharacterAttributeType type;
@property (readonly) int value;

@property (readonly, strong) DependentAttribute *dependent;
@property int currentValue;

// Init with a quadratic equation.
-(id)initWithType:(CharacterAttributeType)aType withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c;
-(id)initWithDictionary:(NSDictionary *)dic;

-(void)addBonus:(float)aBonus;
-(void)subtractBonus:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;
-(int)valueWithLevel:(int)level;
-(void)updateValueWithLevel:(int)level;

@end
