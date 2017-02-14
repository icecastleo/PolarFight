//
//  AnimationComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"

typedef enum {
    kAnimationStateNone,
    kAnimationStateIdel,
    kAnimationStateMove,
    kAnimationStateAttack,
    kAnimationStateDead,
} CFAnimationState;

@interface AnimationComponent : Component {
    
}

@property (readonly) NSMutableDictionary *animations;
@property CFAnimationState state;

-(id)initWithAnimations:(NSMutableDictionary *)animations;

@end
