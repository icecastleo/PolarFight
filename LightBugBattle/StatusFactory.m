//
//  StatusFactory.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/8.
//
//

#import "StatusFactory.h"
#import "PoisonStatus.h"
#import "AttackBuffStatus.h"

@implementation StatusFactory

+(TimeStatus*)createTimeStatus:(TimeStatusType)type withTime:(int)time toCharacter:(Character*)character{
//    NSAssert(type < statusTypeLine, ([NSString stringWithFormat:@"%d is not a time status",type]));
    switch (type) {
        case statusPoison:
            return [[PoisonStatus alloc] initWithType:statusPoison withTime:time toCharacter:character];
            
        default:
            [NSException raise:@"Create status failed." format:@"No such status."];
//            break;
    }
    
//    return nil;
}

+(AuraStatus*)createAuraStatus:(AuraStatusType)type withCaster:(Character *)caster {
//    NSAssert(type > statusTypeLine, ([NSString stringWithFormat:@"%d is not a aura status",type]));
    switch (type) {
        case statusAttackBuff:
            return [[AttackBuffStatus alloc] initWithCaster:caster];
//            break;
        default:
            break;
    }
    [NSException raise:@"Create status failed." format:@"No such status."];
//    return nil;
}

@end
