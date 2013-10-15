//
//  RoundBattleStatusLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/6.
//
//

#import "RoundBattleStatusLayer.h"
#import "PauseLayer.h"
#import "CastleBloodSprite.h"
#import "ColoredSquareSprite.h"
#import "UnitMenuItem.h"
#import "FileManager.h"
#import "AchievementManager.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"
#import "RenderComponent.h"
#import "MagicSkillComponent.h"
#import "CostComponent.h"
#import "LevelComponent.h"

#import "RoundBattleController.h"
#import "ItemComponent.h"

@interface RoundBattleStatusLayer() {
    PlayerComponent *player;
}

@end

@implementation RoundBattleStatusLayer

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ingame.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
}

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        _timeLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", 0] fntFile:@"font/jungle_24_o.fnt"];
        _timeLabel.scale = 0.5;
        _timeLabel.position = ccp(winSize.width/2, winSize.height - _timeLabel.boundingBox.size.height);
        _timeLabel.color = ccWHITE;
        [self addChild:_timeLabel];
        
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

-(id)initWithBattleController:(RoundBattleController *)battleController {
    if ([self init]) {
        player = (PlayerComponent *)[battleController.userPlayer getComponentOfName:[PlayerComponent name]];
    }
    return self;
}

-(void)setMagicButton {
    MagicSkillComponent *magicSkillCom = (MagicSkillComponent *)[player.entity getComponentOfName:[MagicSkillComponent name]];
    
    for (Entity *entity in magicSkillCom.magicTeam) {
        RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        //FIXME: the position is not correct.
        renderCom.position = ccp(70+40*([magicSkillCom.magicTeam indexOfObject:entity]+1),30);
        [self addChild:renderCom.node];
        
        //FIXME: maybe do not need these or move to other appropriate place.
        CostComponent *costCom = (CostComponent *)[entity getComponentOfName:[CostComponent name]];
        NSString *costString;
        ccColor3B color;
        switch (costCom.type) {
            case kCostTypeFood:
                costString = [NSString stringWithFormat:@"%d",costCom.food];
                color = ccGOLD;
                break;
            case kCostTypeMana:
                costString = [NSString stringWithFormat:@"%d",costCom.mana];
                color = ccBLUEVIOLET;
                break;
            default:
                break;
        }
        NSAssert(costString != nil, @"this costType String does not be made yet.");
        CCLabelTTF *label = [CCLabelBMFont labelWithString:costString fntFile:@"WhiteFont.fnt"];
        label.color = color;
        label.position =  ccp(0, renderCom.sprite.boundingBox.size.height/2 + label.boundingBox.size.height);
        label.anchorPoint = CGPointMake(0.5, 1);
        [renderCom.node addChild:label z:0 tag:kCostLabelTag];
    }
}
-(void)setItemButton {
    NSArray *itemsInBattle = player.itemsInBattle;
    
    for (Entity *entity in itemsInBattle) {
        RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        //FIXME: the position is not correct.
        renderCom.position = ccp(240+40*([itemsInBattle indexOfObject:entity]+1),30);
        [self addChild:renderCom.node];
        
        //FIXME: maybe do not need these or move to other appropriate place.
        ItemComponent *itemCom = (ItemComponent *)[entity getComponentOfName:[ItemComponent name]];
        NSString *costString = [NSString stringWithFormat:@"%d",itemCom.count];
        ccColor3B color = ccGOLD;
        CCLabelTTF *label = [CCLabelBMFont labelWithString:costString fntFile:@"WhiteFont.fnt"];
        label.color = color;
        label.position =  ccp(0, renderCom.sprite.boundingBox.size.height/2 + label.boundingBox.size.height);
        label.anchorPoint = CGPointMake(0.5, 1);
        [renderCom.node addChild:label z:0 tag:kCountLabelTag];
    }
}

//-(void)update:(ccTime)delta {
//    playTime += delta;
//    
//    [timeLabel setString:[NSString stringWithFormat:@"%2d:%02d", (int)playTime/60, (int)playTime%60]];
//}

-(void)displayString:(NSString *)string withColor:(ccColor3B)color {
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCLabelTTF *label = [CCLabelBMFont labelWithString:string fntFile:@"WhiteFont.fnt"];
    label.color = color;
    label.position = ccp(size.width / 2, size.height / 2);
    [self addChild:label];
    
    [label runAction:[CCSequence actions:
                      [CCScaleTo actionWithDuration:0.1 scale:3.0],
                      [CCDelayTime actionWithDuration:0.9f],
                      [CCSpawn actions:
                       [CCScaleTo actionWithDuration:0.5f scale:0.1f],
                       [CCFadeOut actionWithDuration:0.5f],nil],
                      [CCCallFuncN actionWithTarget:self selector:@selector(removeSelf:)],
                      nil]];
}

-(void)removeSelf:(id)sender {
    CCNode *node = (CCNode *)sender;
    [node removeFromParentAndCleanup:YES];
}


@end
