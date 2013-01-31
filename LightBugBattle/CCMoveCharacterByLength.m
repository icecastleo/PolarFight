//
//  CCMoveCharacterByLength.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "CCMoveCharacterByLength.h"
#import "BattleController.h"
#import "Character.h"

@implementation CCMoveCharacterByLength

+(id)actionWithDuration:(ccTime)t character:(Character *)aCharacter length:(float)aLength {
	return [[self alloc] initWithDuration:t character:aCharacter length:aLength];
}

-(id)initWithDuration:(ccTime)t character:(Character *)aCharacter length:(float)aLength {
	if((self = [super initWithDuration: t])) {
        character = aCharacter;
		length = aLength;
    }
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] character:character length:length];
	return copy;
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ character:character length: -length];
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	elapse = 0;
}

-(void) update: (ccTime) t
{
    ccTime deltaTime = t - elapse;
    
    [[BattleController currentInstance] moveCharacter:character byPosition:ccpMult(character.direction, length * deltaTime)];
    
    elapse = t;
}

@end
