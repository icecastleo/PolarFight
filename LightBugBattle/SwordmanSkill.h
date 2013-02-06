//
//  SwordmanSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "ActiveSkill.h"
#import "Range.h"

@interface SwordmanSkill : ActiveSkill {
    NSMutableArray *ranges;
    
    int count;
    BOOL doing;
    BOOL hasNext;
    
    CCAction *upAttackAction;
    CCAction *downAttackAction;
    CCAction *rightAttackAction;
    CCAction *leftAttackAction;
}

@end
