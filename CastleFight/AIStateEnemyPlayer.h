//
//  AIStatePlayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/13.
//
//

#import "AIState.h"
#import "Entity.h"
#import "EnemyData.h"
#import "EntityFactory.h"

@interface EnemyDatas : NSObject {

}

@property (readonly) NSDictionary *datas;

-(void)addEnemyData:(EnemyData *)data;
-(EnemyData *)getEnemyDataWithCid:(NSString *)cid;

-(void)zeroCount;

@end

@interface AIStateEnemyPlayer : AIState {
    EntityFactory *_entityFactory;
    EnemyDatas *enemyDatas;
    
    EnemyData *nextEnemy;
}

-(id)initWithEntityFactory:(EntityFactory *)entityFactory;

@end
