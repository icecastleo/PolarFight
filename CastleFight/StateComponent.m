//
//  StateComponent.m
//  CastleFight
//
//  Created by  DAN on 13/5/24.
//
//

#import "StateComponent.h"

@implementation StateComponent

-(void)processEnity:(Entity*)entity {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

@end
