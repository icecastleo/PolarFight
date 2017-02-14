//
//  AddManaByItem.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/17.
//
//

#import "AddManaByItem.h"

@implementation AddManaByItem

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
    }
    return self;
}

-(void)active {
    [self.owner sendEvent:kEventManaChanged Message:[NSNumber numberWithInt:100]];
    CCLOG(@"~ Add Mana By Item ~");
}

@end
