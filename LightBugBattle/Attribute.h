//
//  Attribute.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import "DependentAttribute.h"
#import "xmlParsing.h"

@class Character;

@interface Attribute : NSObject <xmlParsing> {
    float quadratic;
    float linear;
    float constantTerm;
    
    int baseValue;
    int bonus;
    float multiplier;
}

@property (readonly) CharacterAttributeType type;
@property (readonly) int value;
@property (strong) DependentAttribute *dependent;
@property (readonly) int currentValue;

// Init with a quadratic equation.
-(id)initWithType:(CharacterAttributeType)aType withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c;
-(void)addBonus:(int)aBonus;
-(void)subtractBonus:(int)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;
-(void)updateValueWithLevel:(int)level;

-(void)increaseCurrentValue:(int)aValue;
-(void)decreaseCurrentValue:(int)aValue;

-(id)initWithXmlElement:(GDataXMLElement *)aElement;

@end
