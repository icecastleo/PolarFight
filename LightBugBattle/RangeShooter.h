//
//  RangeShooter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "Range.h"

@interface RangeShooter : CCNode {
    Range *range;
    
    CGPoint vector;
    float speed;
    
    id delegate;
    
    CGPoint startPoint;
    float distance;
}

-(id)initWithRange:(Range *)aRange;

-(void)shoot:(CGPoint)aVector speed:(float)aSpeed delegate:(id)aDelegate;

@end
