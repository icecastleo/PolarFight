//
//  SkillSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/7.
//
//

#import "ActiveSkillSystem.h"
#import "ActiveSkillComponent.h"
#import "AnimationComponent.h"

@implementation ActiveSkillSystem

-(void)update:(float)delta {
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfName:[ActiveSkillComponent name]];
    
    for (Entity * entity in entities) {
        ActiveSkillComponent * skillCom = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
        
        NSMutableDictionary *testDic = [[NSMutableDictionary alloc] init];
        [testDic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsActiveSkillForbidden"];
        [entity sendEvent:kEventIsActiveSkillForbidden Message:testDic];
        NSNumber *result = [testDic objectForKey:@"kEventIsActiveSkillForbidden"];
        if (result.boolValue == YES) {
            continue;
        }
        
        // Check running skill
        if (skillCom.currentSkill) {
            if (skillCom.currentSkill.isFinish) {
                skillCom.currentSkill.isFinish = NO;
                
                // No next active skill
                if (!skillCom.activeKey) {
                    skillCom.currentSkill = nil;
                    continue;
                }
                
                ActiveSkill *skill = [skillCom.currentSkill.combo objectForKey:skillCom.activeKey];
                skillCom.activeKey = nil;
                
                // Next skill can active
                if (skill && skill.canActive) {
                    skillCom.currentSkill = skill;
                    [skill active];
                } else {
                    skillCom.currentSkill = nil;
                }
            }
            continue;
        }
        
        if (!skillCom.activeKey)
            continue;
        
        ActiveSkill *skill = [skillCom.skills objectForKey:skillCom.activeKey];
        skillCom.activeKey = nil;
        
        if (skill && skill.canActive) {
            skillCom.currentSkill = skill;
            [skill active];
        }
    }
}

@end
