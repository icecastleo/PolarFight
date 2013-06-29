
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
#import "CharacterInitData.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"
#import "RenderComponent.h"

@implementation BattleStatusLayer

-(id)initWithBattleController:(BattleController *)battleController {
    if(self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ingame.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        PlayerComponent *player = (PlayerComponent *)[battleController.userPlayer getComponentOfClass:[PlayerComponent class]];
        
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
        
        [self setUnitBoardWithPlayerComponent:player];
        [self setPauseButton];
        [self displayString:@"Start!!" withColor:ccWHITE];
    }
    return self;
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

-(void)setUnitBoardWithPlayerComponent:(PlayerComponent *)player {
    // TODO: Set by user data (plist?)
    
    CGSize winSize = [CCDirector sharedDirector].winSize;

    CCSprite *select = [CCSprite spriteWithSpriteFrameName:@"bg_unit_board.png"];
    select.anchorPoint = ccp(0.5, 0);
    select.position = ccp(winSize.width / 2, 0);
    [self addChild:select];
    
    unitItems = [[NSMutableArray alloc] init];
    
    for (SummonComponent *summon in player.summonComponents) {
        UnitMenuItem *item = [[UnitMenuItem alloc] initWithSummonComponent:summon];
        summon.menuItem = item;
        [unitItems addObject:item];
    }
    
    for (SummonComponent *summon in player.battleTeam) {
        // hero
        summon.summon = YES;
    }
    
    for (Entity *entity in player.magicTeam) {
        RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
        renderCom.position = ccp(150,250);
        [self addChild:renderCom.node];
    }
    
    // FIXME: Delete after test
    CCMenuItem *item = [[UnitMenuItem alloc] initWithSummonComponent:nil];
    [unitItems addObject:item];
    
    CCMenu *pauseMenu = [CCMenu menuWithArray:unitItems];
    pauseMenu.position = ccp(select.boundingBox.size.width / 2, select.boundingBox.size.height / 2);
    [pauseMenu alignItemsHorizontallyWithPadding:0];
    [select addChild:pauseMenu];
}

-(void)updateFood:(int)foodNumber {
    [food setString:[NSString stringWithFormat:@"%d", foodNumber]];
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
