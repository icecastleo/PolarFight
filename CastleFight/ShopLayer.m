//
//  ShopLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/29.
//
//

#import "ShopLayer.h"
#import "CCScrollNode.h"
#import "CCScissorLayer.h"

@implementation ShopLayer

-(id)init {
    if (self = [super init]) {
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
        menu.position = ccp(winSize.width / 2 - 240 + unit.boundingBox.size.width / 2, winSize.height - 50 - unit.boundingBox.size.height * menu.children.count / 2);
        [menu alignItemsVerticallyWithPadding:0];
        [self addChild:menu];
        
        current = unit;

        CGPoint origin = ccp(winSize.width / 2 - 240 + 75, 0);
        CGRect rect = CGRectMake(origin.x, origin.y, 405, winSize.height - 50);
        
        CCScrollNode *scrollingNode = [[CCScrollNode alloc] initWithRect:rect];
        scrollingNode.adjustPosition = YES;
        
        CCScrollView *scrollView = scrollingNode.scrollView;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.bounces = NO;
        scrollView.tag = noDisableVerticalScrollTag;
        
        CCScissorLayer *layer = [[CCScissorLayer alloc] initWithRect:rect];
        [layer addChild:scrollingNode];
        
        [self addChild:layer];

        for(NSInteger i = 0; i <= 50; i++) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", i]
                                                   fontName:@"Marker Felt"
                                                   fontSize:64];
            label.anchorPoint = ccp(0.5, 1.0);
            label.position = ccp(winSize.width * 0.5, winSize.height + i * -75);
            [scrollingNode addChild:label];
        }
        
        CCNode *lastNode = [scrollingNode.children lastObject];
        //        CGSize contentSize = CGSizeMake(lastNode.contentSize.width, winSize.height - 120 - lastNode.position.y + lastNode.contentSize.height);
        CGSize contentSize = CGSizeMake(lastNode.contentSize.width, 51 * 75);
        scrollingNode.scrollView.contentSize = contentSize;
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
