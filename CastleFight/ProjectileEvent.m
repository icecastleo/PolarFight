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

-(id)initWithProjectileRange:(ProjectileRange *)range type:(ProjectileType)type startPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition time:(float)time block:(void (^)(NSArray *entities, CGPoint position))block {
    
    if (self = [super init]) {
        NSAssert(startPosition.x != endPosition.x || startPosition.y != endPosition.y, @"Please set different position for start and end!");
        
        _range = range;
        _type = type;
        _startPosition = startPosition;
        _endPosition = endPosition;
        _time = time;
        _block = block;
    }
    return self;
}

-(BOOL)isPiercing {
    return _range.isPiercing;
}

@end
