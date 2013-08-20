//
//  AuraComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/7.
//
//

#import "AuraComponent.h"
#import "ActiveSkill.h"

@implementation AuraComponent

+(NSString *)name {
    static NSString *name = @"AuraComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        _auras = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    for (ActiveSkill *aura in self.auras.allValues) {
        aura.owner = entity;
    }
}

-(void)process {
    if (self.infinite) {
        self.totalTime = 1;
    }
    
    for (ActiveSkill *aura in self.auras.allValues) {
        [aura activeEffect];
    }
}

@end
