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
#import "SummonComponent.h"

@interface BattleController () {
    int _prefix;
    
    NSString *battleName;
    NSUInteger fingerOneHash;
    
    EntityManager *entityManager;
    EntityFactory *entityFactory;
}

@property (nonatomic) Entity *selectedEntity;
@property (nonatomic) BOOL isEntitySelected;

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
                
        fingerOneHash = 0;
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"sound_caf/bgm_battle%d.caf", _prefix]];
    
    [self registerWithTouchDispatcher];
}

-(void)onExit {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    for (UIGestureRecognizer *recognizer in [CCDirector sharedDirector].view.gestureRecognizers) {
        [[CCDirector sharedDirector].view removeGestureRecognizer:recognizer];
    }
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [super onExit];
}

#pragma mark CCTouchDelegate
-(void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriorityBattleController swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch.tapCount == 1 && fingerOneHash == 0){
        fingerOneHash = [touch hash];
        CGPoint touchLocation = [touch locationInView:[touch view]];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        NSArray *array = [entityManager getAllEntitiesPosessingComponentOfClass:[SelectableComponent class]];
        
        for (Entity *entity in array) {
            RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
            
            if (CGRectContainsPoint(renderCom.sprite.boundingBox, [renderCom.sprite.parent convertToNodeSpace:touchLocation])) {
                SelectableComponent *preSelectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
                SelectableComponent *selectCom = (SelectableComponent *)[entity getComponentOfClass:[SelectableComponent class]];
                if (selectCom.canSelect) {
                    [preSelectCom unSelected];
                    self.isEntitySelected = YES;
                    self.selectedEntity = entity;
                    selectCom.touchType = kTapType;
                    [selectCom select];
                    break;
                }
            }
        }
        
        return YES;
    }
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    if (fingerOneHash == [touch hash]) {
        if (self.isEntitySelected) {
            SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
            selectCom.touchType = kDragType;
            [self removeStatusLayerChild];
            [self drawSelectedRange:touchLocation];
        }else {
            // might give the touch to map
            fingerOneHash = 0;
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    if (fingerOneHash == [touch hash]){
        
        if (self.selectedEntity) {
            SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
            MovePathComponent *pathCom = (MovePathComponent *)[self.selectedEntity getComponentOfClass:[MovePathComponent class]];
            
            switch (selectCom.touchType) {
                case kNoTouchType: {
                    [self drawSelectedRange:touchLocation];
                    [self performSelector:@selector(removeStatusLayerChild) withObject:nil afterDelay:0.1];
                    
                    // do not need start point.
                    NSMutableArray *path = [[NSMutableArray alloc] init];
                    //move and projectile event uses maplayer location
                    [path addObject:[NSValue valueWithCGPoint:([mapLayer convertToNodeSpace:touchLocation])]];
                    
                    if (pathCom) {
                        [pathCom.path removeAllObjects];
                        [pathCom.path addObjectsFromArray:path];
                    }
                    break;
                }
                case kTapType: {
                    
                    break;
                }
                case kDragType: {
                    self.isEntitySelected = NO;
                    [self removeStatusLayerChild];
                    
                    MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfClass:[MagicComponent class]];
                    SummonComponent *summonCom = (SummonComponent *)[self.selectedEntity getComponentOfClass:[SummonComponent class]];
                    
                    if (magicCom) { // Hero hold this until next one is selected.
                        [selectCom unSelected];
                        self.selectedEntity = nil;
                    }
                    
                    // do not need start point.
                    NSMutableArray *path = [[NSMutableArray alloc] init];
                    // move and projectile event uses maplayer location
                    [path addObject:[NSValue valueWithCGPoint:([mapLayer convertToNodeSpace:touchLocation])]];
                    
                    if (pathCom) {
                        [pathCom.path removeAllObjects];
                        [pathCom.path addObjectsFromArray:path];
                    } else {
                        if (summonCom && magicCom) {
                            if ([(ThreeLineMapLayer *)mapLayer canSummonCharacterInThisArea:[mapLayer convertToNodeSpace:touchLocation]]) {
                                [magicCom activeWithPath:path];
                            }
                        }else if ([mapLayer canExecuteMagicInThisArea:[mapLayer convertToNodeSpace:touchLocation]] && magicCom) {
                            [magicCom activeWithPath:path];
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            selectCom.touchType = kNoTouchType;
        }
        
        fingerOneHash = 0;
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    fingerOneHash = 0;
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
        } else {
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

-(void)drawSelectedRange:(CGPoint)touchLocation {
    
    RenderComponent *renderCom = (RenderComponent *)[self.selectedEntity getComponentOfClass:[RenderComponent class]];
    
    SelectableComponent *selectCom = (SelectableComponent *)[self.selectedEntity getComponentOfClass:[SelectableComponent class]];
    
    if (selectCom.hasDragLine) {
        NSMutableArray *drawPath = [[NSMutableArray alloc] init];
        [drawPath addObject:[NSValue valueWithCGPoint:([renderCom.node.parent convertToWorldSpace:renderCom.position])]];
        [drawPath addObject:[NSValue valueWithCGPoint:(touchLocation)]];
        DrawPath *line = [DrawPath node];
        line.path = drawPath;
        [statusLayer addChild:line z:0 tag:kDrawPathTag];
    }
    
    MagicComponent *magicCom = (MagicComponent *)[self.selectedEntity getComponentOfClass:[MagicComponent class]];
    
    float rotation = 0;
    CGSize drawSize;
    
    if (magicCom) {
        drawSize = magicCom.rangeSize;
    }else {
        drawSize = CGSizeMake(30, 30);
        // Determine angle to Hero
        CGPoint position = [renderCom.node.parent convertToWorldSpace:renderCom.position];
        float offRealY = touchLocation.y - position.y;
        float offRealX = touchLocation.x - position.x;
        float angleRadians = atanf((float)offRealY / (float)offRealX);
        float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
        rotation = -1 * angleDegrees;
        if (offRealX <= 0) {
            rotation -= 180;
        }
    }
    
    // draw range frame
    CCSprite *rangeFrame1;
    CCSprite *rangeFrame2;
    
    SummonComponent *summonCom = (SummonComponent *)[self.selectedEntity getComponentOfClass:[SummonComponent class]];
    if (summonCom) {
        rangeFrame1 = [CCSprite spriteWithSpriteFrameName:selectCom.dragImage1];
        rangeFrame2 = [CCSprite spriteWithSpriteFrameName:selectCom.dragImage2];
        [rangeFrame1 setOpacity:128];
        [rangeFrame2 setOpacity:0];
    }else {
        rangeFrame1 = [CCSprite spriteWithFile:selectCom.dragImage1];
        
        rangeFrame1.scaleX = drawSize.width / rangeFrame1.contentSize.width;
        rangeFrame1.scaleY = drawSize.height / rangeFrame1.contentSize.height;
        
        if (![mapLayer canExecuteMagicInThisArea:[mapLayer convertToNodeSpace:touchLocation]]) {
            rangeFrame2 = [CCSprite spriteWithFile:@"forbidden_sign.png"];
        }else {
            rangeFrame2 = [CCSprite spriteWithFile:selectCom.dragImage2];
        }
        
        [rangeFrame2 setOpacity:255];
        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:0];
        CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
        CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
        [rangeFrame2 runAction:repeat];
    }
    
    rangeFrame1.rotation = rotation;
    rangeFrame1.position = touchLocation;
    rangeFrame2.anchorPoint = ccp(0,0);
    [rangeFrame1 addChild:rangeFrame2];
    
    [statusLayer addChild:rangeFrame1 z:0 tag:kDrawPathRangeSprite];
    
}

-(void)removeStatusLayerChild {
    if ([statusLayer getChildByTag:kDrawPathRangeSprite]) {
        [statusLayer removeChildByTag:kDrawPathRangeSprite cleanup:YES];
    }
    if ([statusLayer getChildByTag:kDrawPathTag]) {
        [statusLayer removeChildByTag:kDrawPathTag cleanup:YES];
    }
}

@end
