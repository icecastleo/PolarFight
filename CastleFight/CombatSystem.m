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

@implementation CombatSystem

-(void)update:(float)delta {
    
    // TODO: Heal
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[AttackerComponent class]]) {
        AttackerComponent *attack = (AttackerComponent *)[entity getComponentOfClass:[AttackerComponent class]];
        
        for (AttackEvent *event in attack.attackEventQueue) {
            NSAssert(entity.eid == event.attacker.eid, @"AttackEvent should be added to attacker's AttackerComponent!");
            
            [event.attacker sendEvent:kEventSendAttackEvent Message:event];
            [event.defender sendEvent:kEventReceiveAttackEvent Message:event];
            
            DefenderComponent *defense = (DefenderComponent *)[event.defender getComponentOfClass:[DefenderComponent class]];
            
            [defense.damageEventQueue addObject:[event convertToDamageEvent]];
        }
        
        [attack.attackEventQueue removeAllObjects];
    }
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[DefenderComponent class]]) {
        DefenderComponent *defense = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
        
        for (DamageEvent *event in defense.damageEventQueue) {
            NSAssert(entity.eid == event.receiver.eid, @"DamageEvent should be added to damager's DefenderComponent!");
            
            [event.sender sendEvent:kEventSendDamageEvent Message:event];
            [event.receiver sendEvent:kEventReceiveDamageEvent Message:event];
                        
            Damage *damage = [event convertToDamage];
            [entity sendEvent:kEventReceiveDamage Message:damage];
            
            if (defense.hp.currentValue == 0) {
                break;
            }
            
//            if (state == kCharacterStateDead) {
//                return;
//            }
            
            CCLOG(@"Entity %d gets %d damage!", entity.eid, damage.damage);
            
            defense.hp.currentValue -= damage.damage;
            
            if (defense.bloodSprite) {
                [defense.bloodSprite update];
                
                [defense.bloodSprite stopAllActions];
                [defense.bloodSprite runAction:[CCSequence actions:[CCShow action],
                                        [CCDelayTime actionWithDuration:2.0f],
                                        [CCHide action],
                                        nil]];
            }
            

            RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
            [renderCom addFlashString:[NSString stringWithFormat:@"%d", damage.damage] color:ccRED];
                        
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
            
            CCLOG(@"Entity %d is dead", entity.eid);
            
            [entity sendEvent:KEventDead Message:nil];
            
            // Run dead animation, then cleanup entity sprite.
            [self runDeadAnimationForEntity:entity];
            [self playDeadSoundEffectForEntity:entity];
            
            [self.entityManager removeEntity:entity];
        }
    }
}

-(void)runDamageAnimationForEntity:(Entity *)entity withDamage:(Damage *)damage {
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    CCSprite *entitySprite = renderCom.sprite;
    
    if (damage.damage > 0) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hit_01.png"];
        
        if (damage.source == kDamageSourceRanged) {
            sprite.position = [entitySprite convertToNodeSpace:damage.position];
        } else {
            sprite.position = ccp(entitySprite.boundingBox.size.width/2, entitySprite.boundingBox.size.height/2);
        }
        
        CCAction *action = [CCSequence actions:
                            [CCFadeOut actionWithDuration:0.5f],
                            [CCCallBlock actionWithBlock:^{
            [sprite removeFromParentAndCleanup:YES];
        }], nil];
        
        [sprite runAction:action];
        [entitySprite addChild:sprite];
    }
    
//    if ([character.characterId hasPrefix:@"4"]) {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_building_damage.caf"];
//    } else {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_damage.caf"];
//    }
}

-(void)runDeadAnimationForEntity:(Entity *)entity {
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    CCSprite *sprite = renderCom.sprite;
    
    [sprite stopAllActions];
    [sprite removeAllChildrenWithCleanup:YES];
    
    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
    emitter.position = ccp(sprite.boundingBox.size.width/2, sprite.boundingBox.size.height/2);
    emitter.positionType = kCCPositionTypeRelative;
    emitter.autoRemoveOnFinish = YES;
    [sprite addChild:emitter];
    
    [sprite runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:1.0f],
      [CCCallBlock actionWithBlock:^{
         [sprite removeFromParentAndCleanup:YES];
     }], nil]];
}

-(void)playDeadSoundEffectForEntity:(Entity *)entity {
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    if (character) {
        if ([character.cid hasPrefix:@"4"]) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_building_remove.caf"];
        } else {
            TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
            
            if (team.team == 1) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
            } else {
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_dog.caf"];
            }
        }
    }
}

@end
