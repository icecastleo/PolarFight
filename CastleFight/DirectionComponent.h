//
//  DirectionComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/9.
//
//

#import "Component.h"

typedef enum {
//    kDirectionNone,
    kDirectionUp = 1,
    kDirectionDown,
    kDirectionLeft,
    kDirectionRight
} Direction;

@interface DirectionComponent : Component

-(id)initWithVelocity:(CGPoint)velocity;

@property (nonatomic) CGPoint velocity;
@property (readonly) Direction direction;

@end
