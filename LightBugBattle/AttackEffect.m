//
//  AttackEffect.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/5.
//
//

#import "AttackEffect.h"
#import "AttackEvent.h"
#import "AttackEventHandler.h"

@implementation AttackEffect

-(id)initWithAttackType:(AttackType)aType {
    if(self = [super init]) {
        type = aType;
    }
    return self;
}

-(void)doEffectFromCharacter:(Character *)aCharacter toCharacter:(Character *)bCharacter {
    AttackEvent *attackEvent = [[AttackEvent alloc] initWithAttacker:aCharacter attackType:kAttackNoraml defender:bCharacter];
    
    [bCharacter handleReceiveAttackEvent:attackEvent];
}

@end
