//
//  MinionAIState.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/16.
//
//

#import "AIState.h"
#import "cocos2d.h"
@class Entity;

@interface MinionAIState : AIState {

}

@property (weak, readonly) Entity *general;

-(id)initWithGeneral:(Entity *)general;

@end
