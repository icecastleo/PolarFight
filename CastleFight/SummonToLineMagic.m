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
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *startValue = [path objectAtIndex:0];
    CGPoint startPoint = startValue.CGPointValue;
    
    TeamComponent *teamCom = (TeamComponent *)[self.owner getComponentOfName:[TeamComponent name]];
    SummonComponent *summonCom = (SummonComponent *)[self.owner getComponentOfName:[SummonComponent name]];
    
    Entity *summonEntity = [self.entityFactory createCharacter:summonCom.data.cid level:summonCom.data.level forTeam:teamCom.team addToMap:NO];
    
    int line = [(ThreeLineMapLayer*)self.entityFactory.mapLayer positionConvertToLine:startPoint];
    [(ThreeLineMapLayer*)self.entityFactory.mapLayer addEntity:summonEntity line:line];
    
}
@end
