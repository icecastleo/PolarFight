//
//  DamageEffect.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/11.
//
//

#import "DamageEffect.h"
#import "Character.h"

@implementation DamageEffect

-(id)initWithDamage:(int)aNumber {
    if(self = [super init]) {
        damage = aNumber;
    }
    return self;
}

-(void)doEffectFromCharacter:(Character *)aCharacter toCharacter:(Character *)bCharacter {
    [bCharacter getDamage:damage];
}

@end