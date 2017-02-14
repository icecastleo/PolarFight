//
//  AttackerComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/5.
//
//

#import "Component.h"
#import "Attribute.h"

@interface AttackerComponent : Component

@property (readonly) Attribute *attack;
@property NSMutableArray *attackEventQueue;

-(id)initWithAttackAttribute:(Attribute *)attack;

@end
