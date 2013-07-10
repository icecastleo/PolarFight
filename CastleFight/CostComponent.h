//
//  CostComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"

typedef enum {
    kCostTypeNull,
    kCostTypeFood,
    kCostTypeMana,
    kCostTypeFoodAndMana,
} CostType;

@interface CostComponent : Component

//@property (readonly) NSMutableDictionary *resources;



@property (readonly) int food;
@property (readonly) int mana;
@property (nonatomic) CostType type;

-(id)initWithFood:(int)food mana:(int)mana;
-(id)initWithDictionary:(NSDictionary *)dic;
-(BOOL)isCostSufficientWithFood:(int)food Mana:(int)mana;

@end
