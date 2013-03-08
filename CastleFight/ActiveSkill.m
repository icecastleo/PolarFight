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
                format:@"You must override %@ in a ActiveSkill subclass", NSStringFromSelector(_cmd)];
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

-(void)stop {
    _hasNext = NO;
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
                format:@"You must override %@ in a ActiveSkill subclass", NSStringFromSelector(_cmd)];
}

-(NSArray *)checkTarget{
    if(range!=nil)
    return [range getEffectTargets];
    return nil;
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
