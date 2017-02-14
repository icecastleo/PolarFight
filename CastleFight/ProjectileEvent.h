//
//  ProjectileEvent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "DirectionComponent.h"
#import "cocos2d.h"
#import "Range.h"

typedef enum {
    kProjectileTypeInstant,
    kProjectileTypeLine,
    kProjectileTypeParabola,
} ProjectileType;

@interface ProjectileEvent : NSObject

@property CCSprite *sprite;
@property SpriteDirection spriteDirection;

@property ProjectileType type;

@property CGPoint startPosition;
@property CGPoint finishPosition;
@property ccTime duration;

@property CCAction *startAction;
@property CCFiniteTimeAction *finishAction;

@property Range *range;
@property (strong) void (^block)(NSArray *entities, CGPoint position);

@property BOOL isPiercing;

-(CCAction *)createProjectileAction;

@end
