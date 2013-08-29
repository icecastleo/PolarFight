//
//  OrbBoardComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"

@class EntityFactory,BattleDataObject;

@interface OrbBoardComponent : Component

@property (readonly) NSMutableArray *columns;

@property (nonatomic,readonly) Entity *player; //player
@property (nonatomic,readonly) Entity *aiPlayer;

@property (nonatomic,readonly) EntityFactory *entityFactory;

-(id)initWithEntityFactory:(EntityFactory *)entityFactory player:(Entity *)player aiPlayer:(Entity *)aiPlayer BattleData:(BattleDataObject *)battleData ;

-(void)moveOrb:(Entity *)startOrb toPosition:(CGPoint)position;

-(NSArray *)findMatchForOrb:(Entity *)currentOrb;
-(void)matchClean:(NSArray *)matchArray;

-(NSArray *)nextColumn;

@end
