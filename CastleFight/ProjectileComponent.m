//
//  ProjectileComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileComponent.h"

@implementation ProjectileComponent

-(id)init {
    if (self = [super init]) {
        _projectileEventQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
