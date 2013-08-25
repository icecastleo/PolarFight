//
//  OrbComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbComponent.h"
#import "OrbBoardComponent.h"
#import "RenderComponent.h"
#import "PlayerComponent.h"
#import "Magic.h"

#import "SummonToLineMagic.h"

@implementation OrbComponent

+(NSString *)name {
    static NSString *name = @"OrbComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _matchInfo = dic;
        _position = CGPointMake(0, 0);
    }
    return self;
}

//-(void)handlePan:(NSArray *)path {
//    CGPoint position = [[path lastObject] CGPointValue];
//    RenderComponent *boardRenderCom = (RenderComponent *)[self.board getComponentOfName:[RenderComponent name]];
//    
//    CGPoint position2 = [boardRenderCom.sprite convertToNodeSpace:position];
//    
//    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfName:[OrbBoardComponent name]];
//    [boardCom moveOrb:self.entity ToPosition:position2];
//}
//
//-(void)handleTap {
//    
//}




//*
-(void)handlePan:(NSArray *)path {
    CGPoint position = [[path lastObject] CGPointValue];
    [self.board moveOrb:self.entity ToPosition:position];
}

-(void)handleTap {
    NSArray *matchArray = [self.board findMatchFromPosition:self.position CurrentOrb:self.entity];
    if (matchArray.count >= 3) {
        [self executeMatch:matchArray.count];
        [self.board matchClean:matchArray];
    }
}

-(void)executeMatch:(int)number {
    
    
    PlayerComponent *playerCom = (PlayerComponent *)[self.board.owner getComponentOfName:[PlayerComponent name]];
    
    NSMutableDictionary *magicInfo = [[NSMutableDictionary alloc] init];
    NSString *summonData = @"SummonData";
    [magicInfo setValue:[playerCom.battleTeam objectAtIndex:self.type] forKey:summonData];
    
    int addLevel = 0;
    switch (number) {
        case 4:
            addLevel += 1;
            break;
        case 5:
            addLevel += 2;
            break;
        default:
            break;
    }
    [magicInfo setValue:[NSNumber numberWithInt:addLevel] forKey:@"addLevel"];
    //test
    Magic *magic = [[SummonToLineMagic alloc] initWithMagicInformation:magicInfo];
    magic.entityFactory = self.board.entityFactory;
    [magic active];
}
//*/

@end
