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
    RangeType *range;
}

-(id)initWithType:(AuraStatusType)type withRange:(RangeType*)range;

-(void) addEffectOnCharacter:(Character*)character;
-(void) removeEffectOnCharacter:(Character*)character;
-(void) updateCharacter:(Character*)character;

@end
