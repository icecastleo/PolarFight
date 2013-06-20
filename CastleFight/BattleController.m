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
        
        mapLayer = [[BattleCatMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
//        mapLayer = [[ThreeLineMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
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
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [[CCDirector sharedDirector].view addGestureRecognizer:pan];
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
}

#pragma mark UIPanGestureRecognizer

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
//    CGPoint touchLocation = [recognizer translationInView:recognizer.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    touchLocation = ccpSub(touchLocation, mapLayer.position);
    
    //start
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSArray *array = [entityManager getAllEntitiesPosessingComponentOfClass:[SelectableComponent class]];
        
        for (Entity *entity in array) {
            RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
            
            if (CGRectContainsPoint(renderCom.sprite.boundingBox, touchLocation)) {
                self.selectedEntity = entity;
                SelectableComponent *selectCom = (SelectableComponent *)[entity getComponentOfClass:[SelectableComponent class]];
                [selectCom show];
                break;
            }else {
                self.selectedEntity = nil;
            }
        }
    }
    
    NSMutableArray *path = [NSMutableArray new];
    RenderComponent *renderCom = (RenderComponent *)[self.selectedEntity getComponentOfClass:[RenderComponent class]];
    
    [path addObject:[NSValue valueWithCGPoint:(renderCom.sprite.position)]];
    [path addObject:[NSValue valueWithCGPoint:(touchLocation)]];
    
    //move
    if (!self.selectedEntity) {
        recognizer.cancelsTouchesInView = NO;
        return;
    }else {
        recognizer.cancelsTouchesInView = YES;
        
        [mapLayer removeChildByTag:kDrawPathTag cleanup:YES];
        
        DrawPath *line = [DrawPath node];
        line.path = path;
        [mapLayer addChild: line z:0 tag:kDrawPathTag];
    }
    
    //end
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
        [selectCom unSelected];
        [mapLayer removeChildByTag:kDrawPathTag cleanup:YES];
        
        MovePathComponent *pathCom = (MovePathComponent *)[self.selectedEntity getComponentOfClass:[MovePathComponent class]];
        if (pathCom) {
            [path removeObjectAtIndex:0];
            [pathCom.path removeAllObjects];
            [pathCom.path addObjectsFromArray:path];
        }
        self.selectedEntity = nil;
    }
}

@end
