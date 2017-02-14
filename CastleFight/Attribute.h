//
//  Attribute.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import "FluctuantAttribute.h"


@class Character;

@interface Attribute : NSObject {
    float quadratic;
    float linear;
    float constantTerm;
    
    float baseValue;
    float bonus;
    float multiplier;
        
    FluctuantAttribute *fluctuant;
}

@property (readonly) int value;
@property int currentValue;

// Init with a quadratic equation.
-(id)initWithQuadratic:(float)a linear:(float)b constantTerm:(float)c isFluctuant:(BOOL)fluctuant;
-(id)initWithDictionary:(NSDictionary *)dic;

-(void)addBonus:(float)aBonus;
-(void)subtractBonus:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;
-(int)valueWithLevel:(int)level;
-(void)updateValueWithLevel:(int)level;

@end
