//
//  CostComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "CostComponent.h"

@implementation CostComponent

//-(id)init {
//    if (self = [super init]) {
//        _resources = [[NSMutableDictionary alloc] init];
//    }
//    return self;
//}

-(id)initWithFood:(int)food mana:(int)mana {
    if (self = [super init]) {
        _food = food;
        _mana = mana;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _food = [[dic objectForKey:@"food"] intValue];
        _mana = [[dic objectForKey:@"mana"] intValue];
        _type = [self covertToCostTypeFromNSString:[dic objectForKey:@"costType"]];
    }
    return self;
}

-(BOOL)isCostSufficientWithFood:(int)food Mana:(int)mana {
    
    BOOL isCostSufficient = NO;
    
    switch (self.type) {
        case kCostTypeFood:
            if (food >= self.food) {
                isCostSufficient = YES;
            }
            break;
        case kCostTypeMana:
            if (mana >= self.mana) {
                isCostSufficient = YES;
            }
            break;
        case kCostTypeFoodAndMana:
            if (food >= self.food && mana >= self.mana) {
                isCostSufficient = YES;
            }
            break;
        default:
            break;
    }
    
    return isCostSufficient;
}

-(CostType)covertToCostTypeFromNSString:(NSString *)typeString {
    CostType type = kCostTypeNull;
    
    if ([typeString isEqualToString:@"Food"]) {
        type = kCostTypeFood;
    }else if([typeString isEqualToString:@"Mana"]) {
        type = kCostTypeMana;
    }else if([typeString isEqualToString:@"FoodAndMana"])  {
        type = kCostTypeFoodAndMana;
    }
    
    NSAssert(type != kCostTypeNull, @"You should set correct type");
    
    return type;
}

@end
