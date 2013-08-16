//
//  OrbBoardComponent.h
//  CastleFight
//
//  Created by  DAN on 13/8/14.
//
//

#import "Component.h"

@class EntityFactory;

@interface OrbBoardComponent : Component

@property (nonatomic,readonly) NSMutableArray *board;
@property (nonatomic,readonly) int currentColumn;

-(id)initWithEntityFactory:(EntityFactory *)entityFactory;
-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition;

-(void)produceOrbs;
-(void)removeColumn:(int)index;

@end
