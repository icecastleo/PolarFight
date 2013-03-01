//
//  Aura.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "Aura.h"
#import "Character.h"
#import "SlowMovePassiveSkill.h"
#import "BattleController.h"

@implementation Aura

-(id)initWithCharacter:(Character *)aCharacter {    
    return [self initWithCharacter:aCharacter rangeDictionary:[self getRangeDictionary]];
}

-(id)initWithCharacter:(Character *)aCharacter rangeDictionary:(NSMutableDictionary *)dictionary {
    if (self = [super init]) {
        character = aCharacter;
        range = [Range rangeWithCharacter:aCharacter parameters:dictionary];
        // FIXME: Add it when range has a picture
//        range.rangeSprite.visible = true;

        [self schedule:@selector(update:) interval:kAuraInterval];
        [[BattleController currentInstance] addChild:self];
    }
    return self;
}

-(void)update:(ccTime)delta {    
    // Remove aura when character dealloc.
    if (character == nil) {
        [self unscheduleUpdate];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    for (Character *target in [range getEffectTargets]) {
        [self execute:target];
    }
}

// Override to init a range for aura
-(NSMutableDictionary *)getRangeDictionary {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Aura subclass", NSStringFromSelector(_cmd)];
    return nil;
}

// Override what you want to do to the target
-(void)execute:(Character *)target {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Aura subclass", NSStringFromSelector(_cmd)];
}

@end
