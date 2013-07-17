//
//  PhysicsNode.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/12.
//
//

#import "CCNode.h"
#import "DirectionComponent.h"

CLS_DEF(b2Body);

@interface PhysicsNode : CCNode

#ifdef __cplusplus
@property (assign) b2Body *b2Body;
#else
@property (weak) b2Body *b2Body;
#endif

@property float PTMRatio;
@property DirectionComponent *direction;

@end
