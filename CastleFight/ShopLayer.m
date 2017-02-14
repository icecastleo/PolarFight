//
//  ShopLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/29.
//
//

#import "ShopLayer.h"
#import "CCScrollNode.h"
#import "ShopUnitLayer.h"

@implementation ShopLayer

-(id)init {
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg/shop/bg_shop_back.png"];
        background.anchorPoint = ccp(0.5, 0);
        background.position = ccp(winSize.width / 2, 0);
        [self addChild:background];
        
        CCMenuItemSprite *unit = [[CCMenuItemSprite alloc]
                                  initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_unit_off_up.png"]
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_unit_off_down.png"]
                                  disabledSprite:nil
                                  target:self selector:@selector(click:)];
        unit.tag = 1;
        
        CCMenuItemSprite *hero = [[CCMenuItemSprite alloc]
                                  initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_hero_on_up.png"]
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_hero_on_down.png"]
                                  disabledSprite:nil
                                  target:self selector:@selector(click:)];
        hero.tag = 2;
        
        CCMenuItemSprite *item = [[CCMenuItemSprite alloc]
                                  initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_item_on_up.png"]
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_item_on_down.png"]
                                  disabledSprite:nil
                                  target:self selector:@selector(click:)];
        item.tag = 3;

        CCMenu *menu = [CCMenu menuWithItems:unit, hero, item, nil];
        menu.position = ccp(winSize.width/2 - 240 + unit.boundingBox.size.width/2, winSize.height - 50 - unit.boundingBox.size.height/2 * menu.children.count);
        [menu alignItemsVerticallyWithPadding:0];
        
        // Because it is out from a scissor layer range!
        [menu setTouchPriority:kCCScissorLayerTouchPriority-1];
        [self addChild:menu];
        
        current = unit;
        
        ShopUnitLayer *unitLayer = [[ShopUnitLayer alloc] init];
        [self addChild:unitLayer];
    }
    return self;
}

-(void)click:(CCMenuItemSprite *)sender {
    if (sender != current) {
        [self setMenuItem:sender unclick:current];
        current = sender;
    }
}

-(void)setMenuItem:(CCMenuItemSprite *)click unclick:(CCMenuItemSprite *)unclick {
    switch (click.tag) {
        case 1:
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_off_down.png"];
            break;
        case 2:
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_off_down.png"];
            break;
        case 3:
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_off_down.png"];
            break;
    }
    
    switch (unclick.tag) {
        case 1:
            unclick.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_on_up.png"];
            unclick.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_on_down.png"];
            break;
        case 2:
            unclick.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_on_up.png"];
            unclick.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_on_down.png"];
            break;
        case 3:
            unclick.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_on_up.png"];
            unclick.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_on_down.png"];
            break;
    }
}

@end
