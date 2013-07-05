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
        
        [self setCastle];
        
        _userPlayer = [entityFactory createPlayerForTeam:1];
        _enemyPlayer = [entityFactory createPlayerForTeam:2];
        
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

-(void)setCastle {
    _userCastle = [entityFactory createCastleForTeam:1];
    _enemyCastle = [entityFactory createCastleForTeam:2];
    
    // FIXME: Create by file
    
//    _playerCastle = [[FileManager sharedFileManager] getPlayerCastle];
//    _enemyCastle = [_battleData getEnemyCastle];
}

-(void)setSystem {
    systems = [[NSMutableArray alloc] init];
    
    [systems addObject:[[PlayerSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[AISystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ActiveSkillSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[CombatSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MoveSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory mapLayer:mapLayer]];
    [systems addObject:[[ProjectileSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[EffectSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MagicSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory mapLayer:mapLayer]];
}

-(void)smoothMoveCameraTo:(CGPoint)position {
    [mapLayer.cameraControl smoothMoveTo:position duration:1.0f];
}

-(void)update:(ccTime)delta {
    for (System *system in systems) {
//        double time = CACurrentMediaTime();
        [system update:delta];
//        CCLOG(@"%@ : %f", NSStringFromClass([system class]), CACurrentMediaTime() - time);
    }
    
    // FIXME: As player component delegate?
    PlayerComponent *player = (PlayerComponent *)[_userPlayer getComponentOfClass:[PlayerComponent class]];
    [statusLayer updateFood:(int)player.food];
    
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

-(void)dealloc {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    for (UIGestureRecognizer *recognizer in [CCDirector sharedDirector].view.gestureRecognizers) {
        [[CCDirector sharedDirector].view removeGestureRecognizer:recognizer];
    }
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
                [selectCom show];
                break;
            }
        }
    }
    
    RenderComponent *renderCom = (RenderComponent *)[self.selectedEntity getComponentOfClass:[RenderComponent class]];
    
    // move
    if (!self.selectedEntity) {
        recognizer.cancelsTouchesInView = NO;
        return;
    }else {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            recognizer.cancelsTouchesInView = YES;
            
            NSMutableArray *drawPath = [[NSMutableArray alloc] init];
            [drawPath addObject:[NSValue valueWithCGPoint:([renderCom.node.parent convertToWorldSpace:renderCom.position])]];
            [drawPath addObject:[NSValue valueWithCGPoint:(touchLocation)]];
            
            DrawPath *line = [DrawPath node];
            line.path = drawPath;
            
            [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
            [statusLayer addChild: line z:0 tag:kDrawPathTag];
        }
    }
    
    // end
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
        
        SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
        [selectCom unSelected];
        
        MovePathComponent *pathCom = (MovePathComponent *)[self.selectedEntity getComponentOfClass:[MovePathComponent class]];
        
        // do not need start point.
        NSMutableArray *path = [[NSMutableArray alloc] init];
        
        if (pathCom) {
            [pathCom.path removeAllObjects];
            //move uses maplayer location
            [path addObject:[NSValue valueWithCGPoint:([mapLayer convertToNodeSpace:touchLocation])]];
            [pathCom.path addObjectsFromArray:path];
        }else {
            if ([mapLayer canExecuteMagicInThisArea:[mapLayer convertToNodeSpace:touchLocation]]) {
                // projectile event uses world location.
                [path addObject:[NSValue valueWithCGPoint:(touchLocation)]];
                MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfClass:[MagicComponent class]];
                if (magicCom) {
                    [magicCom activeByEntity:self.userPlayer andPath:path];
                }
            }
        }
        
        self.selectedEntity = nil;
    }
}

@end
