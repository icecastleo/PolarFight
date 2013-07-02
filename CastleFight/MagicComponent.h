//
//  MagicComponent.h
//  CastleFight
//
//  Created by  DAN on 13/7/2.
//
//

#import "Component.h"
#import "Attribute.h"

@interface MagicComponent : Component

@property (nonatomic,readonly) Attribute *damage;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSDictionary *images;

-(id)initWithDamageAttribute:(Attribute *)damage andMagicName:(NSString*)name andNeedImages:(NSDictionary *)images;

@end
