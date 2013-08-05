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
#import "ProjectileEvent.h"
#import "AIStateProjectile.h"
#import "LineComponent.h"

#import "SelectableComponent.h"
#import "MovePathComponent.h"
#import "InformationComponent.h"
#import "MagicSkillComponent.h"
#import "MagicComponent.h"
#import "MaskComponent.h"

#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PhysicsRoot.h"
#import "PhysicsNode.h"
#import "Box2D.h"

//test
#import "CCSkeletonAnimation.h"
//test

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

-(id)initWithEntityManager:(EntityManager *)entityManager {
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
    
    Entity *entity = [_entityManager createEntity];    
    [entity addComponent:[[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeNormal name:name]];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[CostComponent alloc] initWithFood:cost mana:0]];
    
    if ([cid intValue]/100 != 2) {
        //hero doesn't need to change line.
        [entity addComponent:[[LineComponent alloc] init]];
    }
    
    DirectionComponent *direction = [[DirectionComponent alloc] initWithType:kDirectionTypeLeftRight velocity:ccp(team == 1 ? 1 : -1, 0)];
    // FIXME: Change all character asset to right
    direction.spriteDirection = (team == 1 ? kSpriteDirectionRight : kSpriteDirectionLeft);
    [entity addComponent:direction];
    
    NSString *spriteFrameName = nil;
    
    if ([name hasPrefix:@"user"] || [name hasPrefix:@"enemy"] || [name hasPrefix:@"hero"] || [name hasPrefix:@"boss"]) {
        spriteFrameName = [NSString stringWithFormat:@"%@_move_01.png", name];
    } else {
        spriteFrameName = [NSString stringWithFormat:@"%@_0.png", name];
    }
    
    CCNode *sprite;

    // hero spine
    if ([cid intValue]/100 == 2) {
        CCSkeletonAnimation *animationNode = [CCSkeletonAnimation skeletonWithFile:@"spineboy.json" atlasFile:@"spineboy.atlas" scale:0.2];
        [animationNode updateWorldTransform];
        
        sprite = animationNode;
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
        
        if ([cid intValue]/100 == 0) {
            sprite.scale = 0.8;
        } else if ([cid intValue]/100 == 1) {
            sprite.scale = 0.7;
        }
    }
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.enableShadowPosition = YES;
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        physics.direction = direction;
        [entity addComponent:physics];
        
        // Add Physics body
        b2Body *body = [self createBoxBodyWithSprite:sprite];
        body->SetUserData((__bridge void*)entity);
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        [physics.root addChild:physicsNode];
    }
    
    
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:[self animationsByCharacterName:name]]];
    
    [entity addComponent:[[MoveComponent alloc] initWithSpeedAttribute:[[Attribute alloc] initWithDictionary:[attributes objectForKey:@"speed"]]]];
        
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
        NSNumber *value = [activeSkills valueForKey:key];
        NSAssert(NSClassFromString(key), @"you forgot to make this skill.");
        // value is probability, key is skillName
        [skillCom addSkillName:key andProbability:value.intValue];
    }
    
    if (skillCom.skills.count > 0) {
        // Some entity might not have agile attribute
        if ([attributes objectForKey:@"agile"]) {
            Attribute *agile = [[Attribute alloc] initWithDictionary:[attributes objectForKey:@"agile"]];
            skillCom.agile = agile;
        }
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
    
    // hero
    if ([cid intValue]/100 == 2) {
        
        [entity addComponent:[[HeroComponent alloc] initWithCid:cid Level:level Team:team]];

        NSString *assert = [NSString stringWithFormat:@"you forgot to make this component in CharacterBasicData.plist id:%@", cid];
        NSAssert([characterData objectForKey:@"SelectableComponent"] != nil, assert);
        
        [entity addComponent:[[SelectableComponent alloc] initWithDictionary:[characterData objectForKey:@"SelectableComponent"]]];
        
        NSArray *path = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:ccp(150,110)],[NSValue valueWithCGPoint:ccp(250,110)], nil];
        MovePathComponent *pathCom = [[MovePathComponent alloc] initWithMovePath:path];
        [entity addComponent:pathCom];
        
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateHeroWalk alloc] init]]];
    } else {
        // TODO: Set AI for different character
        [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateWalk alloc] init]]];
    }
        
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
    
    sprite.scale = 0.1;
    
    Entity *entity = [_entityManager createEntity];

    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.enableShadowPosition = YES;
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        [entity addComponent:physics];
        
        // Add Physics body
        b2Body *body = [self createBoxBodyWithSprite:sprite];
        body->SetUserData((__bridge void*)entity);
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        [physics.root addChild:physicsNode];
    }
    
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
    
    [entity addComponent:[[DirectionComponent alloc] initWithType:kDirectionTypeLeftRight velocity:ccp(team == 1 ? 1 : -1, 0)]];
    
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
            summon.summon = YES;
            [player.battleTeam addObject:summon];
        }
        
       MagicSkillComponent *magicSkillCom = [[MagicSkillComponent alloc] init];
        NSArray *magicTeamInitData = [FileManager sharedFileManager].magicTeam;
        
        for (CharacterInitData *data in magicTeamInitData) {
            Entity *magicButton = [self createMagicButton:data.cid level:data.level];
            
            MagicComponent *magicCom = (MagicComponent *)[magicButton getComponentOfClass:[MagicComponent class]];
            magicCom.spellCaster = entity;
            NSAssert(NSClassFromString(magicCom.name), @"you forgot to make this skill.");
            
            [magicSkillCom.magicTeam addObject:magicButton];
        }
        
        [entity addComponent:magicSkillCom];
        
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
    NSDictionary *damageAttribute = [characterData objectForKey:@"damage"];
    
    float cooldown = [[characterData objectForKey:@"cooldown"] floatValue];
    NSMutableDictionary *information = [NSMutableDictionary dictionaryWithDictionary:[characterData objectForKey:@"InformationComponent"]];
    
    //FIXME: change to correct name
    NSString *magicButtonName = [NSString stringWithFormat:@"%@_button.png",[information objectForKey:@"name"]];
    CCSprite *sprite = [CCSprite spriteWithFile:magicButtonName];
    
    Entity *entity = [_entityManager createEntity];
    
    
    MagicComponent *magicCom = [[MagicComponent alloc] initWithDamageAttribute:[[AccumulateAttribute alloc] initWithDictionary:damageAttribute] andMagicName:[information objectForKey:@"name"] andNeedImages:[characterData objectForKey:@"images"]];
    magicCom.cooldown = cooldown;
    
    [entity addComponent:magicCom];
    
    RenderComponent *renderCom = [[RenderComponent alloc] initWithSprite:sprite];
    
    NSString *assert = [NSString stringWithFormat:@"you forgot to make this component in CharacterBasicData.plist id:%@",cid];
    NSAssert([characterData objectForKey:@"CostComponent"] != nil, assert);
    
    [entity addComponent:[[CostComponent alloc] initWithDictionary:[characterData objectForKey:@"CostComponent"]]];
    
    [entity addComponent:renderCom];
    [entity addComponent:[[MaskComponent alloc] initWithRenderComponent:renderCom]];
    
    [entity addComponent:[[InformationComponent alloc] initWithInformation:information]];
    
    assert = [NSString stringWithFormat:@"you forgot to make this component in CharacterBasicData.plist id:%@",cid];
    NSAssert([characterData objectForKey:@"SelectableComponent"] != nil, assert);
    
    [entity addComponent:[[SelectableComponent alloc] initWithDictionary:[characterData objectForKey:@"SelectableComponent"]]];
    
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    return entity;
}

-(Entity *)createProjectileEntityWithEvent:(ProjectileEvent *)event forTeam:(int)team {
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    CGPoint velocity = ccpForAngle(CC_DEGREES_TO_RADIANS(event.spriteDirection));
    
    DirectionComponent *direction = [[DirectionComponent alloc] initWithType:kDirectionTypeAllSides velocity:velocity];
    direction.spriteDirection = event.spriteDirection;
    [entity addComponent:direction];
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:event.sprite];
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        physics.direction = direction;
        physics.directionNode = render.node;
        [entity addComponent:physics];
        
        event.range.owner = entity;
    }
    
    AIState *state = [[AIStateProjectile alloc] initWithProjectEvent:event];
    AIComponent *ai = [[AIComponent alloc] initWithState:state];
    [entity addComponent:ai];
     
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity toPosition:event.startPosition];
    }
    
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

-(b2Body *)createBoxBodyWithSprite:(CCNode *)sprite {
    NSAssert(_physicsSystem, @"You can not create a physics body without physics system!");
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
//    spriteBodyDef.userData = (__bridge void*)sprite;

    b2Body *spriteBody = _physicsSystem.world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    NSAssert(sprite.rotation == 0, @"You should rotate it after create a boxbody!");
    
    spriteShape.SetAsBox(sprite.boundingBox.size.width/PTM_RATIO/2, sprite.boundingBox.size.height/PTM_RATIO/2);
    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
//    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
    spriteShapeDef.filter.groupIndex = kPhisicsFixtureGroupEntity;
    
    spriteBody->CreateFixture(&spriteShapeDef);

    return spriteBody;
}

@end
