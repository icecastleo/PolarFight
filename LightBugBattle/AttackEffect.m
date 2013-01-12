//
//  AttackEffect.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/5.
//
//

#import "AttackEffect.h"
#import "AttackEvent.h"
#import "Character.h"

@implementation AttackEffect

-(id)initWithAttackType:(AttackType)aType {
    if(self = [super init]) {
        type = aType;
    }
    return self;
}

-(void)doEffectFromCharacter:(Character *)aCharacter toCharacter:(Character *)bCharacter {
//    [aCharacter attackCharacter:bCharacter withAttackType:type];
}

@end
