//
//  RangeShooter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "Range.h"

@protocol RangeShooterDelegate <NSObject>
-(void)delayExecute:(NSArray *)targets effectPosition:(CGPoint)position;
@end

@interface RangeShooter : CCNode {
    Range *range;
    
    CGPoint vector;
    float speed;
    
    id<RangeShooterDelegate> delegate;
    
    CGPoint startPoint;
    float distance;
}

-(id)initWithRange:(Range *)aRange;

-(void)shoot:(CGPoint)aVector speed:(float)aSpeed delegate:(id<RangeShooterDelegate>)aDelegate;

@end
