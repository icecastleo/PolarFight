//
//  GroupComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/25.
//
//

#import "Component.h"

@interface GroupComponent : Component

@property (readonly) NSMutableArray *groupEntities;

-(id)initWithGroupArray:(NSMutableArray *)entities;

@end
