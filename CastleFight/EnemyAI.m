//
//  CastleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "EnemyAI.h"
#import "AIStateCastleWaiting.h"
@implementation EnemyAI

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState =[[AIStateCastleWaiting alloc] init];
        mutableDictionary = [NSMutableDictionary new];
        
    }
    return self;
}

-(void) initMosterData{
    NSArray *monster1Array =[NSArray arrayWithObjects:
                             [NSNumber numberWithInt:10],
                             [NSNumber numberWithInt:8],nil];
    NSArray *monster2Array =[NSArray arrayWithObjects:
                             [NSNumber numberWithInt:30],
                             [NSNumber numberWithInt:3],nil];
    [mutableDictionary setObject:monster1Array forKey:@"Monster1"];
    [mutableDictionary setObject:monster2Array forKey:@"Monster2"];
    
}

@end
