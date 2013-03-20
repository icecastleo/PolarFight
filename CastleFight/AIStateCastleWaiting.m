//
//  AIStateCastleWaiting.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "AIStateCastleWaiting.h"
#import "EnemyAI.h"
@implementation AIStateCastleWaiting

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    
    //examine once a sec
    if(CACurrentMediaTime()>nextDecisionTime)
        [self examineNextMonster:ai];
    
}

-(void) examineNextMonster:(BaseAI *)ai
{
    
    EnemyAI *a = (EnemyAI*)ai;
    CCLOG(@"test");
    nextDecisionTime=CACurrentMediaTime()+1;
    NSDictionary* dic = a.mutableDictionary;
  
   
    NSMutableArray *Name = [NSMutableArray arrayWithCapacity:dic.count];
    
    
    NSMutableArray *compare1 = [NSMutableArray arrayWithCapacity:dic.count];
    NSMutableArray *compare2 = [NSMutableArray arrayWithCapacity:dic.count];
    
    NSMutableArray *floatArray3 =[NSMutableArray arrayWithCapacity:dic.count];
    NSMutableArray *floatArray4 =[NSMutableArray arrayWithCapacity:dic.count];
    
    for (NSString* key in dic) {
        [Name addObject:key];
        
        [compare1 addObject:[(NSArray*)[dic objectForKey:key] objectAtIndex:1]];
        [compare2 addObject:[(NSArray*)[dic objectForKey:key] objectAtIndex:0]];
        
    }
    
    if(compare1.count!=compare2.count)
        return;
    int count =0;
    for(int i = 0;i< compare1.count;i++)
    {
        count+=[[compare1 objectAtIndex:i] integerValue];
    }
    for(int i = 0;i< compare1.count;i++)
    {
        floatArray3[i]=@([[compare1 objectAtIndex:i] doubleValue]/count);
    }
    for(int i = 0;i< compare1.count;i++)
    {
        floatArray4[i]=@([[floatArray3 objectAtIndex:i] doubleValue]-[[compare2 objectAtIndex:i] doubleValue]);
    }
    double min = [floatArray4[0] doubleValue];
    int position=0;
    for(int i = 0;i< compare1.count;i++)
    {
        if(
        [[floatArray4 objectAtIndex:i] doubleValue]<min)
        {
            min=[[floatArray3 objectAtIndex:i] doubleValue];
            position = i;
        }
    }
    
    
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
