//
//  AllCleanse.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/17.
//
//

#import "AllCleanse.h"
#import "CharacterComponent.h"
#import "TeamComponent.h"
#import "ParalysisComponent.h"
#import "PoisonComponent.h"

@implementation AllCleanse

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
    }
    return self;
}

-(void)removeComponent:(NSString *)componentName {
    NSArray *entities = [self.owner getAllEntitiesPosessingComponentOfName:componentName];
    for (Entity *entity in entities) {
        TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        if (teamCom.team != kPlayerTeam)
            continue;
        
        StateComponent *stateComponent = (StateComponent *)[entity getComponentOfName:componentName];
        CCLOG(@"team:%d entity:%d remove:%@",teamCom.team,entity.eid,[[stateComponent class] name]);
        [entity removeComponent:[[stateComponent class] name]];
    }
}

-(void)active {
    [self removeComponent:[ParalysisComponent name]];
    [self removeComponent:[PoisonComponent name]];
    CCLOG(@"~ All Cleanse ~");
}

@end
