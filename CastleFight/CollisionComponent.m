//
//  CollisionComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "CollisionComponent.h"
#import "cocos2d.h"

@implementation CollisionComponent

+(NSString *)name {
    static NSString *name = @"CollisionComponent";
    return name;
}

-(id)initWithBoundingBox:(CGRect)boundingBox {
    if (self = [super init]) {
        _points = [NSMutableArray arrayWithObjects:
                      [NSValue valueWithCGPoint:ccp(0, boundingBox.size.height)],
                      [NSValue valueWithCGPoint:ccp(boundingBox.size.width, boundingBox.size.height)],
                      [NSValue valueWithCGPoint:ccp(boundingBox.size.width, 0)],
                      [NSValue valueWithCGPoint:ccp(0, 0)]
                      ,nil];
        
        int count = (int)boundingBox.size.height / kCollisionPointRange;
        
        for (int i = 1; i <= count; i++) {
            [_points addObject:[NSValue valueWithCGPoint:ccp(0, i * kCollisionPointRange)]];
            [_points addObject:[NSValue valueWithCGPoint:ccp(boundingBox.size.width, i * kCollisionPointRange)]];
        }
        
        count = (int)boundingBox.size.width / kCollisionPointRange;
        
        for (int i = 1; i <= count; i++) {
            [_points addObject:[NSValue valueWithCGPoint:ccp(i * kCollisionPointRange, 0)]];
            [_points addObject:[NSValue valueWithCGPoint:ccp(i * kCollisionPointRange, boundingBox.size.height)]];
        }
    }
    return self;
}

@end
