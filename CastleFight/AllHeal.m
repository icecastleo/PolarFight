//
//  AllHeal.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/11.
//
//

#import "AllHeal.h"
#import "DefenderComponent.h"
#import "Attribute.h"
#import "TeamComponent.h"

@implementation AllHeal

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
//        NSDictionary *images = [self.magicInformation objectForKey:@"images"];
//        CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
//        self.rangeSize = CGSizeMake(sprite.boundingBox.size.width*2, sprite.boundingBox.size.width*2);
    }
    return self;
}

-(void)active {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfName:[DefenderComponent name]];
    
    for (Entity *entity in entities) {
        TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        if (teamCom.team != kPlayerTeam)
            continue;
        DefenderComponent *defenderCom = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
        Attribute *hp = defenderCom.hp;
        
        [hp addBonus:100.0];
        NSLog(@"hp : %d, chp: %d",hp.value,hp.currentValue);
    }
    
    CCLOG(@"~ All Heal ~");
}

@end
