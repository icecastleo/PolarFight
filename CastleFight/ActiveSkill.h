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
    __weak Character *character;
    
    NSMutableArray *ranges;
    Range *range;
    
    int count;
    BOOL execute;
}

@property (readonly) BOOL hasNext;

-(id)initWithCharacter:(Character *)aCharacter;
-(void)setRanges;

-(void)execute;
-(void)next;
-(void)reset;

-(void)activeSkill:(int)count;

-(void)showAttackRange:(BOOL)visible;
-(void)setRangeDirection:(CGPoint)velocity;
-(NSArray *)checkTarget;
@end
