//
//  PhysicsSprite.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/15.
//
//

#import "CCSprite.h"
#import "DirectionComponent.h"

CLS_DEF(b2Body);

@interface PhysicsSprite : CCSprite

#ifdef __cplusplus
@property (assign) b2Body *b2Body;
#else
@property (weak) b2Body *b2Body;
#endif

@property float PTMRatio;
@property DirectionComponent *direction;

@end
