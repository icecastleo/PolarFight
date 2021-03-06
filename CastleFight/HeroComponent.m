//
//  HeroComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/14.
//
//

#import "HeroComponent.h"
#import "TeamComponent.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "DamageEvent.h"

@interface HeroComponent()
@property (nonatomic, readonly) NSString *cid;
@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) int team;
@end

@implementation HeroComponent

+(NSString *)name {
    static NSString *name = @"HeroComponent";
    return name;
}

-(id)initWithCid:(NSString *)cid Level:(int)level Team:(int)team {
    if (self = [super init]) {
        _cid = cid;
        _level = level;
        _team = team;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead){
        [self performSelector:@selector(reSummon) withObject:nil afterDelay:5*self.level];
    } else if (type == kEventReceiveDamageEvent) {
        DamageEvent *event = (DamageEvent *)message;
        RenderComponent *renderComAttacker = (RenderComponent *)[event.sender getComponentOfName:[RenderComponent name]];
        RenderComponent *renderComSelf = (RenderComponent *)[event.receiver getComponentOfName:[RenderComponent name]];
        DirectionComponent *directionComSelf = (DirectionComponent *)[event.receiver getComponentOfName:[DirectionComponent name]];
        
        CGPoint direction = ccpNormalize(ccpSub(renderComAttacker.position, renderComSelf.position));
        
        if (directionComSelf) {
            Direction oldDirection = directionComSelf.direction;
            directionComSelf.velocity = direction;
            Direction newDirection = directionComSelf.direction;
            
            if (oldDirection != newDirection) {
                [renderComSelf flip:newDirection];
            }
        }
    }
}

-(void)reSummon {
//    NSArray *array = [self.entity getAllEntitiesPosessingComponentOfName:[PlayerComponent name]];
//
//    for (Entity *entity in array) {
//        TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
//        
//        if (teamCom.team == self.team) {
//            PlayerComponent *playerCom = (PlayerComponent *)[entity getComponentOfName:[PlayerComponent name]];
//            
//            for (SummonComponent *summonCom in playerCom.battleTeam) {
//                if ([summonCom.data.cid isEqualToString:self.cid]) {
//                    summonCom.summon = YES;
//                }
//            }
//            break;
//        }
//    }
}

@end
