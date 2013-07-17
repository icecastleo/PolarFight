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
    kDirectionTypeLeftRight,
    kDirectionTypeUpDown,
    kDirectionTypeFourSides,
    kDirectionTypeAllSides
} DirectionType;

typedef enum {
//    kDirectionNone,
    kDirectionUp = 1,
    kDirectionDown,
    kDirectionLeft,
    kDirectionRight
} Direction;

typedef enum {
    kSpriteDirectionRight = 0,
    kSpriteDirectionUp = 90,
    kSpriteDirectionLeft = 180,
    kSpriteDirectionDown = 270,
    kSpriteDirectionNone = 360,
} SpriteDirection;

@interface DirectionComponent : Component

-(id)initWithVelocity:(CGPoint)velocity;

// Default face or attack degree
@property int spriteDirection;

@property DirectionType type;
@property (nonatomic) CGPoint velocity;
@property (readonly) Direction direction;

@property (readonly) float radians;
@property (readonly) float cocosDegrees;

@end
