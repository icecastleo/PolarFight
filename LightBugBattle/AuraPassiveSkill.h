//
//  AuraPassiveSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "PassiveSkill.h"

@interface AuraPassiveSkill : PassiveSkill {
    __weak Character *character;
}

@property float remainTime;

-(id)initWithCharacter:(Character *)aCharacter;

@end
