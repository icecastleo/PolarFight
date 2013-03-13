//
//  BaseAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import "BaseAI.h"
#import "AIState.h"
#import "Character.h"
#import "AIStateWalking.h"
@implementation BaseAI;
@synthesize character;
//@synthesize  _currentState;

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
       //_currentState =[[AIStateWalking alloc] init];
           
    }
    return self;
}

-(void) AIUpdate{
    [_currentState execute:self];
    
}
- (void)changeState:(AIState *)state {
    
    [_currentState exit:self];
    _currentState = state;
    [_currentState enter:self];
    
}
@end
