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

// TODO: init with damage type & source
-(id)initWithDamage:(int)aNumber {
    if(self = [super init]) {
        damage = aNumber;
    }
    return self;
}

-(void)doEffectFromCharacter:(Character *)aCharacter toCharacter:(Character *)bCharacter {
//    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:damage damageType:kDamageTypeNormal damageSource:kda damager:<#(Character *)#> damager:aCharacter];
    
//    [bCharacter receiveDamageEvent:event];
}

@end
