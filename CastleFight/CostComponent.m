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

@end
