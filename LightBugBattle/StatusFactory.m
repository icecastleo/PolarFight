//
//  StatusFactory.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/8.
//
//

#import "StatusFactory.h"

@implementation StatusFactory

+(Status*)createTimeStatus:(StatusType)type onCharacter:(Character *)character withTime:(int)time {
    switch (type) {
        case statusPoison:
                
            break;
            
        default:
            break;
    }
    return nil;
}

+(Status*)createAuraStatus:(StatusType)type onCharacter:(Character *)character withCaster:(Character *)caster {
    return nil;
}

@end
