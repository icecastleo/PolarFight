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

//test
//#import "AttackBonusMultiplierComponent.h"
#import "ParalysisComponent.h"
#import "PoisonComponent.h"
#import "SpeedBonusAddComponent.h"
#import "StealthComponent.h"
//test

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
    
    //test
    for (Entity *entity in entities) {
        int random = arc4random_uniform(10);
        
        StateComponent *buff = nil;
        StateComponent *buff2 = nil;
        switch (random) {
            case 0:
                buff = [[AttackBonusMultiplierComponent alloc] initWithAttribute:[[Attribute alloc] initWithQuadratic:1 linear:1 constantTerm:1 isFluctuant:1] andBonus:100];
                break;
            case 1:
                buff = [[ParalysisComponent alloc] init];
                break;
            case 2:
                buff = [[PoisonComponent alloc] init];
                break;
            case 3:
                buff = [[AttackBonusMultiplierComponent alloc] initWithAttribute:[[Attribute alloc] initWithQuadratic:1 linear:1 constantTerm:1 isFluctuant:1] andBonus:100];
                break;
            case 4:
                buff = [[SpeedBonusAddComponent alloc] initWithAttribute:[[Attribute alloc] initWithQuadratic:1 linear:1 constantTerm:1 isFluctuant:1] andBonus:100];
                break;
            case 5:
                buff = [[StealthComponent alloc] init];
                break;
            case 6:
                buff = [[ParalysisComponent alloc] init];
                buff2 = [[PoisonComponent alloc] init];
                break;
            default:
                break;
        }
        if (buff) {
            buff.cdTime = 0;
            buff.totalTime = 15;
            [entity addComponent:buff];
        }
        if (buff2) {
            buff2.cdTime = 0;
            buff2.totalTime = 50;
            [entity addComponent:buff2];
        }
    }
    //test
    
    CCLOG(@"~ All Attack Up ~");
}

@end
