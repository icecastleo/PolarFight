//
//  TouchSystem.h
//  CastleFight
//
//  Created by 朱 世光 on 13/8/22.
//
//

#import "System.h"
#import "TouchComponent.h"

@interface TouchSystem : CCNode <CCTouchOneByOneDelegate>

@property (readonly) TouchState state;

-(id)initWithEntityManager:(EntityManager *)entityManager;

@end
