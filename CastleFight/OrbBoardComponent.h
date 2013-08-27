//
//  OrbBoardComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"

@class EntityFactory;

@interface OrbBoardComponent : Component

@property (readonly) NSMutableArray *columns;

@property (nonatomic,readonly) NSMutableArray *orbs;
@property (nonatomic) Entity *owner; //player
@property (nonatomic,readonly) EntityFactory *entityFactory;

-(id)initWithEntityFactory:(EntityFactory *)entityFactory;

-(void)moveOrb:(Entity *)startOrb toPosition:(CGPoint)position;

-(NSArray *)findMatchFromPosition:(CGPoint)position CurrentOrb:(Entity *)currentOrb;
-(void)matchClean:(NSArray *)matchArray;

@end
