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
    }
    return self;
}

-(void)handleDrag:(NSArray *)path {
    CGPoint position = [[path lastObject] CGPointValue];
    RenderComponent *boardRenderCom = (RenderComponent *)[self.board getComponentOfName:[RenderComponent name]];
    
    CGPoint position2 = [boardRenderCom.sprite convertToNodeSpace:position];
    
    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfName:[OrbBoardComponent name]];
    [boardCom moveOrb:self.entity ToPosition:position2];
}

-(void)handleTap:(NSArray *)path {
    [self executeMatch:self.type];
}

-(void)executeMatch:(int)number {
    
//    NSAssert(number >= 3, @"should not call this function when it is less than 3.");
    
//    if (number > 5) {
//        number = 5;
//    }
    
//    NSDictionary *dic = [self.matchInfo objectForKey:[NSString stringWithFormat:@"%d",number]];
    
    //execute a magic method
//    NSString *magicName = [dic objectForKey:@"magicName"];
//    Magic *magic = [[NSClassFromString(magicName) alloc] init];
    Magic *magic = [[SummonToLineMagic alloc] init];
    
    //FIXME: give summon data to magic
//    NSDictionary *summonDic = [dic objectForKey:@"summonData"];
//    SummonComponent
    
    NSMutableDictionary *magicInfo = [[NSMutableDictionary alloc] init];
    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfName:[OrbBoardComponent name]];
    magic.entityFactory = boardCom.entityFactory;
    PlayerComponent *playerCom = (PlayerComponent *)[boardCom.owner getComponentOfName:[PlayerComponent name]];
    
    //test
//    int type = OrbRed + arc4random_uniform(OrbBottom-1);
    int type = 0;
    NSString *summonData = @"SummonData";
    switch (type) {
        case OrbRed:
            [magicInfo setValue:[playerCom.battleTeam objectAtIndex:0] forKey:summonData];
            break;
        case OrbBlue:
            [magicInfo setValue:[playerCom.battleTeam objectAtIndex:1] forKey:summonData];
            break;
        case OrbGreen:
            [magicInfo setValue:[playerCom.battleTeam objectAtIndex:2] forKey:summonData];
            break;
        default:
            [magicInfo setValue:[playerCom.battleTeam objectAtIndex:number] forKey:summonData];
            break;
    }
    
    int testNumber = 3;
    testNumber = 3 + arc4random_uniform(3);
    int addLevel = 0;
    switch (testNumber) {
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
    magic.magicInformation = magicInfo;
    [magic active];
}

@end
