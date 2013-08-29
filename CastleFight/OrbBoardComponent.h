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

@property (nonatomic,readonly) NSMutableArray *orbs;
@property (nonatomic,readonly) Entity *owner; //player
@property (nonatomic,readonly) EntityFactory *entityFactory;

-(id)initWithEntityFactory:(EntityFactory *)entityFactory owner:(Entity *)player BattleData:(BattleDataObject *)battleData;

-(void)moveOrb:(Entity *)startOrb toPosition:(CGPoint)position;

-(NSArray *)findMatchFromPosition:(CGPoint)position CurrentOrb:(Entity *)currentOrb;
-(void)matchClean:(NSArray *)matchArray;

-(NSArray *)nextColumn;

@end
