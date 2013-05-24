//
//  PoisonComponent.m
//  CastleFight
//
//  Created by  DAN on 13/5/23.
//
//

#import "PoisonComponent.h"

@implementation PoisonComponent

-(void)processEnity:(Entity *)entity {
    [entity addComponent:self];
}

@end
