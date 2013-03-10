//
//  RangeShooter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "Range.h"
#import "DelegateSkill.h"

@interface RangeShooterNew : CCNode {
    Range *range;
    DelegateSkill *delegate;
    
    CGPoint targetPoint;
    float time;

    CGPoint startPoint;
    float distance;
}

-(id)initWithRange:(Range *)aRange delegateSkill:(DelegateSkill *)aDelegate;
-(void)shoot:(CGPoint)targetPoint time:(float)aTime;

@end
