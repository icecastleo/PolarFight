//
//  SimpleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import "SimpleAI.h"
#import "Character.h"
#import "ActiveSkill.h"
#import "Character.h"
#import "AIState.h"
#import "AIStateWalking.h"
@implementation SimpleAI


-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState =[[AIStateWalking alloc] init];
        
    }
    return self;
}
@end
