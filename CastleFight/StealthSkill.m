//
//  StealthSkill.m
//  CastleFight
//
//  Created by  DAN on 13/6/11.
//
//

#import "StealthSkill.h"
#import "StealthComponent.h"

@implementation StealthSkill

-(id)init {
    if (self = [super init]) {
        self.cooldown = 11;
    }
    return self;
}

-(void)activeEffect {
    
    StealthComponent *stealthComponent = (StealthComponent *)[self.owner getComponentOfClass:[StealthComponent class]];
    
    if (stealthComponent) {
        return;
    }
    
    stealthComponent = [[StealthComponent alloc] init];
    stealthComponent.cdTime = 10;
    stealthComponent.totalTime = 10;
    [self.owner addComponent:stealthComponent];
}

/*//
 
 StealthComponent *stealthComponent = [[StealthComponent alloc] init];
 stealthComponent.cdTime = 100;
 stealthComponent.totalTime = 100;
 [entity addComponent:stealthComponent];
//*/
@end
