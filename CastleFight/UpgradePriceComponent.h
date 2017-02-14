//
//  UpgradePriceComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "Component.h"
#import "Attribute.h"

@interface UpgradePriceComponent : Component

@property (readonly) Attribute *price;

-(id)initWithPriceComponent:(Attribute *)price;

@end
