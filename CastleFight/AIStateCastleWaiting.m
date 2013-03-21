//
//  AIStateCastleWaiting.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "AIStateCastleWaiting.h"
#import "EnemyAI.h"
#import "Character.h"
#import "BattleController.h"
#import "EnemyAIData.h"
@implementation AIStateCastleWaiting

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    EnemyAI *a = (EnemyAI*)ai;
    if(a.nextMonster!=nil)
    {
        if(a.nextMonster.summonCost<=a.food){
            Character *next = [self newMonster:a.nextMonster.Name];
            [[BattleController currentInstance] addCharacter:next];
            a.food-=a.nextMonster.summonCost;
            a.nextMonster=nil;
            
        }
        
    }
    
    
    // TODO: Food Supply
    
    if(CACurrentMediaTime()>nextDecisionTime)
    {
        //examine once a sec
        if(a.nextMonster==nil){

            a.nextMonster= [self examineNextMonster:ai];
            
        }
        nextDecisionTime=CACurrentMediaTime()+1;
        a.food+=a.foodSupplySpeed;
    }
    
}

-(Character*) newMonster:(NSString*)monsterID
{
    
    Character* character = [[Character alloc] initWithId:monsterID andLevel:1];
    character.player=2;
    return character;
}

-(MonsterData*) examineNextMonster:(BaseAI *)ai
{
    
    EnemyAI *a = (EnemyAI*)ai;
   
    MonsterDataCollection* dic = [a getCurrentMonsters];
    
    return [dic getNextMonster];
 
}

-(bool) examineTempInt:(NSArray*)compare1 another:(NSArray*)compare2
{
    
    
    if(compare1.count!=compare2.count)
        return NO;
    for (int i =0; i<compare1.count; i++) {
        if([[compare1 objectAtIndex:i] integerValue]<[[compare2 objectAtIndex:i] integerValue])
            return NO;
    }
    return YES;
}

@end
