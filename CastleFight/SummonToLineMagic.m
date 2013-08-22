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
//    NSValue *startValue = [path objectAtIndex:0];
//    CGPoint startPoint = startValue.CGPointValue;
    
//    TeamComponent *teamCom = (TeamComponent *)[self.owner getComponentOfName:[TeamComponent name]];
    
    SummonComponent *summonCom = [self.magicInformation objectForKey:@"SummonData"];
    
    NSNumber *addLevel = [self.magicInformation objectForKey:@"addLevel"];
    
//    SummonComponent *summonCom = (SummonComponent *)[self.owner getComponentOfName:[SummonComponent name]];
    
    Entity *summonEntity = [self.entityFactory createCharacter:summonCom.data.cid level:summonCom.data.level + addLevel.intValue forTeam:1 addToMap:NO];
    
    NSLog(@"summondata:: cid: %@, level: %d",summonCom.data.cid,summonCom.data.level + addLevel.intValue);
    
//    int line = [(ThreeLineMapLayer*)self.entityFactory.mapLayer positionConvertToLine:startPoint];
    int line = arc4random_uniform(kMapPathMaxLine);
    [(ThreeLineMapLayer*)self.entityFactory.mapLayer addEntity:summonEntity line:line];
    
}
@end
