//
//  ExpendableAttribute.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/13.
//
//

#import "Attribute.h"

// For attributes liked hp or mp that will expend and recover during the game.

@interface FluidAttribute : Attribute {
    int currentValue;
}

-(id)initWithQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c;
-(void)adjustValue:(int)aValue;

@end
