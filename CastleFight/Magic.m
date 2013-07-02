//
//  Magic.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/1.
//
//

#import "Magic.h"

@implementation Magic

-(void)active {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

@end
