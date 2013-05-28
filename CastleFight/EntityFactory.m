//
//  EntityFactory.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityFactory.h"
#import "cocos2d.h"
#import "FileManager.h"
#import "RenderComponent.h"
#import "CharacterComponent.h"
#import "LevelComponent.h"
#import "TeamComponent.h"
#import "CostComponent.h"
#import "AnimationComponent.h"
#import "AttackerComponent.h"
#import "DefenderComponent.h"
#import "MoveComponent.h"
#import "DirectionComponent.h"
#import "AccumulateAttribute.h"
#import "UpgradePriceComponent.h"
#import "CharacterBloodSprite.h"
#import "AIComponent.h"
#import "AIStateWalk.h"
#import "ActiveSkillComponent.h"
#import "MeleeAttackSkill.h"
#import "RangeAttackSkill.h"
#import "CastleBloodSprite.h"
#import "PlayerComponent.h"
#import "AIStateEnemyPlayer.h"
#import "SummonComponent.h"
#import "CollisionComponent.h"
#import "ProjectileComponent.h"

#import "PoisonMeleeAttackSkill.h"
#import "ParalysisMeleeAttackSkill.h"

@implementation EntityFactory {
    EntityManager * _entityManager;
}

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"user.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"building.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"combat.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PolarBear.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguin.plist"];
}

- (id)initWithEntityManager:(EntityManager *)entityManager {
    if ((self = [super init])) {
        _entityManager = entityManager;
    }
    return self;
}

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team {
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
    
    NSString *name = [characterData objectForKey:@"name"];
    int cost = [[characterData objectForKey:@"cost"] intValue];
    NSDictionary *attributes = [characterData objectForKey:@"attributes"];

    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_move_01.png", name]];
    
    // for test
    if ([name isEqualToString:@"enemy_01"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar bear-01-01.png"];
    }
    
    else if ([name isEqualToString:@"enemy_02"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar bear-02-01.png"];
    }
    
    else if ([name isEqualToString:@"user_01"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"penguin-01-1.png"];
    }
    
    Entity *entity = [_entityManager createEntity];    
    [entity addComponent:[[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeNormal name:name]];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[CostComponent alloc] initWithFood:cost mana:0]];
    [entity addComponent:[[RenderComponent alloc] initWithSprite:sprite]];
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:[self animationsByCharacterName:name]]];
    
    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
                          [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"attack"]]]];
    
    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"hp"]]];
    [entity addComponent:defenseCom];
    
    defenseCom.defense = [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"defense"]];
    defenseCom.armorType = kArmorNoraml;
    defenseCom.bloodSprite = [[CharacterBloodSprite alloc] initWithEntity:entity];
    
    [entity addComponent:[[ProjectileComponent alloc] init]];
    
    [entity addComponent:[[CollisionComponent alloc] initWithBoundingBox:sprite.boundingBox]];
    
    [entity addComponent:[[MoveComponent alloc] initWithSpeedAttribute:[[Attribute alloc] initWithDictionary:[attributes objectForKey:@"speed"]]]];
    [entity addComponent:[[DirectionComponent alloc] initWithVelocity:ccp(team == 1 ? 1 : -1, 0)]];
    
    // FIXME: Add price to character data
    [entity addComponent:[[UpgradePriceComponent alloc]
                          initWithPriceComponent:[[Attribute alloc] initWithQuadratic:3 linear:30 constantTerm:0 isFluctuant:NO]]];
    
    ActiveSkillComponent *skillCom = [[ActiveSkillComponent alloc] init];
    
    /* // test only for stateComponent
    if ([cid intValue] == 1) {
//        [skillCom.skills setObject:[[PoisonMeleeAttackSkill alloc] init] forKey:@"attack"];
        [skillCom.skills setObject:[[ParalysisMeleeAttackSkill alloc] init] forKey:@"attack"];
    }else {
        [skillCom.skills setObject:[cid intValue] % 2 == 1 ? [[MeleeAttackSkill alloc] init] : [[RangeAttackSkill alloc] init] forKey:@"attack"];
    }
    
//*/[skillCom.skills setObject:[cid intValue] % 2 == 1 ? [[MeleeAttackSkill alloc] init] : [[RangeAttackSkill alloc] init] forKey:@"attack"];
    
    [entity addComponent:skillCom];
    
    // TODO: Set AI for different character
    [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateWalk alloc] init]]];
    
    // Level component should be set after all components that contained attributes.
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    // TODO: PassiveSkill
    
//    [_entityManager addComponent:[[PlayerComponent alloc] init] toEntity:entity];
    
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity];
    }
    
    return entity;
}

-(Entity *)createCastleForTeam:(int)team {

    // TODO: Get castle data
    
//    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
//    NSDictionary *attributes = [characterData objectForKey:@"attributes"];
    
    CCSprite *sprite;

    if (team == 1) {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"building_user_home_01.png"]];
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"building_enemy_home.png"]];
    }
    
    Entity *entity = [_entityManager createEntity];

    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[RenderComponent alloc] initWithSprite:sprite]];
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:nil]];
    
//    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
//                          [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"attack"]]]];
    
    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithQuadratic:0 linear:0 constantTerm:3000 isFluctuant:YES]];
    [entity addComponent:defenseCom];
    
    // TODO: Init by file
//    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"hp"]]];
//    defenseCom.defense = [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"defense"]];
    
    defenseCom.armorType = kArmorNoraml;
    defenseCom.bloodSprite = [[CastleBloodSprite alloc] initWithEntity:entity];
    
    [entity addComponent:[[CollisionComponent alloc] initWithBoundingBox:sprite.boundingBox]];
    
    [entity addComponent:[[DirectionComponent alloc] initWithVelocity:ccp(team == 1 ? 1 : -1, 0)]];
    
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity];
    }
    
    return entity;
}

-(Entity *)createPlayerForTeam:(int)team {
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    
    // TODO: Set by file
    PlayerComponent *player = [[PlayerComponent alloc] init];
    
    if (team == 2) {
        player.foodAddend = 0.0;
    }
    
    [entity addComponent:player];
    
    if (team == 1) {
        NSArray *characterInitDatas = [FileManager sharedFileManager].characterInitDatas;
        
        for (CharacterInitData *data in characterInitDatas) {
            SummonComponent *summon = [[SummonComponent alloc] initWithCharacterInitData:data];
            summon.player = player;
            [player.summonComponents addObject:summon];
        }
        
    } else if (team == 2) {
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateEnemyPlayer alloc] initWithEntityFactory:self]]];
    }
    
    return entity;
}

-(NSMutableDictionary *)animationsByCharacterName:(NSString *)name {
    NSMutableDictionary *animations = [[NSMutableDictionary alloc] init];
    
    // For test sprite
    if ([name isEqualToString:@"enemy_01"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 4; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-01-%02d.png", i]]];
        }
        
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-01-04.png"]]];
        
        animation.restoreOriginalFrame = NO;
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"attack"];
        
        animation = [CCAnimation animation];
        
        for (int i = 1; i <= 3; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-01-%02d.png", i]]];
        }
        
        for (int i = 2; i >= 1 ; i--) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-01-%02d.png", i]]];
        }
        
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"move"];
        
        return animations;
    }
    
    // For test sprite
    if ([name isEqualToString:@"enemy_02"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 2; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-02-%02d.png", i]]];
        }
        
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];

        // attack
        animation = [CCAnimation animation];
        
        for (int i = 6; i <= 7; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-02-%02d.png", i]]];
        }
        
        for (int i = 6; i <= 7; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-02-%02d.png", i]]];
        }
        
        for (int i = 6; i <= 7; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar bear-02-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"attack"];
        
        return animations;
    }
    
    // For test sprite
    if ([name isEqualToString:@"user_01"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-1.png"]]];
        
        for (int i = 4; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-%d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"attack"];
        
        animation = [CCAnimation animation];
        
        for (int i = 1; i <= 2; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-%d.png", i]]];
        }
        
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-1.png"]]];
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-3.png"]]];
        
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"move"];
        
        return animations;
    }

    
    
    CCAnimation *animation = [CCAnimation animation];
    
    for (int i = 1; i <= 4; i++) {
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_attack_%02d.png", name, i]]];
    }
    
    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.1;
    
    [animations setObject:animation forKey:@"attack"];
    
    animation = [CCAnimation animation];
    
    for (int i = 1; i <= 2; i++) {
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_move_%02d.png", name, i]]];
    }
    
    animation.delayPerUnit = 0.2;
    
    [animations setObject:animation forKey:@"move"];
    
    return animations;
}

@end
