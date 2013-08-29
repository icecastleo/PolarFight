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

-(void)handlePan:(TouchState)state positions:(NSArray *)positions {
    if (state == kTouchStateMoved) {
        CGPoint position = [[positions lastObject] CGPointValue];
        [self.board moveOrb:self.entity toPosition:position];
    }
}

-(void)handleTap {
    NSArray *matchArray = [self.board findMatchForOrb:self.entity];
    if (matchArray.count >= 3) {
        [self executeMatch:matchArray.count];
        [self.board matchClean:matchArray];
    }
}

-(void)executeMatch:(int)number {
    PlayerComponent *playerCom = (PlayerComponent *)[self.board.owner getComponentOfName:[PlayerComponent name]];
    
    NSMutableDictionary *magicInfo = [[NSMutableDictionary alloc] init];
    [magicInfo setValue:[playerCom.battleTeam objectAtIndex:self.type] forKey:@"SummonData"];
    
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

@end
