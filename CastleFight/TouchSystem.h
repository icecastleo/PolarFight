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

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(void)setMapLayer:(MapLayer *)mapLayer;

@end
