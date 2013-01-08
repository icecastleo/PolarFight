//
//  Aura.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "Aura.h"
#import "Character.h"

@implementation Aura

-(id)initWithCharacter:(Character *)aCharacter rangeDictionary:(NSMutableDictionary *)dictionary auraPassiveSkillClass:(Class)aClass {
    if (self = [super initWithCharacter:aCharacter]) {
        auraPassiveSkillClass = aClass;
        
        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
        range.rangeSprite.visible = true;
        
        [NSTimer scheduledTimerWithTimeInterval:kAuraInterval target:self selector:@selector(execute:) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)execute:(NSTimer *)timer {
    for (Character *target in [range getEffectTargets]) {
        NSString *key = NSStringFromClass(auraPassiveSkillClass);
        
        AuraPassiveSkill *skill = [target.auraPassiveSkillDictionary objectForKey:key];
        
        if (skill == nil) {
            skill = [[auraPassiveSkillClass alloc] initWithCharacter:target];
            [target.auraPassiveSkillDictionary setObject:skill forKey:key];
        } else {
            skill.remainTime += kAuraInterval;
        }
    }
}



@end
