//
//  Skill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import "PositiveSkill.h"

@implementation PositiveSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
    }
    return self;
}

-(void)execute {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void)showAttackRange:(BOOL)visible {
    range.rangeSprite.visible = visible;
}

-(void)setRangeRotation:(float)offX :(float)offY {
    [range setRotation:offX :offY];
}

@end
