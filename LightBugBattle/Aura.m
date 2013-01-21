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

@implementation Aura

-(id)initWithCharacter:(Character *)aCharacter rangeDictionary:(NSMutableDictionary *)dictionary {
    if (self = [super initWithCharacter:aCharacter]) {
        range = [Range rangeWithParameters:dictionary];
//        range.rangeSprite.visible = true;
        
        [NSTimer scheduledTimerWithTimeInterval:kAuraInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)update:(NSTimer *)timer {
    // Remove aura when character dealloc.
    if (character == nil) {
        [timer invalidate];
        return;
    }
    
    [self execute];
}

// Override what you want to do every interval;
-(void)execute {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Aura subclass", NSStringFromSelector(_cmd)];
}

@end
