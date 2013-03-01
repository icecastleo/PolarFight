//
//  AuraStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "Status.h"
#import "SkillKit.h"

@interface AuraStatus : Status {
    Range *range;
}

-(id)initWithType:(AuraStatusType)type withRange:(Range*)range;

-(void) addEffectOnCharacter:(Character*)character;
-(void) removeEffectOnCharacter:(Character*)character;
-(void) updateCharacter:(Character*)character;

@end
