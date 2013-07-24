//
//  BattleController.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"
#import "BattleStatusLayer.h"
#import "HelloWorldLayer.h"
#import "CharacterBloodSprite.h"
#import "FileManager.h"
#import "SimpleAudioEngine.h"
#import "AchievementManager.h"
#import "BattleCatMapLayer.h"
#import "ThreeLineMapLayer.h"
#import "EntityManager.h"
#import "EntityFactory.h"
#import "PlayerSystem.h"
#import "AISystem.h"
#import "MoveSystem.h"
#import "ProjectileSystem.h"
#import "ActiveSkillSystem.h"
#import "CombatSystem.h"
#import "EffectSystem.h"
#import "DefenderComponent.h"
#import "PlayerComponent.h"
#import "PhysicsSystem.h"

#import "DrawPath.h"
#import "SelectableComponent.h"
#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "MagicSystem.h"
#import "MagicComponent.h"

@interface BattleController () {
    NSString *battleName;
    
    EntityManager *entityManager;
    EntityFactory *entityFactory;
}
@property (nonatomic) Entity *selectedEntity;
@end

@implementation BattleController

__weak static BattleController* currentInstance;

+(BattleController *)currentInstance {
    return currentInstance;
}

-(id)initWithPrefix:(int)prefix suffix:(int)suffix {
    if(self = [super init]) {
        currentInstance = self;
        
        battleName = [NSString stringWithFormat:@"%02d_%02d",prefix,suffix];
        
        _battleData = [[FileManager sharedFileManager] loadBattleInfo:[NSString stringWithFormat:@"%02d_%02d", prefix, suffix]];
        NSAssert(_battleData != nil, @"you do not load the correct battle's data.");
        
//        mapLayer = [[BattleCatMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
        mapLayer = [[ThreeLineMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
        [self addChild:mapLayer];
        
        entityManager = [[EntityManager alloc] init];
        entityFactory = [[EntityFactory alloc] initWithEntityManager:entityManager];
        entityFactory.mapLayer = mapLayer;
        
        PhysicsSystem *physicsSystem = [[PhysicsSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory];
        entityFactory.physicsSystem = physicsSystem;
        
        [self setCastle];
        
        _userPlayer = [entityFactory createPlayerForTeam:1];
        _enemyPlayer = [entityFactory createPlayerForTeam:2];
        
        systems = [[NSMutableArray alloc] init];
        [systems addObject:physicsSystem];
        [self setSystem];
        
        // init Dpad
        //        dPadLayer = [DPadLayer node];
        //        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];

        [self scheduleUpdate];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"sound_caf/bgm_battle%d.caf", prefix]];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.0f;
        
        [[CCDirector sharedDirector].view addGestureRecognizer:longPress];
    }
    return self;
}

-(void)dealloc {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    for (UIGestureRecognizer *recognizer in [CCDirector sharedDirector].view.gestureRecognizers) {
        [[CCDirector sharedDirector].view removeGestureRecognizer:recognizer];
    }
}

-(void)setCastle {
    _userCastle = [entityFactory createCastleForTeam:1];
    _enemyCastle = [entityFactory createCastleForTeam:2];
    
    // FIXME: Create by file
    
//    _playerCastle = [[FileManager sharedFileManager] getPlayerCastle];
//    _enemyCastle = [_battleData getEnemyCastle];
}

-(void)setSystem {
    [systems addObject:[[AISystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ActiveSkillSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MagicSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory mapLayer:mapLayer]];
    [systems addObject:[[CombatSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MoveSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory mapLayer:mapLayer]];
    [systems addObject:[[EffectSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ProjectileSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[PlayerSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
}

-(void)smoothMoveCameraTo:(CGPoint)position {
    [mapLayer.cameraControl smoothMoveTo:position duration:1.0f];
}

-(void)update:(ccTime)delta {
    for (System *system in systems) {
        [system update:delta];
    }
    
    // FIXME: As player component delegate?
    PlayerComponent *player = (PlayerComponent *)[_userPlayer getComponentOfClass:[PlayerComponent class]];
    [statusLayer updateFood:(int)player.food];
    [statusLayer updateMana:(int)player.mana];
    
    [self checkBattleEnd];
}

-(void)checkBattleEnd {
    if ([self isEntityDead:_userCastle]) {
        [statusLayer displayString:@"Lose!!" withColor:ccWHITE];
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    } else if ([self isEntityDead:_enemyCastle]) {
        [statusLayer displayString:@"Win!!" withColor:ccWHITE];
        
        [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_completed"]] Value:1];
        
        //FIXME: calculate the number of star.
        int stars = 2; // fix it.
        int oldStars = [[FileManager sharedFileManager].achievementManager getValueFromProperty:[battleName stringByAppendingString:@"_star"]];
        
        [[FileManager sharedFileManager].achievementManager resetPropertiesWithTags:@[battleName,@"star"]];
        if (oldStars < stars) {
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:stars];
        }else {
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:oldStars];
        }
        
        [[FileManager sharedFileManager].achievementManager checkAchievementsForTags:nil];
        
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    }
}

-(BOOL)isEntityDead:(Entity *)entity {
    DefenderComponent *defense = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
    
    if (defense.hp.currentValue == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void)endBattle {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

#pragma mark UILongPressGestureRecognizer

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    //start
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSArray *array = [entityManager getAllEntitiesPosessingComponentOfClass:[SelectableComponent class]];
        
        for (Entity *entity in array) {
            RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
            
            if (CGRectContainsPoint(renderCom.sprite.boundingBox, [renderCom.sprite.parent convertToNodeSpace:touchLocation])) {
                SelectableComponent *selectCom = (SelectableComponent *)[entity getComponentOfClass:[SelectableComponent class]];
                if (!selectCom.canSelect) {
                    continue;
                }
                self.selectedEntity = entity;
                [selectCom select];
                break;
            }
        }
    }
    
    // move
    if (!self.selectedEntity) {
        recognizer.cancelsTouchesInView = NO;
        return;
    }else {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            recognizer.cancelsTouchesInView = YES;
            [self drawSelectedRange:touchLocation];
        }
    }
    
    // end
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [statusLayer removeChildByTag:kDrawPathRangeSprite cleanup:YES];
        [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
        
        SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
        MovePathComponent *pathCom = (MovePathComponent *)[self.selectedEntity getComponentOfClass:[MovePathComponent class]];
        MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfClass:[MagicComponent class]];
        
//        if (magicCom) { // Hero hold this until next one is selected.
//            [selectCom unSelected];
//            self.selectedEntity = nil;
//        }

        [selectCom unSelected];
        self.selectedEntity = nil;
        
        // do not need start point.
        NSMutableArray *path = [[NSMutableArray alloc] init];
        //move and projectile event uses maplayer location
        [path addObject:[NSValue valueWithCGPoint:([mapLayer convertToNodeSpace:touchLocation])]];
        
        if (pathCom) {
            [pathCom.path removeAllObjects];
            [pathCom.path addObjectsFromArray:path];
        }else {
            if ([mapLayer canExecuteMagicInThisArea:[mapLayer convertToNodeSpace:touchLocation]]) {
                if (magicCom) {
                    [magicCom activeWithPath:path];
                }
            }
        }
        self.selectedEntity = nil;
    }
}

-(void)drawSelectedRange:(CGPoint)touchLocation {
    
    RenderComponent *renderCom = (RenderComponent *)[self.selectedEntity getComponentOfClass:[RenderComponent class]];
    
    NSMutableArray *drawPath = [[NSMutableArray alloc] init];
    [drawPath addObject:[NSValue valueWithCGPoint:([renderCom.node.parent convertToWorldSpace:renderCom.position])]];
    [drawPath addObject:[NSValue valueWithCGPoint:(touchLocation)]];
    
    DrawPath *line = [DrawPath node];
    line.path = drawPath;
    
    MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfClass:[MagicComponent class]];
    
    if (magicCom) {
        line.drawSize = magicCom.rangeSize;
    }else { //FIXME: fix correct size.
        line.drawSize = CGSizeMake(30, 30);
    }
    
    // draw range frame
    CCSprite *rangeFrame1 = [CCSprite spriteWithFile:@"rangeFrame_1.png"];
    CCSprite *rangeFrame2 = [CCSprite spriteWithFile:@"rangeFrame_2.png"];
    
    rangeFrame1.scaleX = line.drawSize.width / rangeFrame1.contentSize.width;
    rangeFrame1.scaleY = line.drawSize.height / rangeFrame1.contentSize.height;
    rangeFrame1.position = touchLocation;
    rangeFrame2.anchorPoint = ccp(0,0);
    
    [rangeFrame1 addChild:rangeFrame2];
    
    [rangeFrame2 setOpacity:1.0];
    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:0];
    CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
    CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
    [rangeFrame2 runAction:repeat];
    
    
    [statusLayer removeChildByTag:kDrawPathRangeSprite cleanup:YES];
    [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
    [statusLayer addChild:rangeFrame1 z:0 tag:kDrawPathRangeSprite];
    [statusLayer addChild:line z:0 tag:kDrawPathTag];
}

@end
