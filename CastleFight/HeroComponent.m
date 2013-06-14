//
//  HeroComponent.m
//  CastleFight
//
//  Created by  DAN on 13/6/14.
//
//

#import "HeroComponent.h"
#import "TeamComponent.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"

@interface HeroComponent()
@property (nonatomic, readonly) NSString *cid;
@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) int team;
@end

@implementation HeroComponent

-(id)initWithCid:(NSString *)cid Level:(int)level Team:(int)team {
    if (self = [super init]) {
        _cid = cid;
        _level = level;
        _team = team;
    }
    return self;
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == KEventDead){
        [self performSelector:@selector(reSummon) withObject:nil afterDelay:5*self.level];
    }
}

-(void)reSummon {
    NSArray *array = [self.entity getAllEntitiesPosessingComponentOfClass:[PlayerComponent class]];

    PlayerComponent *playerCom;
    for (Entity *entity in array) {
        TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
        
        if (teamCom.team == self.team) {
            playerCom = (PlayerComponent *)[entity getComponentOfClass:[PlayerComponent class]];
            break;
        }
    }
    for (SummonComponent *summonCom in playerCom.battleTeam) {
        if ([summonCom.data.cid isEqualToString:self.cid]) {
            summonCom.summon = YES;
            break;
        }
    }
}

@end
