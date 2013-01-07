//
//  Aura.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "PositiveSkill.h"

@interface Aura : PositiveSkill {
    Class auraPassiveSkillClass;
}

-(id)initWithCharacter:(Character *)aCharacter rangeDictionary:(NSMutableDictionary *)dictionary auraPassiveSkillClass:(Class)aClass;

@end
