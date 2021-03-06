
//  StatusLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleStatusLayer.h"
#import "PauseLayer.h"
#import "CastleBloodSprite.h"
#import "ColoredSquareSprite.h"
#import "UnitMenuItem.h"
#import "FileManager.h"
#import "AchievementManager.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"
#import "RenderComponent.h"
#import "CostComponent.h"
#import "LevelComponent.h"

@interface BattleStatusLayer() {
    PlayerComponent *player;
    PlayerComponent *enemyPlayer;
    
    float playTime;
    
    CCLabelBMFont *food;
    CCLabelBMFont *mana;
    CCLabelBMFont *enemyMana;
    
    CCLabelBMFont *timeLabel;
    NSMutableArray *unitItems;
}

@end

@implementation BattleStatusLayer

-(id)initWithBattleController:(BattleController *)battleController {
    if(self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ingame.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        
        player = (PlayerComponent *)[battleController.userPlayer getComponentOfName:[PlayerComponent name]];
        enemyPlayer = (PlayerComponent *)[battleController.enemyPlayer getComponentOfName:[PlayerComponent name]];
        
        playTime = 0;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *miniMap = [CCSprite spriteWithSpriteFrameName:@"bg_minimap.png"];
        miniMap.position = ccp(winSize.width / 2 + 25, winSize.height - miniMap.boundingBox.size.height / 2);
        [self addChild:miniMap];
        
        CCSprite *bloodBackground = [CCSprite spriteWithSpriteFrameName:@"bg_gauge.png"];
        bloodBackground.position = ccp(miniMap.position.x, miniMap.position.y - 20);
        [self addChild:bloodBackground];
        
        CastleBloodSprite *playerBlood = [[CastleBloodSprite alloc] initWithEntity:battleController.userCastle];
        playerBlood.position = ccp(miniMap.position.x - 91, bloodBackground.position.y);
        [self addChild:playerBlood];
        
        CastleBloodSprite *enemyBlood = [[CastleBloodSprite alloc] initWithEntity:battleController.enemyCastle];
        enemyBlood.position = ccp(miniMap.position.x + 91, bloodBackground.position.y);
        [self addChild:enemyBlood];

        CCSprite *bloodFrame = [CCSprite spriteWithSpriteFrameName:@"bg_gauge01.png"];
        bloodFrame.position = bloodBackground.position;
        [self addChild:bloodFrame];

//        timeLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%2d:%02d", (int)playTime/60, (int)playTime%60] fntFile:@"font/jungle_24_o.fnt"];
//        timeLabel.anchorPoint = ccp(0, 0.5);
//        timeLabel.scale = 0.5;
//        timeLabel.position = ccp(bloodBackground.position.x - timeLabel.boundingBox.size.width/2, bloodBackground.position.y);
//        timeLabel.position = ccp(winSize.width/2, winSize.height - timeLabel.boundingBox.size.height);
//        timeLabel.color = ccWHITE;
//        [self addChild:timeLabel];
        
        CCSprite *resource = [CCSprite spriteWithSpriteFrameName:@"bg_diafish.png"];
        resource.anchorPoint = ccp(0, 1);
        resource.position = ccp(0, winSize.height);
        [self addChild:resource];
        
        CCLabelBMFont *diamond = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[FileManager sharedFileManager].userMoney] fntFile:@"font/jungle_24_o.fnt"];
        diamond.anchorPoint = ccp(1, 0.5);
        diamond.scale = 0.5;
        diamond.position = ccp(resource.boundingBox.size.width - 10, winSize.height - resource.boundingBox.size.height / 4 - 1);
        [self addChild:diamond];
        
        food = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", (int)player.food] fntFile:@"font/jungle_24_o.fnt"];
        food.anchorPoint = ccp(1, 0.5);
        food.scale = 0.5;
        food.position = ccp(resource.boundingBox.size.width - 10, winSize.height - resource.boundingBox.size.height / 4 * 3 + 1);
        food.color = ccGOLD;
        [self addChild:food];

        
        
//        // player's mana
//        mana = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", (int)player.mana] fntFile:@"font/jungle_24_o.fnt"];
//        mana.anchorPoint = ccp(1, 0.5);
//        mana.scale = 0.5;
//        mana.position = ccp(winSize.width/4, timeLabel.position.y);
//        mana.color = ccBLUEVIOLET;
//        [self addChild:mana];
//        
//        // enemyPlayer's mana
//        enemyMana = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", (int)enemyPlayer.mana] fntFile:@"font/jungle_24_o.fnt"];
//        enemyMana.anchorPoint = ccp(1, 0.5);
//        enemyMana.scale = 0.5;
//        enemyMana.position = ccp(winSize.width*3/4, timeLabel.position.y);
//        enemyMana.color = ccBLUEVIOLET;
//        [self addChild:enemyMana];
        
        
        [self setUnitBoard];
        [self setPauseButton];
        [self displayString:@"Start!!" withColor:ccWHITE];
    }
    return self;
}

-(void)setUnitBoard {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *select = [CCSprite spriteWithSpriteFrameName:@"bg_unit_board.png"];
    select.anchorPoint = ccp(0.5, 0);
    select.position = ccp(winSize.width / 2, 0);
    [self addChild:select];
    
    for (Entity *entity in player.summonButtons) {
//        break;
        RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        CostComponent *costCom = (CostComponent *)[entity getComponentOfName:[CostComponent name]];
        LevelComponent *levelCom = (LevelComponent *)[entity getComponentOfName:[LevelComponent name]];
        
        //FIXME: the position is not correct.
        renderCom.position = ccp(25+renderCom.sprite.boundingBox.size.width*([player.summonButtons indexOfObject:entity]+1),select.boundingBox.size.height/2);
        [select addChild:renderCom.node];
        
        CCLabelBMFont *costLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",costCom.food] fntFile:@"font/cooper_20_o.fnt"];
        costLabel.anchorPoint = ccp(0.5, 1);
        costLabel.scale = 0.5;
        costLabel.position = ccp(0, 0 - costLabel.boundingBox.size.height);
        costLabel.color = ccGOLD;
        [renderCom.node addChild:costLabel z:0 tag:kCostLabelTag];
        
        CCLabelBMFont *levelLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"Lv.%d",levelCom.level] fntFile:@"font/cooper_20_o.fnt"];
        levelLabel.anchorPoint = ccp(0.5, 1);
        levelLabel.scale = 0.5;
        levelLabel.position = ccp(0, renderCom.sprite.boundingBox.size.height - costLabel.boundingBox.size.height);
        [renderCom.node addChild:levelLabel z:0 tag:kLevelLabelTag];
    }
    
//    for (Entity *entity in player.magicTeam) {
//        RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
//        //FIXME: the position is not correct.
//        renderCom.position = ccp(70+40*([player.magicTeam indexOfObject:entity]+1),265);
//        [self addChild:renderCom.node];
//        
//        //FIXME: maybe do not need these or move to other appropriate place.
//        CostComponent *costCom = (CostComponent *)[entity getComponentOfName:[CostComponent name]];
//        NSString *costString;
//        ccColor3B color;
//        switch (costCom.type) {
//            case kCostTypeFood:
//                costString = [NSString stringWithFormat:@"%d",costCom.food];
//                color = ccGOLD;
//                break;
//            case kCostTypeMana:
//                costString = [NSString stringWithFormat:@"%d",costCom.mana];
//                color = ccBLUEVIOLET;
//                break;
//            default:
//                break;
//        }
//        NSAssert(costString != nil, @"this costType String does not be made yet.");
//        CCLabelTTF *label = [CCLabelBMFont labelWithString:costString fntFile:@"WhiteFont.fnt"];
//        label.color = color;
//        label.position =  ccp(0, renderCom.sprite.boundingBox.size.height/2 + label.boundingBox.size.height);
//        label.anchorPoint = CGPointMake(0.5, 1);
//        [renderCom.node addChild:label z:0 tag:kCostLabelTag];
//    }
}

-(void)setPauseButton {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                 itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_option_01_up.png"]
                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_option_01_down.png"]
                                 target:self selector:@selector(pauseButtonTapped:)];
    
    float width = winSize.width - pauseMenuItem.boundingBox.size.width/2;
    float height = winSize.height - pauseMenuItem.boundingBox.size.height/2;
    pauseMenuItem.position = ccp(width, height);
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
    pauseMenu.position = CGPointZero;
    [self addChild:pauseMenu];
}

-(void)pauseButtonTapped:(id)sender {
    [self addChild:[PauseLayer node]];
}

-(void)update:(ccTime)delta {
    playTime += delta;
    
    [timeLabel setString:[NSString stringWithFormat:@"%2d:%02d", (int)playTime/60, (int)playTime%60]];
    
    [food setString:[NSString stringWithFormat:@"%d", (int)player.food]];
//    [mana setString:[NSString stringWithFormat:@"%d", (int)player.mana]];
//    [enemyMana setString:[NSString stringWithFormat:@"%d", (int)enemyPlayer.mana]];
}

-(void)displayString:(NSString *)string withColor:(ccColor3B)color {
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCLabelTTF *label = [CCLabelBMFont labelWithString:string fntFile:@"WhiteFont.fnt"];
    label.color = color;
    label.position = ccp(size.width / 2, size.height / 2);
    [self addChild:label];
    
    [label runAction:[CCSequence actions:
                      [CCScaleTo actionWithDuration:0.1 scale:3.0],
                      [CCDelayTime actionWithDuration:1.0f],
                      [CCSpawn actions:
                       [CCScaleTo actionWithDuration:0.5f scale:0.1f],
                       [CCFadeOut actionWithDuration:0.5f],nil],
                      [CCCallFuncN actionWithTarget:self  selector:@selector(removeSelf:)],
                      nil]];
}

-(void)removeSelf:(id)sender {
    CCNode *node = (CCNode *)sender;
    [node removeFromParentAndCleanup:YES];
}

@end
