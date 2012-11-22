//
//  AuraTestStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/17.
//
//

#import "AttackBuffStatus.h"
#import "Character.h"

@implementation AttackBuffStatus

-(id)initWithCaster:(Character *)character {
    RangeType *myRange = [[[RangeCircle alloc] initWithCharacter:character] autorelease];
    
    if(self = [super initWithType:statusAttackBuff withRange:myRange]) {
    
    }
    return self;
}

-(void)addEffectOnCharacter:(Character *)character {
    character.attackBonus += 50;
}

-(void)removeEffectOnCharacter:(Character *)character {
    character.attackBonus -= 50;
}

@end
