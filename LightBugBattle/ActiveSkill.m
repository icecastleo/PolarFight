//
//  Skill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import "ActiveSkill.h"
#import "Character.h"

@implementation ActiveSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
    }
    return self;
}

-(void)execute {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a PositiveSkill subclass", NSStringFromSelector(_cmd)];
}

-(void)showAttackRange:(BOOL)visible {
    if (range == nil) {
        return;
    }
    
    if(range.rangeSprite.parent == nil) {
        range.rangeSprite.position = ccp(character.sprite.boundingBox.size.width/2,character.sprite.boundingBox.size.height/2);
        [character.sprite addChild:range.rangeSprite];
    }
    
    range.rangeSprite.visible = visible;
}

-(void)setRangeDirection:(CGPoint)velocity {
    [range setDirection:velocity];
}

@end
