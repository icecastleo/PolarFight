//
//  AuraComponent.m
//  CastleFight
//
//  Created by  DAN on 13/6/7.
//
//

#import "AuraComponent.h"
#import "Aura.h"

@implementation AuraComponent

-(id)init {
    if (self = [super init]) {
        _auras = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    for (Aura *aura in self.auras.allValues) {
        aura.owner = entity;
    }
}

-(void)process {
    if (self.infinite) {
        self.totalTime = 1;
    }
    for (Aura *aura in self.auras.allValues) {
        [aura activeEffect];
    }
}

@end
