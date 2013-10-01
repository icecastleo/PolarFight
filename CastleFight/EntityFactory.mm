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
#import "BattleDataObject.h"
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
#import "GeneralAIStateWalk.h"
#import "MinionAIStateWalk.h"
#import "GroupComponent.h"

#import "TouchComponent.h"
#import "MovePathComponent.h"
#import "InformationComponent.h"
#import "MagicSkillComponent.h"
#import "MagicComponent.h"
#import "MaskComponent.h"
#import "OrbComponent.h"
#import "OrbBoardComponent.h"

#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PhysicsRoot.h"
#import "PhysicsNode.h"
#import "Box2D.h"

#import "CCSkeletonAnimation.h"


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
    return [self createCharacter:cid level:level forTeam:team scale:1.0];
}

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team scale:(float)scale {
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
    
    NSString *name = [characterData objectForKey:@"name"];
    int cost = [[characterData objectForKey:@"cost"] intValue];
    NSDictionary *attributes = [characterData objectForKey:@"attributes"];
    NSDictionary *activeSkills = [characterData objectForKey:@"activeSkills"];
    NSDictionary *passiveSkills = [characterData objectForKey:@"passiveSkills"];
    NSDictionary *auras = [characterData objectForKey:@"auras"];
//    NSDictionary *aiDictionary = [characterData objectForKey:@"AIComponent"];
    
    Entity *entity = [_entityManager createEntity];    
    [entity addComponent:[[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeGeneral name:name]];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[CostComponent alloc] initWithFood:cost mana:0]];
    
//    if ([cid intValue]/100 != 2) {
//        //hero doesn't need to change line.
//        [entity addComponent:[[LineComponent alloc] init]];
//    }
    
    DirectionComponent *direction = [[DirectionComponent alloc] initWithType:kDirectionTypeLeftRight velocity:ccp(team == kPlayerTeam ? 1 : -1, 0)];
    // FIXME: Change all character asset to right
    direction.spriteDirection = (team == kPlayerTeam ? kSpriteDirectionRight : kSpriteDirectionLeft);
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
        CCSkeletonAnimation *animationNode = [CCSkeletonAnimation skeletonWithFile:@"fly_bear.json" atlasFile:@"fly_bear.atlas" scale:1.0];
        [animationNode updateWorldTransform];
        sprite = animationNode;
        scale *= 0.1;
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
    }
    
    sprite.scale = scale;
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.enableShadowPosition = YES;
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        physics.direction = direction;
        [entity addComponent:physics];
        
        // Add Physics body
        b2Body *body = [self createBoxBodyWithEntity:entity];
        body->SetUserData((__bridge void*)entity);
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        [physics.root addChild:physicsNode];
    }
    
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:[self animationsByCharacterName:name]]];
    
    MoveComponent *move = [[MoveComponent alloc] initWithSpeedAttribute:[[Attribute alloc] initWithDictionary:[attributes objectForKey:@"speed"]]];
    [entity addComponent:move];
        
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
        NSAssert([characterData objectForKey:@"TouchComponent"] != nil, assert);
        
        [entity addComponent:[[TouchComponent alloc] initWithDictionary:[characterData objectForKey:@"TouchComponent"]]];
        
        NSArray *path = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:ccp(50,110)],[NSValue valueWithCGPoint:ccp(250,110)], nil];
        MovePathComponent *pathCom = [[MovePathComponent alloc] initWithMovePath:path];
        [entity addComponent:pathCom];
    }
    
    // TODO: Set AI for different character
//    [entity addComponent:[[AIComponent alloc] initWithDictionary:aiDictionary]];

    AIComponent *ai = [[AIComponent alloc] initWithState:[[GeneralAIStateWalk alloc] init]];
    [entity addComponent:ai];
    
    // Level component should be set after all components that contained attributes.
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    //    [_entityManager addComponent:[[PlayerComponent alloc] init] toEntity:entity];
    
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity];
    }
    
    return entity;
}

-(Entity *)createMinion:(NSString *)cid level:(int)level forTeam:(int)team withGeneral:(Entity *)general {
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
    
    NSString *name = [characterData objectForKey:@"name"];
//    int cost = [[characterData objectForKey:@"cost"] intValue];
    NSDictionary *attributes = [characterData objectForKey:@"attributes"];
    NSDictionary *activeSkills = [characterData objectForKey:@"activeSkills"];
//    NSDictionary *passiveSkills = [characterData objectForKey:@"passiveSkills"];
//    NSDictionary *auras = [characterData objectForKey:@"auras"];
    
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    CharacterComponent *character = [[CharacterComponent alloc] initWithCid:cid type:kCharacterTypeMinion name:name];
    [entity addComponent:character];
    
    for (Entity *player in [entity getAllEntitiesPosessingComponentOfName:[PlayerComponent name]]) {
        TeamComponent *pTeam = (TeamComponent *)[player getComponentOfName:[TeamComponent name]];
        
        if (pTeam.team == team) {
            PlayerComponent *pPlayer = (PlayerComponent *)[player getComponentOfName:[PlayerComponent name]];
            character.player = pPlayer;
        }
    }
    
    DirectionComponent *direction = [[DirectionComponent alloc] initWithType:kDirectionTypeLeftRight velocity:ccp(team == kPlayerTeam ? 1 : -1, 0)];
    // FIXME: Change all character asset to right
    direction.spriteDirection = (team == kPlayerTeam ? kSpriteDirectionRight : kSpriteDirectionLeft);
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
        CCSkeletonAnimation *animationNode = [CCSkeletonAnimation skeletonWithFile:@"fly_bear.json" atlasFile:@"fly_bear.atlas" scale:1.0];
        [animationNode updateWorldTransform];
        sprite = animationNode;
        sprite.scale = 0.03;
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
        sprite.scale = 0.3;
    }
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.enableShadowPosition = YES;
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        physics.direction = direction;
        [entity addComponent:physics];
        
        // Add Physics body
        b2Body *body = [self createBoxBodyWithEntity:entity];
        body->SetUserData((__bridge void*)entity);
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        [physics.root addChild:physicsNode];
    }
    
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:[self animationsByCharacterName:name]]];
    
    MoveComponent *move = [[MoveComponent alloc] initWithSpeedAttribute:[[Attribute alloc] initWithDictionary:[attributes objectForKey:@"speed"]]];
    [entity addComponent:move];
    
    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
                          [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"attack"]]]];
    
    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"hp"]]];
    [entity addComponent:defenseCom];
    
    defenseCom.defense = [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"defense"]];
    defenseCom.armorType = kArmorNoraml;
//    defenseCom.bloodSprite = [[CharacterBloodSprite alloc] initWithEntity:entity];
    
    [entity addComponent:[[ProjectileComponent alloc] init]];
    
    ActiveSkillComponent *skillCom = [[ActiveSkillComponent alloc] init];
    
    for (NSString *key in activeSkills.allKeys) {
        NSString *value = [activeSkills valueForKey:key];
        NSAssert(NSClassFromString(value), @"you forgot to make this skill.");
        [skillCom.skills setObject:[[NSClassFromString(value) alloc] init] forKey:key];
    }
    
    if (skillCom.skills.count > 0) {
        // Some entity might not have agile attribute
        if ([attributes objectForKey:@"agile"]) {
            Attribute *agile = [[Attribute alloc] initWithDictionary:[attributes objectForKey:@"agile"]];
            skillCom.agile = agile;
        }
        [entity addComponent:skillCom];
    }
    
    AIComponent *ai = [[AIComponent alloc] initWithState:[[MinionAIStateWalk alloc] initWithGeneral:general]];
    [entity addComponent:ai];
    
    // Level component should be set after all components that contained attributes.
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity];
    }
    
    return entity;
}


-(void)createGroupCharacter:(NSString *)cid withCount:(int)count forTeam:(int)team {
    // TODO: 前排，後排，count系數
    
    NSMutableArray *groupEntities = [[NSMutableArray alloc] init];
    
    Entity *entity = [self createCharacter:cid level:5 forTeam:team scale:0.6];
    entity.position = ccp(arc4random_uniform(240) + (team == 1 ? 0 : 240), arc4random_uniform(200) + kMapPathFloor);
    
    GroupComponent *group = [[GroupComponent alloc] initWithGroupArray:groupEntities];
    [entity addComponent:group];
    
    [groupEntities addObject:entity];
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    
    for (int i = 0; i < count/3; i++) {
        Entity *minion = [self createMinion:cid level:1 forTeam:team withGeneral:entity];
        
        GroupComponent *group = [[GroupComponent alloc] initWithGroupArray:groupEntities];
        [minion addComponent:group];

        [groupEntities addObject:minion];
        
        while (YES) {
            CGPoint temp = ccp(CCRANDOM_MINUS1_1() * render.sprite.boundingBox.size.width*2, CCRANDOM_MINUS1_1() * render.sprite.boundingBox.size.height*2);
            
            if (ccpLength(temp) > MAX(render.sprite.boundingBox.size.width/3, render.sprite.boundingBox.size.height/3) && ccpLength(temp) < MAX(render.sprite.boundingBox.size.width/2, render.sprite.boundingBox.size.height/2)) {
                minion.position = ccpAdd(render.position, temp);
                break;
            }
        }
    }
}

-(Entity *)createCastleForTeam:(int)team {

    // TODO: Get castle data
    
//    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
//    NSDictionary *attributes = [characterData objectForKey:@"attributes"];
    
    CCSprite *sprite;

    if (team == kPlayerTeam) {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"building_user_home_01.png"]];
    } else {
        sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"building_enemy_home.png"]];
    }

    sprite.scale = 0.5;
    
//    sprite = [CCSprite spriteWithFile:@"wall.png"];
    
//    sprite.scaleX = kMapStartDistance/2/sprite.contentSize.width;
//    sprite.scaleY = [CCDirector sharedDirector].winSize.height/sprite.contentSize.height;
    
    
    Entity *entity = [_entityManager createEntity];

    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.enableShadowPosition = YES;
    [entity addComponent:render];
    
    if (_physicsSystem) {
        PhysicsComponent *physics = [[PhysicsComponent alloc] initWithPhysicsSystem:_physicsSystem renderComponent:render];
        [entity addComponent:physics];
        
        // Add Physics body
        b2Body *body = [self createBoxBodyWithEntity:entity];
        body->SetUserData((__bridge void*)entity);
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        [physics.root addChild:physicsNode];
    }
    
    [entity addComponent:[[AnimationComponent alloc] initWithAnimations:nil]];

//    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
//                          [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"attack"]]]];
    
    // TODO: Link with map data?
    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithQuadratic:0 linear:0 constantTerm:5000000 isFluctuant:YES]];
    [entity addComponent:defenseCom];
    
    // TODO: Init by file
//    DefenderComponent *defenseCom = [[DefenderComponent alloc] initWithHpAttribute:[[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"hp"]]];
//    defenseCom.defense = [[AccumulateAttribute alloc] initWithDictionary:[attributes objectForKey:@"defense"]];
    
    defenseCom.armorType = kArmorNoraml;
    defenseCom.bloodSprite = [[CastleBloodSprite alloc] initWithEntity:entity];
    
    [entity addComponent:[[CollisionComponent alloc] initWithBoundingBox:sprite.boundingBox]];
    
    [entity addComponent:[[DirectionComponent alloc] initWithType:kDirectionTypeLeftRight velocity:ccp(team == kPlayerTeam ? 1 : -1, 0)]];
    
    if (self.mapLayer) {
        [self.mapLayer addEntity:entity];
    }
    
    return entity;
}

-(Entity *)createUserPlayerForTeam:(int)team {
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    // TODO: Set by file
    PlayerComponent *player = [[PlayerComponent alloc] init];
    [entity addComponent:player];
    
    NSArray *characterInitDatas = [FileManager sharedFileManager].characterInitDatas;
    
    for (CharacterInitData *data in characterInitDatas) {
        Entity *summonButton = [self createSummonButton:data];
        MagicComponent *magicCom = (MagicComponent *)[summonButton getComponentOfName:[MagicComponent name]];
        magicCom.spellCaster = entity;
        [summonButton addComponent:[[TeamComponent alloc] initWithTeam:team]];
        
        [player.summonComponents addObject:summonButton];
    }
    
    NSArray *battleTeamInitData = [FileManager sharedFileManager].battleTeam;
    for (CharacterInitData *data in battleTeamInitData) {
        SummonComponent *summon = [[SummonComponent alloc] initWithCharacterInitData:data];
        summon.player = player;
        //            summon.summon = YES;
        [player.battleTeam addObject:summon];
    }
    
    MagicSkillComponent *magicSkillCom = [[MagicSkillComponent alloc] init];
    NSArray *magicTeamInitData = [FileManager sharedFileManager].magicTeam;
    
    for (CharacterInitData *data in magicTeamInitData) {
        Entity *magicButton = [self createMagicButton:data.cid level:data.level team:team];
        
        MagicComponent *magicCom = (MagicComponent *)[magicButton getComponentOfName:[MagicComponent name]];
        magicCom.spellCaster = entity;
        NSAssert(NSClassFromString(magicCom.name), @"You forgot to make this skill.");
        
        [magicSkillCom.magicTeam addObject:magicButton];
    }
    
    [entity addComponent:magicSkillCom];
    
    [entity addComponent:[[AttackerComponent alloc] initWithAttackAttribute:
                          nil]];
    
    [entity addComponent:[[ProjectileComponent alloc] init]];
    
    return entity;
}

-(Entity *)createEnemyPlayerForTeam:(int)team battleData:(BattleDataObject *)battleData {
    Entity *entity = [_entityManager createEntity];
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    
    // TODO: Set by file
    PlayerComponent *player = [[PlayerComponent alloc] init];
    [entity addComponent:player];
    
//    [entity addComponent:[[AIComponent alloc] initWithState:[[AIStateEnemyPlayer alloc] initWithEntityFactory:self battleDataObject:battleData]]];
    
    return entity;
}

-(Entity *)createMagicButton:(NSString *)cid level:(int)level team:(int)team {
    
    Entity *entity = [_entityManager createEntity];
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:cid];
    NSString *assert = [NSString stringWithFormat:@"you forgot to make this component in CharacterBasicData.plist id:%@",cid];
    
    for (NSString *key in characterData) {
        NSDictionary *dic = [characterData objectForKey:key];
        if ([key isEqualToString:@"RenderComponent"]) {
            CCSprite *sprite = [CCSprite spriteWithFile:[dic objectForKey:@"sprite"]];
            RenderComponent *renderCom = [[RenderComponent alloc] initWithSprite:sprite];
            [entity addComponent:renderCom];
            [entity addComponent:[[MaskComponent alloc] initWithRenderComponent:renderCom]];
        }else {
            NSAssert(NSClassFromString(key), assert);
            [entity addComponent:[[NSClassFromString(key) alloc] initWithDictionary:dic]];
        }
    }
    
    TouchComponent *selectCom = (TouchComponent *)[entity getComponentOfName:[TouchComponent name]];
    MagicComponent *magicCom = (MagicComponent *)[entity getComponentOfName:[MagicComponent name]];
    selectCom.delegate = magicCom;
    
    [entity addComponent:[[TeamComponent alloc] initWithTeam:team]];
    [entity addComponent:[[LevelComponent alloc] initWithLevel:level]];
    
    return entity;
}

-(Entity *)createSummonButton:(CharacterInitData *)data {
    
    Entity *entity = [_entityManager createEntity];
    
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:data.cid];
    
    // add SummonComponent
    SummonComponent *summonCom = [[SummonComponent alloc] initWithCharacterInitData:data];
    [entity addComponent:summonCom];
    
    // add CostComponent
    NSDictionary *costDic = [[NSDictionary alloc] initWithObjectsAndKeys:[characterData objectForKey:@"cost"],@"food", @"Food",@"costType", nil];
    CostComponent *costCom = [[CostComponent alloc] initWithDictionary:costDic];
    [entity addComponent:costCom];
    
    // add MagicComponent
    NSDictionary *magicDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:summonCom.cooldown], @"cooldown", @"SummonToLineMagic",@"magicName", nil];
    MagicComponent *magicCom = [[MagicComponent alloc] initWithDictionary:magicDic];
    [entity addComponent:magicCom];
    
    // add button icon in Render Component 
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_char_%02d.png",[data.cid intValue]]];
    RenderComponent *renderCom = [[RenderComponent alloc] initWithSprite:sprite];
    [entity addComponent:renderCom];
    [entity addComponent:[[MaskComponent alloc] initWithRenderComponent:renderCom]];
    
    // add show range Image in Selectable component
    NSString *name = [characterData objectForKey:@"name"];
    NSString *spriteFrameName;
    if ([name hasPrefix:@"user"] || [name hasPrefix:@"enemy"] || [name hasPrefix:@"hero"] || [name hasPrefix:@"boss"]) {
        spriteFrameName = [NSString stringWithFormat:@"%@_move_01.png", name];
    } else {
        spriteFrameName = [NSString stringWithFormat:@"%@_0.png", name];
    }
    NSDictionary *selectDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"gold_frame.png", @"selectedImage", [NSNumber numberWithBool:NO],@"hasDragLine", spriteFrameName,@"dragImage1", spriteFrameName,@"dragImage2",nil];
    TouchComponent *selectCom = [[TouchComponent alloc] initWithDictionary:selectDic];
    selectCom.delegate = magicCom;
    [entity addComponent:selectCom];
    
    [entity addComponent:[[LevelComponent alloc] initWithLevel:data.level]];
    
    return entity;
}

-(Entity *)createOrb:(NSString *)orbId {
    Entity *entity = [_entityManager createEntity];
    
    NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:orbId];
    
    CCSprite *sprite;
    
    NSDictionary *renderDic = [characterData objectForKey:@"RenderComponent"];
    if (renderDic) {
        sprite = [CCSprite spriteWithFile:[renderDic objectForKey:@"sprite"]];
    } else {
        sprite = [[CCSprite alloc] init];
    }
    
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    render.sprite.scale = kOrbWidth/render.sprite.boundingBox.size.width;
    [entity addComponent:render];
    
    NSDictionary *orbDic = [characterData objectForKey:@"OrbComponent"];
    NSString *type = [orbDic objectForKey:@"type"];
    
    OrbComponent *orbCom = [[NSClassFromString(type) alloc] initWithDictionary:orbDic];
//    OrbComponent *orbCom = [[OrbComponent alloc] initWithDictionary:orbDic];
    [entity addComponent:orbCom];
    
    int summonIndex = [[orbDic objectForKey:@"summonIndex"] intValue];
    
    if (summonIndex >= 0) {
        NSArray *battleTeamInitData = [FileManager sharedFileManager].battleTeam;
        CharacterInitData *data = [battleTeamInitData objectAtIndex:summonIndex];
        
        orbCom.summonData = data;
        
        // FIXME: Link with User data's battle team
        NSDictionary *cData = [[FileManager sharedFileManager] getCharacterDataWithCid:data.cid];
        NSString *name = [cData objectForKey:@"name"];
        
        if (name) {
            NSString *spriteFrameName = nil;
            
            if ([name hasPrefix:@"user"] || [name hasPrefix:@"enemy"] || [name hasPrefix:@"hero"] || [name hasPrefix:@"boss"]) {
                spriteFrameName = [NSString stringWithFormat:@"%@_move_01.png", name];
            } else {
                spriteFrameName = [NSString stringWithFormat:@"%@_0.png", name];
            }
            
            CCSprite *character = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
            character.position = ccpSub(ccp(sprite.contentSize.width/2, sprite.contentSize.height/2), character.offsetPosition);
            
            if (character.boundingBox.size.width > character.boundingBox.size.height) {
                character.scale = kOrbWidth/character.boundingBox.size.width/render.sprite.scale*0.75;
            } else {
                character.scale = kOrbHeight/character.boundingBox.size.height/render.sprite.scale*0.75;
            }
            [sprite addChild:character];
        }
    }
    
    NSDictionary *touchDic = [characterData objectForKey:@"TouchComponent"];
    if (touchDic) {
        TouchComponent *touchCom = [[TouchComponent alloc] initWithDictionary:touchDic];
        touchCom.delegate = orbCom;
        [entity addComponent:touchCom];
    }
    
    // TODO: Use CCSpriteBatchNode to put orb!
    if (self.mapLayer) {
        [self.mapLayer addChild:render.node];
    }
    
    return entity;
}

-(Entity *)createOrbBoardWithUser:(Entity *)player AIPlayer:(Entity *)aiPlayer andBattleData:(BattleDataObject *)battleData {
    Entity *entity = [_entityManager createEntity];
    
    CCSprite *sprite = [[CCSprite alloc] init];
    RenderComponent *render = [[RenderComponent alloc] initWithSprite:sprite];
    [entity addComponent:render];
//
//    sprite.opacity = 0;
    
    OrbBoardComponent *orbBoardCom = [[OrbBoardComponent alloc] initWithEntityFactory:self player:player aiPlayer:aiPlayer BattleData:battleData];
    [entity addComponent:orbBoardCom];
    
    NSAssert(self.mapLayer, @"Orb system use a ccaction to support!");
    [self.mapLayer addChild:render.node];
    
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

-(b2Body *)createBoxBodyWithEntity:(Entity *)entity {
    NSAssert(_physicsSystem, @"You can not create a physics body without physics system!");
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    CCNode *sprite = render.sprite;
    
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
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    if (team) {
        spriteShapeDef.filter.categoryBits = pow(2, team.team);
    }
    
    spriteBody->CreateFixture(&spriteShapeDef);

    return spriteBody;
}

@end
