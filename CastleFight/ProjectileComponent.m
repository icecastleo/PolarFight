//
//  ProjectileComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileComponent.h"

@implementation ProjectileComponent

+(NSString *)name {
    static NSString *name = @"ProjectileComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        _projectileEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
