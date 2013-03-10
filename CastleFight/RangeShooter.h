//
//  RangeShooter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "Range.h"
#import "DelegateSkill.h"

@interface RangeShooter : CCNode {
    Range *range;
    DelegateSkill *delegate;
    
    CGPoint startPosition;
    CGPoint endPosition;
    float speed;
    CGPoint vector;
    
    ccTime t;
}

-(id)initWithRange:(Range *)aRange delegateSkill:(DelegateSkill *)aDelegate;
-(void)shootFrom:(CGPoint)start toPosition:(CGPoint)end speed:(float)aSpeed;

@end
