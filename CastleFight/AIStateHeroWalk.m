//
//  AIStateHeroWalk.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroWalk.h"
#import "AIStateHeroIdle.h"
#import "AIStateHeroAttack.h"

#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "TeamComponent.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"
#import "AIComponent.h"

@implementation AIStateHeroWalk
- (NSString *)name {
    return @"Hero Walking";
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfClass:[MovePathComponent class]];
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    CGPoint currentPosition = renderCom.position;
    CGPoint nextPosition = [pathCom nextPositionFrom:currentPosition];
    CGPoint diff = ccpSub(nextPosition, currentPosition);
    
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    
    moveCom.velocity = ccpNormalize(diff);
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    
    //test skill
    AIComponent *aiCom = (AIComponent *)[entity getComponentOfClass:[AIComponent class]];
    
    ActiveSkill *skill;
    NSString *skillName = nil;
    
    if (skillCom.skills.count > 1) {
        NSMutableArray *sortSkillKey = [NSMutableArray arrayWithArray:aiCom.sortSkillProbabilities];
        
        int count = sortSkillKey.count;
        int count2 = count;
        
        for (int i=0; i<count; i++) {
            int random = arc4random_uniform([[sortSkillKey lastObject] intValue]);
            //FIXME: edit it to skill.
            int removeIndex = -1;
            
            for (int j=1; j<count2; j++) {
                NSString *preValue = [sortSkillKey objectAtIndex:j-1];
                NSString *value = [sortSkillKey objectAtIndex:j];
                if (random >= preValue.intValue && random < value.intValue) {
                    skillName = [aiCom.skillProbability objectForKey:value];
                    removeIndex = j;
                    break;
                }
            }
            
            if (!skillName) {
                skillName = [aiCom.skillProbability objectForKey:[sortSkillKey objectAtIndex:0]];
            }
            
            skill = [skillCom.skills objectForKey:skillName];
            if (skill.canActive) {
                break;
            }else if(removeIndex < 0){
                // not found
                break;
            }else {
                [sortSkillKey removeObjectAtIndex:removeIndex];
                count2 = sortSkillKey.count;
                skill = nil;
                skillName = nil;
            }
            
        }
    }else {
        skillName = [aiCom.skillProbability objectForKey:[aiCom.sortSkillProbabilities objectAtIndex:0]];
        skill = [skillCom.skills objectForKey:skillName];
    }
    NSAssert(skill != nil, @"you forgot to make this skill.");
    
    // TODO: Other condition to use skill
    if (pathCom.path.count == 0 && [skill checkRange]) {
        [self changeState:[[AIStateHeroAttack alloc] init] forEntity:entity];
        return;
    }
    
    //TODO: change To idle
    if (pathCom.path.count == 0) {
        [self changeState:[[AIStateHeroIdle alloc] init] forEntity:entity];
        return;
    }
}

- (void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    moveCom.velocity = ccp(0, 0);
}

@end
