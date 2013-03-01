//
//  CCBattleMoveBy.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/31.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "CCMoveCharacterBy.h"
#import "BattleController.h"
#import "Character.h"

@implementation CCMoveCharacterBy

+(id)actionWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p
{
	return [[self alloc] initWithDuration:t character:aCharacter position:(CGPoint)p];
}

-(id)initWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p
{
	if((self = [super initWithDuration: t])) {
        character = aCharacter;
		delta_ = p;
    }

	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] position: delta_];
	return copy;
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ character:character position:ccp( -delta_.x, -delta_.y)];
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	elapse = 0;
}

-(void) update: (ccTime) t
{
    ccTime deltaTime = t - elapse;
    
    [[BattleController currentInstance] moveCharacter:character byPosition:ccpMult(delta_, deltaTime) isMove:NO];
    
    elapse = t;
}

@end
