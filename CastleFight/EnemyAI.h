//
//  CastleAI.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "BaseAI.h"

@interface EnemyAI : BaseAI

@property NSMutableDictionary *mutableDictionary;
@property float food;
@property float foodSupplySpeed;
@property Character *nextMonster;

-(NSMutableDictionary*) getCurrentMonsters;
@end
