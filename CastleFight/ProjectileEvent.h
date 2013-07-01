//
//  ProjectileEvent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import <Foundation/Foundation.h>
#import "ProjectileRange.h"

typedef enum {
    kProjectileTypeLine,
    kProjectileTypeParabola,
} ProjectileType;

@class CCFiniteTimeAction;

@interface ProjectileEvent : NSObject

@property (readonly) ProjectileRange *range;
@property (readonly) BOOL isPiercing;
@property (readonly) ProjectileType type;
@property (readonly) CGPoint startPosition;
@property (readonly) CGPoint endPosition;
@property (readonly) float time;
@property (readonly) void (^block)(NSArray *entities, CGPoint position);

@property (nonatomic) CCFiniteTimeAction *middleAction;
@property (nonatomic) CCFiniteTimeAction *finishAction;
@property (nonatomic) BOOL isFinish;

-(id)initWithProjectileRange:(ProjectileRange *)range type:(ProjectileType)type startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition time:(float)time block:(void(^)(NSArray *entities, CGPoint position))block;

@end
