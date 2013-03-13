//
//  CastleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "CastleAI.h"
#import "AIStateCastleWaiting.h"
@implementation CastleAI

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState =[[AIStateCastleWaiting alloc] init];
        
    }
    return self;
}

@end
