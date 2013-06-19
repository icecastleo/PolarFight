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
#import "CastleBloodSprite.h"
#import "PlayerComponent.h"
#import "AIStateEnemyPlayer.h"
#import "SummonComponent.h"
#import "CollisionComponent.h"
#import "ProjectileComponent.h"
#import "PassiveComponent.h"
#import "HeroComponent.h"
#import "AuraComponent.h"

#import "SelectableComponent.h"

@implementation EntityFactory {
    EntityManager * _entityManager;
}

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"user.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"building.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"combat.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SpriteSheets/polar-bear.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SpriteSheets/penguin.plist"];
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
    NSDictionary *activeSkills = [characterData objectForKey:@"activeSkills"];
    NSDictionary *passiveSkills = [characterData objectForKey:@"passiveSkills"];
    NSDictionary *auras = [characterData objectForKey:@"auras"];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_move_01.png", name]];
    
    // for test
    if ([name isEqualToString:@"enemy_01"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar-bear-01-00.png"];
    } else if ([name isEqualToString:@"enemy_02"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar-bear-02-00.png"];
    } else if ([name isEqualToString:@"enemy_03"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar-bear-03-00.png"];
    } else if ([name isEqualToString:@"enemy_04"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"polar-bear-04-00.png"];
    } else if ([name isEqualToString:@"user_01"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"penguin-01-00.png"];
    } else if ([name isEqualToString:@"user_02"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"penguin-02-00.png"];
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
    for (NSString *key in activeSkills.allKeys) {
        NSString *value = [activeSkills valueForKey:key];
        NSAssert(NSClassFromString(value), @"you forgot to make this skill.");
        [skillCom.skills setObject:[[NSClassFromString(value) alloc] init] forKey:key];
    }
    if (skillCom.skills.count > 0) {
        [entity addComponent:skillCom];
    }
    
    PassiveComponent *passiveCom = [[PassiveComponent alloc] init];
    for (NSString *key in passiveSkills.allKeys) {
        NSString *value = [passiveSkills valueForKey:key];
        NSAssert(NSClassFromString(value), @"you forgot to make this skill.");
        [passiveCom.skills setObject:[[NSClassFromString(value) alloc] init] forKey:key];
    }
    if (passiveCom.skills.count > 0) {
        [entity addComponent:passiveCom];
    }
    
    AuraComponent *auraComponent = [[AuraComponent alloc] init];
    for (NSString *key in auras.allKeys) {
        NSString *value = [auras valueForKey:key];
        NSAssert(NSClassFromString(value), @"you forgot to make this skill.");
        [auraComponent.auras setObject:[[NSClassFromString(value) alloc] init] forKey:key];
    }
    if (auraComponent.auras.count > 0) {
        auraComponent.infinite = YES;
        [entity addComponent:auraComponent];
    }
    
    //hero
    if ([cid intValue]/100 == 2) {
        HeroComponent *heroCom = [[HeroComponent alloc] initWithCid:cid Level:level Team:team];
        [entity addComponent:heroCom];
        
        SelectableComponent *testSelec = [[SelectableComponent alloc] initWithCid:cid Level:level Team:team];
        [entity addComponent:testSelec];
    }else {
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateWalk alloc] init]]];
    }
    
    // TODO: Set AI for different character
//    [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateWalk alloc] init]]];
    
    // Level component should be set after all components that contained attributes.
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
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
        
        NSArray *battleTeamInitData = [FileManager sharedFileManager].team;
        for (CharacterInitData *data in battleTeamInitData) {
            SummonComponent *summon = [[SummonComponent alloc] initWithCharacterInitData:data];
            summon.player = player;
            [player.battleTeam addObject:summon];
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
        
        for (int i = 0; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-01-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];

        
        animation = [CCAnimation animation];
        
        for (int i = 6; i <= 6; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-01-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.2;
        
        [animations setObject:animation forKey:@"attack"];
        
                
        return animations;
    }
    
    // For test sprite
    if ([name isEqualToString:@"enemy_02"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 1; i <= 4; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-02-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];

        // attack
        animation = [CCAnimation animation];
        
        for (int i = 5; i <= 6; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-02-%02d.png", i]]];
        }
        
        for (int i = 5; i <= 6; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-02-%02d.png", i]]];
        }
        
        for (int i = 5; i <= 6; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-02-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        
        [animations setObject:animation forKey:@"attack"];
        
        return animations;
    }
    
    if ([name isEqualToString:@"enemy_03"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 0; i <= 2; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-03-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];
        
        // attack
        animation = [CCAnimation animation];
        
        for (int i = 3; i <= 7; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-03-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.2;
        
        [animations setObject:animation forKey:@"attack"];
        
        return animations;
    }
    
    if ([name isEqualToString:@"enemy_04"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 0; i <= 4; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-04-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];
        
        // attack
        animation = [CCAnimation animation];
        
        for (int i = 5; i <= 8; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"polar-bear-04-%02d.png", i]]];
        }
    
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.075;
        
        [animations setObject:animation forKey:@"attack"];
        
        return animations;
    }
    
    // For test sprite
    if ([name isEqualToString:@"user_01"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 0; i <= 3; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.1;
        [animations setObject:animation forKey:@"move"];
        
        
        animation = [CCAnimation animation];
        
        for (int i = 4; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-01-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.2;
        [animations setObject:animation forKey:@"attack"];
        
        return animations;
    }
    
    if ([name isEqualToString:@"user_02"]) {
        CCAnimation *animation = [CCAnimation animation];
        
        for (int i = 0; i <= 5; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-02-%02d.png", i]]];
        }
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.3;
        
        [animations setObject:animation forKey:@"move"];
        
        animation = [CCAnimation animation];
        
        for (int i = 6; i <= 9; i++) {
            [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-02-%02d.png", i]]];
        }
        
        // FIXME: Seperate by 2 skill?
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-02-09.png"]]];
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"penguin-02-09.png"]]];
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.5;
        [animations setObject:animation forKey:@"attack"];
        
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
