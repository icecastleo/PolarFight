//
//  AllAttackUp.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/17.
//
//

#import "AllAttackUp.h"
#import "AttackerComponent.h"
#import "AttackBonusMultiplierComponent.h"
#import "Attribute.h"
#import "TeamComponent.h"

@implementation AllAttackUp

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
    }
    return self;
}

-(void)active {
    NSArray *entities = [self.owner getAllEntitiesPosessingComponentOfName:[AttackerComponent name]];
    
    for (Entity *entity in entities) {
        AttackBonusMultiplierComponent *component = (AttackBonusMultiplierComponent *)[entity getComponentOfName:[AttackBonusMultiplierComponent name]];
        if (component)
            continue;
        TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        if (teamCom.team != kPlayerTeam)
            continue;
        
        AttackerComponent *receiver = (AttackerComponent *)[entity getComponentOfName:[AttackerComponent name]];
        component = [[AttackBonusMultiplierComponent alloc] initWithAttribute:receiver.attack andBonus:1.2f];
        component.cdTime = 0;
        component.totalTime = 15;
        [entity addComponent:component];
    }
    CCLOG(@"~ All Attack Up ~");
}

@end
