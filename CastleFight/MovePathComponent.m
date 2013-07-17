//
//  MovePathComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/19.
//
//

#import "MovePathComponent.h"

@implementation MovePathComponent

-(id)initWithMovePath:(NSArray *)path {
    if (self = [super init]) {
        _path = [NSMutableArray arrayWithArray:path];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEventReceiveDamage){
        [self.path removeAllObjects];
    }
}

-(CGPoint)nextPositionFrom:(CGPoint)currentPosition {
    
    int i = 0;
    for (; i < self.path.count; i++) {
        CGPoint position = [(NSValue *)[self.path objectAtIndex:i] CGPointValue];
        if ([self isPositionEqualAPosition:position BPosition:currentPosition]) {
            break;
        }
    }
    
    if (i < self.path.count) {
        for (int j=0; j<=i; j++) {
            [self.path removeObjectAtIndex:j];
        }
    }
    
    if (self.path.count < 1) {
        return currentPosition;
    }
    
    CGPoint nextPosition = [(NSValue *)[self.path objectAtIndex:0] CGPointValue];
    
    return nextPosition;
}

-(BOOL)isPositionEqualAPosition:(CGPoint)aPosition BPosition:(CGPoint)bPosition {
    /*/
    if (CGPointEqualToPoint(aPosition, bPosition)) {
        return YES;
    }else {
        return NO;
    }
    
    /*/ //another only compare x.
    if (fabs(aPosition.x - bPosition.x) < 10) {
        return YES;
    }else {
        return NO;
    }
    //*/
}

@end
