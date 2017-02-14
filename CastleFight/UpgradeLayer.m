//
//  StoreLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/18.
//
//

#import "UpgradeLayer.h"
#import "UpgradeUnits.h"

@interface UpgradeLayer() {
    CGRect childRect;
    CGPoint childPosition;
}
@end

@implementation UpgradeLayer

static int childTag = 333;

-(id)init {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (self = [super initWithRect:CGRectMake(winSize.width/8, 0, winSize.width/4*3, winSize.height)]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shopbutton.plist"];
        
        
        CCLabelTTF *titile = [CCLabelTTF labelWithString:@"Store" fontName:@"Symbol" fontSize:20];
        titile.position = ccp(self.frame.boundingBox.size.width/2, self.frame.boundingBox.size.height - titile.boundingBox.size.height);
        [self.frame addChild:titile];
        
        
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
        menu.position = ccp(unit.boundingBox.size.width/2, titile.position.y - titile.boundingBox.size.height - unit.boundingBox.size.height/2 * menu.children.count);
        [menu alignItemsVerticallyWithPadding:0];
        [menu setTouchPriority:kTouchPriorityMask-5];
        [self.frame addChild:menu];
        
        selectedMenuItem = unit;
        
        childRect = CGRectMake(winSize.width/8 + unit.boundingBox.size.width, 0, winSize.width/4*3 - unit.boundingBox.size.width, winSize.height - titile.boundingBox.size.height*2);
        childPosition = ccp(unit.boundingBox.size.width, titile.position.y - titile.boundingBox.size.height);
        
        UpgradeUnits *units = [[UpgradeUnits alloc] initWithRect:childRect];
        units.position = childPosition;
        [self.frame addChild:units z:0 tag:childTag];

    }
    return self;
}

-(void)click:(CCMenuItemSprite *)sender {
    if (sender != selectedMenuItem) {
        [self click:sender unclick:selectedMenuItem];
        selectedMenuItem = sender;
    }
}

-(void)click:(CCMenuItemSprite *)click unclick:(CCMenuItemSprite *)unclick {
    [self.frame removeChildByTag:childTag];
    
    switch (click.tag) {
        case 1: {
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_unit_off_down.png"];
            
            UpgradeUnits *units = [[UpgradeUnits alloc] initWithRect:childRect];
            units.position = childPosition;
            [self.frame addChild:units z:0 tag:childTag];
            
            break;
        }
        case 2: {
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_hero_off_down.png"];
            
            UpgradeUnits *units = [[UpgradeUnits alloc] initWithRect:childRect];
            units.position = childPosition;
            [self.frame addChild:units z:0 tag:childTag];
            
            break;
        }
        case 3: {
            click.normalImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_off_up.png"];
            click.selectedImage = [CCSprite spriteWithSpriteFrameName:@"bt_item_off_down.png"];
            
            UpgradeUnits *units = [[UpgradeUnits alloc] initWithRect:childRect];
            units.position = childPosition;
            [self.frame addChild:units z:0 tag:childTag];

            break;
        }
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
