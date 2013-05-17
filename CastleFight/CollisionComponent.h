//
//  CollisionComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "Component.h"

@interface CollisionComponent : Component

@property NSMutableArray *points;

-(id)initWithBoundingBox:(CGRect)boundingBox;

@end
