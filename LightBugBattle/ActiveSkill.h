//
//  Skill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import <Foundation/Foundation.h>
#import "EffectKit.h"
#import "Range.h"

@interface ActiveSkill : NSObject {
    Range *range;
    __weak Character *character;
}

-(id)initWithCharacter:(Character*)aCharacter;
-(void)execute;

-(void)showAttackRange:(BOOL)visible;
-(void)setRangeDirection:(CGPoint)velocity;

@end
