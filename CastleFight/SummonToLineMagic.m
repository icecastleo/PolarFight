//
//  SummonToLineMagic.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/6.
//
//

#import "SummonToLineMagic.h"
#import "SummonComponent.h"
#import "TeamComponent.h"
#import "ThreeLineMapLayer.h"

@implementation SummonToLineMagic

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
    
//    NSArray *path = [self.magicInformation objectForKey:@"path"];
//    NSValue *endValue = [path lastObject];
//    CGPoint endPosition = endValue.CGPointValue;
    
//    TeamComponent *teamCom = (TeamComponent *)[self.owner getComponentOfName:[TeamComponent name]];
    
    SummonComponent *summonCom = [self.magicInformation objectForKey:@"SummonData"];
    if (!summonCom) {
        return;
    }
    NSNumber *addLevel = [self.magicInformation objectForKey:@"addLevel"];
    [self.entityFactory createCharacter:summonCom.data.cid level:summonCom.data.level + addLevel.intValue forTeam:kPlayerTeam];
}
@end
