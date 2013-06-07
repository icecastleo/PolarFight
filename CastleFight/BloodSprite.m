//
//  BloodSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "BloodSprite.h"
#import "RenderComponent.h"
#import "DefenderComponent.h"

@implementation BloodSprite

-(id)initWithEntity:(Entity *)entity sprite:(CCSprite *)sprite {
    if (self = [super initWithSprite:sprite]) {
        self.type = kCCProgressTimerTypeBar;
        self.barChangeRate = ccp(1, 0);
        defense = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
        
        NSAssert(defense, @"Invalid entity!");
        
        defense.bloodSprite = self;
        
        // update
        float scale = (float) defense.hp.currentValue / defense.hp.value;
        self.percentage = scale * 100;
    }
    return self;
}

-(void)update {    
    float scale = (float) defense.hp.currentValue / defense.hp.value;
    self.percentage = scale * 100;
}

@end
