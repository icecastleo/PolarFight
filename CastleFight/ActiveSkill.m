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
        
        ranges = [[NSMutableArray alloc] init];
        [self setRanges];
        
        for (Range *r in ranges) {
            // Add sprite on character
            CCSprite *rangeSprite = r.rangeSprite;
            rangeSprite.zOrder = -1;
            rangeSprite.visible = NO;
            rangeSprite.position = ccp(character.sprite.boundingBox.size.width/2, character.sprite.boundingBox.size.height/2);
            [character.sprite addChild:rangeSprite];
        }
        
        count = 0;
        
        if (ranges.count > 0) {
            range = ranges[0];
        }
        
        execute = NO;
        _hasNext = NO;
    }
    return self;
}

-(void)setRanges {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(void)execute {
    if (!execute) {
        execute = YES;
        
        NSString *skillName = [NSString stringWithFormat:@"%@%02d",NSStringFromClass([self class]),count+1];
        
        [character.sprite runAnimationForName:skillName];
        [self activeSkill:count];
    } else {
        if (ranges.count < 1) {
            return;
        }
        
        if (count != ranges.count - 1) {
            _hasNext = YES;
        }
    }
}

-(void)next {
    execute = NO;
    _hasNext = NO;
    
    count++;
    
    range.rangeSprite.visible = NO;
    range = ranges[count];
    range.rangeSprite.visible = YES;
}

-(void)reset {
    execute = NO;
    _hasNext = NO;
    
    if (count == 0) {
        return;
    }
    
    count = 0;
    
    range.rangeSprite.visible = NO;
    range = ranges[count];
    range.rangeSprite.visible = YES;
}

-(void)activeSkill:(int)count {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(NSArray *)checkTarget {
    return [range getEffectTargets];
}

-(void)showAttackRange:(BOOL)visible {
    if (range == nil) {
        return;
    }
    
    range.rangeSprite.visible = visible;
}

-(void)setRangeDirection:(CGPoint)velocity {
    [range setDirection:velocity];
}

@end
