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
#import "TouchSystem.h"
#import "OrbSystem.h"

#import "DrawPath.h"
#import "TouchComponent.h"
#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "MagicSystem.h"
#import "MagicComponent.h"
#import "SummonComponent.h"

#import "TopLineMapLayer.h"
#import "BattleCatMapLayer.h"
#import "ThreeLineMapLayer.h"

@interface BattleController () {
    int _prefix;
    
    NSString *battleName;
    
    EntityManager *entityManager;
    EntityFactory *entityFactory;
    
    TouchSystem *touchSystem;
}

@end

@implementation BattleController

__weak static BattleController* currentInstance;

+(BattleController *)currentInstance {
    return currentInstance;
}

-(id)initWithPrefix:(int)prefix suffix:(int)suffix {
    if(self = [super init]) {
        currentInstance = self;
        
        _prefix = prefix;
        
        battleName = [NSString stringWithFormat:@"%02d_%02d", prefix, suffix];
        
        _battleData = [[FileManager sharedFileManager] loadBattleInfo:[NSString stringWithFormat:@"%02d - %02d", prefix, suffix]];
        NSAssert(_battleData != nil, @"you do not load the correct battle's data.");
        
        //        mapLayer = [[BattleCatMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
        //        mapLayer = [[ThreeLineMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
        mapLayer = [[TopLineMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
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
        
        Entity *board = [entityFactory createOrbBoardWithOwner:_userPlayer andBattleData:_battleData];
        //        RenderComponent *boardRenderCom = (RenderComponent *)[board getComponentOfName:[RenderComponent name]];
        //        boardRenderCom.node.position = ccp(100,20);
        //        boardRenderCom.node.anchorPoint = ccp(0,0);
        //        boardRenderCom.sprite.anchorPoint = ccp(0,0);
        //        [(CCSprite *)boardRenderCom.sprite setOpacity:0];
        //        [statusLayer addChild:boardRenderCom.node];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    touchSystem = [[TouchSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:touchSystem priority:kTouchPriorityTouchSystem swallowsTouches:YES];
    
    //    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"sound_caf/bgm_battle%d.caf", _prefix]];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music_1.caf"];
}

-(void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:touchSystem];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    //    for (UIGestureRecognizer *recognizer in [CCDirector sharedDirector].view.gestureRecognizers) {
    //        [[CCDirector sharedDirector].view removeGestureRecognizer:recognizer];
    //    }
    //    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [super onExit];
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
    [systems addObject:[[MagicSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[CombatSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MoveSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[EffectSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ProjectileSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[PlayerSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[OrbSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
}

-(void)smoothMoveCameraTo:(CGPoint)position {
    [mapLayer.cameraControl smoothMoveTo:position duration:1.0f];
}

-(void)update:(ccTime)delta {
    for (System *system in systems) {
        [system update:delta];
    }
    
    [statusLayer update:delta];
    
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
        } else {
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:oldStars];
        }
        
        [[FileManager sharedFileManager].achievementManager checkAchievementsForTags:nil];
        
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    }
}

-(BOOL)isEntityDead:(Entity *)entity {
    DefenderComponent *defense = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
    
    if (defense.hp.currentValue == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void)endBattle {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

//-(void)drawSelectedRange:(CGPoint)touchLocation {
//
//    RenderComponent *renderCom = (RenderComponent *)[self.selectedEntity getComponentOfName:[RenderComponent name]];
//
//    TouchComponent *selectCom = (TouchComponent *)[self.selectedEntity getComponentOfName:[TouchComponent name]];
//
//    if (selectCom.hasDragLine) {
//        NSMutableArray *drawPath = [[NSMutableArray alloc] init];
//        [drawPath addObject:[NSValue valueWithCGPoint:([renderCom.node.parent convertToWorldSpace:renderCom.position])]];
//        [drawPath addObject:[NSValue valueWithCGPoint:(touchLocation)]];
//        DrawPath *line = [DrawPath node];
//        line.path = drawPath;
//        [statusLayer addChild:line z:0 tag:kDrawPathTag];
//    }
//
//    MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfName:[MagicComponent name]];
//
//    float rotation = 0;
//    CGSize drawSize;
//
//    if (magicCom) {
//        drawSize = magicCom.rangeSize;
//    } else {
//        drawSize = CGSizeMake(30, 30);
//        // Determine angle to Hero
//        CGPoint position = [renderCom.node.parent convertToWorldSpace:renderCom.position];
//        float offRealY = touchLocation.y - position.y;
//        float offRealX = touchLocation.x - position.x;
//        float angleRadians = atanf((float)offRealY / (float)offRealX);
//        float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
//        rotation = -1 * angleDegrees;
//        if (offRealX <= 0) {
//            rotation -= 180;
//        }
//    }
//
//    // draw range frame
//    CCSprite *rangeFrame1;
//    CCSprite *rangeFrame2;
//
//    SummonComponent *summonCom = (SummonComponent *)[self.selectedEntity getComponentOfName:[SummonComponent name]];
//    if (summonCom) {
//        rangeFrame1 = [CCSprite spriteWithSpriteFrameName:selectCom.dragImage1];
//        rangeFrame2 = [CCSprite spriteWithSpriteFrameName:selectCom.dragImage2];
//        [rangeFrame1 setOpacity:128];
//        [rangeFrame2 setOpacity:0];
//    }else {
//        rangeFrame1 = [CCSprite spriteWithFile:selectCom.dragImage1];
//
//        rangeFrame1.scaleX = drawSize.width / rangeFrame1.contentSize.width;
//        rangeFrame1.scaleY = drawSize.height / rangeFrame1.contentSize.height;
//
//        if (![mapLayer canExecuteMagicInThisArea:[mapLayer convertToNodeSpace:touchLocation]]) {
//            rangeFrame2 = [CCSprite spriteWithFile:@"forbidden_sign.png"];
//        }else {
//            rangeFrame2 = [CCSprite spriteWithFile:selectCom.dragImage2];
//        }
//
//        [rangeFrame2 setOpacity:255];
//        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:0];
//        CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
//        CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
//        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
//        [rangeFrame2 runAction:repeat];
//    }
//
//    rangeFrame1.rotation = rotation;
//    rangeFrame1.position = touchLocation;
//    rangeFrame2.anchorPoint = ccp(0,0);
//    [rangeFrame1 addChild:rangeFrame2];
//
//    [statusLayer addChild:rangeFrame1 z:0 tag:kDrawPathRangeSprite];
//
//}
//
//-(void)removeStatusLayerChild {
//    if ([statusLayer getChildByTag:kDrawPathRangeSprite]) {
//        [statusLayer removeChildByTag:kDrawPathRangeSprite cleanup:YES];
//    }
//    if ([statusLayer getChildByTag:kDrawPathTag]) {
//        [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
//    }
//}

@end
