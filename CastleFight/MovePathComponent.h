//
//  MovePathComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/19.
//
//

#import "Component.h"

@interface MovePathComponent : Component <SelectableComponentDelegate>

@property (nonatomic) NSMutableArray *path;

-(id)initWithMovePath:(NSArray *)path;

-(CGPoint)nextPositionFrom:(CGPoint)currentPosition;

@end
