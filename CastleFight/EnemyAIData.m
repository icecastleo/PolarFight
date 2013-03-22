//
//  EnemyAIData.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/21.
//
//

#import "EnemyAIData.h"

@implementation EnemyAIData

-(id) init
{
    if (self = [super init]) {
        _monsterDataCollection= [[MonsterDataCollection alloc] init];
    }
    return self;
}
@end

@implementation MonsterDataCollection

-(id) init
{
    if (self = [super init]) {
        monsterData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) addMonsterDataObject:(MonsterData *)object
{
    [monsterData setValue:object forKey:object.characterId];
}

-(MonsterData*) getMonsterData:(NSString *)name
{
    return (MonsterData*)[monsterData objectForKey:name];
}
-(void) clearCurrentMonsters
{
    for (NSString* key in monsterData) {
        MonsterData *md = [monsterData objectForKey:key];
        md.currentCount=0;
        
    }
    
}

-(int) getCurrentMonsters
{
    int count= 0;
    for (NSString* key in monsterData) {
        MonsterData *md = [monsterData objectForKey:key];
        count+=md.currentCount;
        
    }
    
    
    return count;
}

-(MonsterData*) getNextMonster
{
    
    int count =[self getCurrentMonsters];
    
    MonsterData *result;
    
    for (NSString* key in monsterData) {
        MonsterData *md = [monsterData objectForKey:key];
        if(result==nil)
            result=md;
        float currentRatio= (float)md.currentCount/count;
        md.subRatio= currentRatio-md.targetRatio;
        if(md.subRatio<result.subRatio)
            result=md;

    }
    
    
    
    return result;
    
}



@end
@implementation MonsterData
@end