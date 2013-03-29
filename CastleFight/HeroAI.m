//
//  HeroAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "HeroAI.h"
#import "Character.h"
#import "ActiveSkill.h"
#import "Character.h"
#import "AIState.h"
#import "AIStateHeroIdle.h"
#import "AIStateHeroWalk.h"
@implementation HeroAI


-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState =[[AIStateHeroIdle alloc] init];
        _targetPoint=character.position;
        
    }
    return self;
}
@end
