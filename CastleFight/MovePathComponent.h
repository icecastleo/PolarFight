//
//  MovePathComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/19.
//
//

#import "Component.h"
#import "TouchComponent.h"

@interface MovePathComponent : Component <TouchComponentDelegate>

@property (nonatomic) NSMutableArray *path;

-(id)initWithMovePath:(NSArray *)path;

-(CGPoint)nextPositionFrom:(CGPoint)currentPosition;

@end
