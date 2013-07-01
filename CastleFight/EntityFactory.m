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
#import "AIStateHeroWalk.h"
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
#import "MovePathComponent.h"
#import "InformationComponent.h"
#import "MagicComponent.h"

@implementation EntityFactory {
    EntityManager * _entityManager;
}

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"user.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"building.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"combat.plist"];
    
    CCAnimationCache *cache = [CCAnimationCache sharedAnimationCache];
	[cache addAnimationsWithFile:@"animations.plist"];
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
       
    CCSprite *sprite = nil;
    
    if ([name hasPrefix:@"user"] || [name hasPrefix:@"enemy"] || [name hasPrefix:@"hero"] || [name hasPrefix:@"boss"]) {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_move_01.png", name]];
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_0.png", name]];
    }
    
    Entity *entity = [_entityManager createEntity];    
    [entity addComponent:[[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeNormal name:name]];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[CostComponent alloc] initWithFood:cost mana:0]];
    
    [entity addComponent:[[RenderComponent alloc] initWithSprite:sprite]];
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:[self animationsByCharacterName:name]]];
    
    [entity addComponent:[[MoveComponent alloc] initWithSpeedAttribute:[[Attribute alloc] initWithDictionary:[attributes objectForKey:@"speed"]]]];
    [entity addComponent:[[DirectionComponent alloc] initWithVelocity:ccp(team == 1 ? 1 : -1, 0)]];    
        
    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
                          [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"attack"]]]];
    
    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"hp"]]];
    [entity addComponent:defenseCom];
    
    defenseCom.defense = [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"defense"]];
    defenseCom.armorType = kArmorNoraml;
    defenseCom.bloodSprite = [[CharacterBloodSprite alloc] initWithEntity:entity];
    
    [entity addComponent:[[ProjectileComponent alloc] init]];
    
    [entity addComponent:[[CollisionComponent alloc] initWithBoundingBox:sprite.boundingBox]];
    
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
        
        [entity addComponent:[[HeroComponent alloc] initWithCid:cid Level:level Team:team]];
        [entity addComponent:[[SelectableComponent alloc] init]];

        NSArray *path = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:ccp(150,110)],[NSValue valueWithCGPoint:ccp(250,110)], nil];
        MovePathComponent *pathCom = [[MovePathComponent alloc] initWithMovePath:path];
        [entity addComponent:pathCom];
        
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateHeroWalk alloc] init]]];
    } else {
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
        
        NSArray *battleTeamInitData = [FileManager sharedFileManager].battleTeam;
        for (CharacterInitData *data in battleTeamInitData) {
            SummonComponent *summon = [[SummonComponent alloc] initWithCharacterInitData:data];
            summon.player = player;
            [player.battleTeam addObject:summon];
        }
        
        MagicComponent *magicCom = [[MagicComponent alloc] init];
        NSArray *magicTeamInitData = [FileManager sharedFileManager].magicTeam;
        
        for (CharacterInitData *data in magicTeamInitData) {
            Entity *magicButton = [self createMagicButton:data.cid level:data.level];
            [player.magicTeam addObject:magicButton];
            
            InformationComponent *infoCom = (InformationComponent *)[magicButton getComponentOfClass:[InformationComponent class]];
            NSString *name = [infoCom.information objectForKey:@"name"];
            NSAssert(NSClassFromString(name), @"you forgot to make this skill.");
            [magicCom.magics setObject:[[NSClassFromString(name) alloc] init] forKey:name];
        }
        
        [entity addComponent:magicCom];
        
        [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
                              nil]];
        
        [entity addComponent:[[ProjectileComponent alloc] init]];
        
    } else if (team == 2) {
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateEnemyPlayer alloc] initWithEntityFactory:self]]];
    }
    
    return entity;
}

-(Entity *)createMagicButton:(NSString *)cid level:(int)level {
    
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
    
    NSString *name = [characterData objectForKey:@"name"];
    int cost = [[characterData objectForKey:@"cost"] intValue];
    NSMutableDictionary *information = [NSMutableDictionary dictionaryWithDictionary:[characterData objectForKey:@"information"]];
    
    [information setObject:name forKey:@"name"];
    [information setObject:[NSNumber numberWithInt:level] forKey:@"level"];
    
    CCSprite *sprite = [CCSprite spriteWithFile:[information objectForKey:@"buttonImage"]];
    
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeNormal name:name]];
    
    [entity addComponent:[[CostComponent alloc] initWithFood:cost mana:0]];
    [entity addComponent:[[RenderComponent alloc] initWithSprite:sprite]];
    
    [entity addComponent:[[InformationComponent alloc] initWithInformation:information]];
    [entity addComponent:[[SelectableComponent alloc] init]];
    
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    return entity;
}

-(NSMutableDictionary *)animationsByCharacterName:(NSString *)name {
    NSMutableDictionary *animations = [[NSMutableDictionary alloc] init];
    
    if ([name hasPrefix:@"user"] || [name hasPrefix:@"enemy"] || [name hasPrefix:@"hero"] || [name hasPrefix:@"boss"]) {
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
        
        animation.restoreOriginalFrame = YES;
        animation.delayPerUnit = 0.2;
        [animations setObject:animation forKey:@"move"];

    } else {
        CCAnimationCache *cache = [CCAnimationCache sharedAnimationCache];
        
        CCAnimation *move = [cache animationByName:[NSString stringWithFormat:@"%@_move", name]];
        CCAnimation *attack = [cache animationByName:[NSString stringWithFormat:@"%@_attack", name]];
        
        [animations setObject:move forKey:@"move"];
        [animations setObject:attack forKey:@"attack"];
    }
    
    return animations;
}

@end
