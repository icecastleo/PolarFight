//
//  CombatSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/11.
//
//

#import "CombatSystem.h"
#import "AttackerComponent.h"
#import "AttackEvent.h"
#import "DefenderComponent.h"
#import "DamageEvent.h"
#import "Damage.h"
#import "RenderComponent.h"
#import "CharacterComponent.h"
#import "TeamComponent.h"
#import "SimpleAudioEngine.h"

#import "SideEffect.h"
#import "StateComponent.h"
#import "spine-cocos2d-iphone.h"

@implementation CombatSystem

+(void)initialize {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_caf/effect_die_cat.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_caf/effect_die_dog.caf"];
}

-(void)update:(float)delta {
    // TODO: Heal
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[AttackerComponent name]]) {
        AttackerComponent *attack = (AttackerComponent *)[entity getComponentOfName:[AttackerComponent name]];
        
        for (AttackEvent *event in attack.attackEventQueue) {
            NSAssert(entity.eid == event.attacker.eid, @"AttackEvent should be added to attacker's AttackerComponent!");
            
//            CCLOG(@"%d attack",attack.entity.eid);
            
            [event.attacker sendEvent:kEventSendAttackEvent Message:event];
            [event.defender sendEvent:kEventReceiveAttackEvent Message:event];
            
            if (!event.isInvalid) {
                DefenderComponent *defense = (DefenderComponent *)[event.defender getComponentOfName:[DefenderComponent name]];
                
                for (SideEffect *sideEffect in event.sideEffects) {
                    if(sideEffect.percentage > (arc4random() % 100)) {
                        for (StateComponent *component in sideEffect.components) {
                            [event.defender addComponent:component];
                        }
                    }
                }
                [defense.damageEventQueue addObject:[event convertToDamageEvent]];
            }
        }
        
        [attack.attackEventQueue removeAllObjects];
    }
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[DefenderComponent name]]) {
        DefenderComponent *defense = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
        
        for (DamageEvent *event in defense.damageEventQueue) {
            NSAssert(entity.eid == event.receiver.eid, @"DamageEvent should be added to damager's DefenderComponent!");
//            CCLOG(@"%d damage",defense.entity.eid);
            
            [event.sender sendEvent:kEventSendDamageEvent Message:event];
            [event.receiver sendEvent:kEventReceiveDamageEvent Message:event];
            
            if (event.isInvalid) {
                continue;
            }
            
            Damage *damage = [event convertToDamage];
            [entity sendEvent:kEventReceiveDamage Message:damage];
            
            if (defense.hp.currentValue == 0) {
                break;
            }
            
//            if (state == kCharacterStateDead) {
//                return;
//            }
            
//            CCLOG(@"Entity %d gets %d damage!", entity.eid, damage.damage);
            
            defense.hp.currentValue -= damage.damage;
            
            if (defense.bloodSprite) {
                [defense.bloodSprite update];
            }
            
//            RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
//            if (damage.damage > 0) {
//                [renderCom addFlashString:[NSString stringWithFormat:@"%d", damage.damage] color:ccRED];
//            } else {
                // FIXME: Move heal to else where?
//                [renderCom addFlashString:[NSString stringWithFormat:@"%d", abs(damage.damage)] color:ccGREEN];
//            }
            
//            // Knock out effect
//            if (damage.knockOutPower != 0) {
//                CGPoint velocity = ccpSub(self.position, damage.position);
//                [[BattleController currentInstance] knockOut:self velocity:velocity power:damage.knockOutPower collision:damage.knouckOutCollision];
//            }
            
            if (defense.hp.currentValue > 0) {
//                state = kCharacterStateGetDamage;
                [self runDamageAnimationForEntity:entity withDamage:damage];
            }
        }
        
        [defense.damageEventQueue removeAllObjects];
        
        if (defense.hp.currentValue == 0) {
            // state = kCharacterStateDead;
            
//            CCLOG(@"Entity %d is dead", entity.eid);
            
            [entity sendEvent:kEntityEventDead Message:nil];
            
            // Run dead animation, then cleanup entity sprite.
            [self runDeadAnimationForEntity:entity];
            [self playDeadSoundEffectForEntity:entity];
            
            // TODO: Revive
            [self.entityManager removeEntity:entity];
        }
    }
}

-(void)runDamageAnimationForEntity:(Entity *)entity withDamage:(Damage *)damage {
    if (damage.damage > 0) {
        NSAssert(self.entityFactory.mapLayer, @"Damage effect sprite should be added on the map");
        
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hit_01.png"];
        
        if (damage.source == kDamageSourceRanged) {
            sprite.position = damage.position;
        } else {
            CGPoint position = [render.sprite.parent convertToWorldSpace:render.sprite.position];
            sprite.position = [self.entityFactory.mapLayer convertToNodeSpace:position];
        }
        
        CCAction *action = [CCSequence actions:
                            [CCFadeOut actionWithDuration:0.5f],
                            [CCCallBlock actionWithBlock:^{
            [sprite removeFromParentAndCleanup:YES];
        }], nil];
        
        [sprite runAction:action];
        [self.entityFactory.mapLayer addChild:sprite];
    }
    
    // TODO: Damage sound effect
//    if ([character.characterId hasPrefix:@"4"]) {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_building_damage.caf"];
//    } else {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_damage.caf"];
//    }
}

-(void)runDeadAnimationForEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];

    if (render.isSpineNode) {
        CCSkeletonAnimation *animationNode = (CCSkeletonAnimation *)render.sprite;
        [animationNode clearAnimation];
    } else {
       [render.sprite stopAllActions];
    }
    
//    for (CCNode *children in render.node.children) {
//        if (children != sprite) {
//            [children removeFromParentAndCleanup:YES];
//        }
//    }
    
//    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
//    emitter.positionType = kCCPositionTypeRelative;
//    emitter.autoRemoveOnFinish = YES;
//    [render.sprite addChild:emitter];
    
    [render.sprite runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:1.0f],
      [CCCallBlock actionWithBlock:^{
         [render.node removeFromParentAndCleanup:YES];
     }], nil]];
}

-(void)playDeadSoundEffectForEntity:(Entity *)entity {
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
    
    if (character) {
        if ([character.cid hasPrefix:@"4"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_building_remove.caf"];
        } else {
            TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
            
            if (team.team == kPlayerTeam) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
            } else {
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_dog.caf"];
            }
        }
    }
}

@end
