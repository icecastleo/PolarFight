//
//  CostComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"

@interface CostComponent : Component

//@property (readonly) NSMutableDictionary *resources;

-(id)initWithFood:(int)food mana:(int)mana;

@property (readonly) int food;
@property (readonly) int mana;

@end
