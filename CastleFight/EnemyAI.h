//
//  CastleAI.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "BaseAI.h"
#import "EnemyAIData.h"
@interface EnemyAI : BaseAI

@property float food;
@property float foodSupplySpeed;
@property MonsterData *nextMonster;
@property EnemyAIData *data;
-(MonsterDataCollection*) getCurrentMonsters;
@end
