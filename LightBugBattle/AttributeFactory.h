//
//  AttributeFactory.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/13.
//
//

#import <Foundation/Foundation.h>
#import "Attribute.h"
#import "Constant.h"

@interface AttributeFactory : NSObject

+(Attribute *)createAttributeWithType:(CharacterAttribute)type withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c;

@end
