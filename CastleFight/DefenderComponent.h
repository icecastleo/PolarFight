//
//  DefenderComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/4.
//
//

#import "Component.h"
#import "Attribute.h"
#import "BloodSprite.h"

@interface DefenderComponent : Component

@property (readonly) Attribute *hp;
@property Attribute *defense;
@property ArmorType armorType;
@property BloodSprite *bloodSprite;

@property NSMutableArray *damageEventQueue;

-(id)initWithHpAttribute:(Attribute *)hp;

@end
