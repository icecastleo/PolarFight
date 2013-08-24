//
//  SummonMagic.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/5.
//
//

#import "SummonMagic.h"
#import "SummonComponent.h"
#import "TeamComponent.h"

@implementation SummonMagic

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
    }
    return self;
}

-(void)active {
    if (!self.entityFactory.mapLayer || !self.magicInformation) {
        return;
    }
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *endValue = [path lastObject];
    CGPoint endPosition = endValue.CGPointValue;
    
    TeamComponent *teamCom = (TeamComponent *)[self.owner getComponentOfName:[TeamComponent name]];
    SummonComponent *summonCom = (SummonComponent *)[self.owner getComponentOfName:[SummonComponent name]];
    Entity *summonEntity = [self.entityFactory createCharacter:summonCom.data.cid level:summonCom.data.level forTeam:teamCom.team addToMap:NO];
    
    [self.entityFactory.mapLayer addEntity:summonEntity toPosition:endPosition];
}

@end
