//
//  OrbComponent.h
//  CastleFight
//
//  Created by  DAN on 13/8/14.
//
//

#import "Component.h"

@interface OrbComponent : Component <SelectableComponentDelegate>

@property (nonatomic) OrbType type;
@property (nonatomic) CGPoint position; //position in the Board
@property (nonatomic,assign) Entity *board;

@end
