//
//  GeneralAIStateWalk.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/23.
//
//

#import "GeneralAIStateWalk.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "CharacterComponent.h"
#import "MoveComponent.h"
#import "TeamComponent.h"
#import "GeneralAIStateAttack.h"

@interface GeneralAIStateWalk() {
    MoveComponent *move;
    ActiveSkillComponent *skills;
    
    Entity *target;
}

@end

@implementation GeneralAIStateWalk

-(void)enter:(Entity *)entity {
    move = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    skills = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
}

-(void)updateEntity:(Entity *)entity {
    if (target.isDead) {
        target = nil;
    }
    
    if (target == nil) {
        TeamComponent *entityTeam = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        
        for (Entity *enemy in [entity getAllEntitiesPosessingComponentOfName:[CharacterComponent name]]) {
            if (enemy.eid == entity.eid) {
                continue;
            }
            
            TeamComponent *enemyTeam = (TeamComponent *)[enemy getComponentOfName:[TeamComponent name]];
            
            if (entityTeam.team == enemyTeam.team) {
                continue;
            }
            
            if (enemy.isDead) {
                continue;
            }
            
            if (target == nil) {
                target = enemy;
            } else {
                CharacterComponent *targetCharacter = (CharacterComponent *)[target getComponentOfName:[CharacterComponent name]];
                CharacterComponent *enemyCharacter = (CharacterComponent *)[enemy getComponentOfName:[CharacterComponent name]];

                if (targetCharacter.type == enemyCharacter.type) {
                    if (ccpDistance(entity.position, target.position) > ccpDistance(entity.position, enemy.position)) {
                        target = enemy;
                    }
                } else {
                    if (enemyCharacter.type == kCharacterTypeGeneral) {
                        target = enemy;
                    }
                }
            }
        }
    }
    
    if (target == nil) {
        move.velocity = CGPointZero;
        return;
    }
    
    ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
        
    if (ccpDistance(entity.position, target.position) > skill.range.width) {
        if (entity.position.x > target.position.x) {
            move.velocity = ccpSub(ccpAdd(target.position, ccp(skill.range.width * 0.8, 0)), entity.position);
        } else {
            move.velocity = ccpSub(ccpAdd(target.position, ccp(-skill.range.width * 0.8, 0)), entity.position);
        }
    } else {
        [self changeState:[[GeneralAIStateAttack alloc] init] forEntity:entity];
    }
}

-(void)exit:(Entity *)entity {
    move.velocity = ccp(0, 0);
}

@end
