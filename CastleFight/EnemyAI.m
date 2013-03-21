//
//  CastleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "EnemyAI.h"
#import "AIStateCastleWaiting.h"
#import "Character.h"
#import "BattleController.h"
@implementation EnemyAI

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState =[[AIStateCastleWaiting alloc] init];
        _mutableDictionary = [NSMutableDictionary new];
        [self initMosterData];
        _foodSupplySpeed= 0.8;
    }
    return self;
}
// TODO: Get Data from Dan
-(void) initMosterData{
    NSMutableArray *monster1Array =[NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:0.25],
                             [NSNumber numberWithInt:0],nil];
    NSMutableArray *monster2Array =[NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:0.75],
                             [NSNumber numberWithInt:0],nil];
    [_mutableDictionary setObject:monster1Array forKey:@"001"];
    [_mutableDictionary setObject:monster2Array forKey:@"002"];
    
}

-(NSMutableDictionary*) getCurrentMonsters
{
    for (NSString* key in _mutableDictionary) {
        NSMutableArray* s =(NSMutableArray*)[_mutableDictionary objectForKey:key];
        [s replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:0]];
    }
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if(temp.player==2)
        {
            NSMutableArray* s =[_mutableDictionary objectForKey:temp.characterId];
           NSInteger count= [[s objectAtIndex:1] integerValue]+1;
            [s replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:count]];
        }
    
    }
    return _mutableDictionary;
}

@end
