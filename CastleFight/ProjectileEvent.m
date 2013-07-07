//
//  ProjectileEvent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileEvent.h"

@implementation ProjectileEvent

@dynamic isPiercing;

-(id)initWithProjectileRange:(ProjectileRange *)range type:(ProjectileType)type startWorldPosition:(CGPoint)startWorldPosition endWorldPosition:(CGPoint)endWorldPosition time:(float)time block:(void (^)(NSArray *entities, CGPoint position))block {
    
    if (self = [super init]) {
        NSAssert(startWorldPosition.x != endWorldPosition.x || startWorldPosition.y != endWorldPosition.y, @"Please set different position for start and end!");
        
        _range = range;
        _type = type;
        _startWorldPosition = startWorldPosition;
        _endWorldPosition = endWorldPosition;
        _time = time;
        _block = block;
    }
    return self;
}

-(BOOL)isPiercing {
    return _range.isPiercing;
}

@end
