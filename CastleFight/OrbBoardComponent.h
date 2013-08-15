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

-(id)initWithEntityFactory:(EntityFactory *)entityFactory;
-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition;

@end
