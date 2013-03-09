//
//  RangeShooter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "Range.h"

@protocol RangeShooterNewDelegate <NSObject>
-(void)delayExecute:(NSArray *)targets effectPosition:(CGPoint)position;
@end

@interface RangeShooterNew : CCNode {
    Range *range;
    
    CGPoint targetPoint;
    float time;
    
    id<RangeShooterNewDelegate> delegate;
    
    CGPoint startPoint;
    float distance;
}

-(id)initWithRange:(Range *)aRange;

-(void)shoot:(CGPoint)targetPoint time:(float)aTime delegate:(id<RangeShooterNewDelegate>)aDelegate;

@end
