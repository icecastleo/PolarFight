//
//  CCMapMoveTo.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/31.
//
//

#import "CCMoveCharacterTo.h"
#import "BattleController.h"
#import "Character.h"

@implementation CCMoveCharacterTo

+(id)actionWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p {
	return [[self alloc] initWithDuration:t character:aCharacter position:p];
}

-(id)initWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p;
{
	if((self = [super initWithDuration: t])) {
        character = aCharacter;
		endPosition_ = p;
    }
    
	return self;
}

-(id)copyWithZone:(NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] position: endPosition_];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	delta_ = ccpSub( endPosition_, [(CCNode*)target_ position]);
    elapse = 0;
}

-(void) update: (ccTime) t
{
    ccTime deltaTime = t - elapse;
    
    [[BattleController currentInstance] moveCharacter:character byPosition:ccpMult(delta_, deltaTime) isMove:NO];
    
    elapse = t;
}

@end
