//
//  MenuLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/15.
//
//

#import "MenuLayer.h"
#import "FightStageLayer.h"
#import "UpgradeLayer.h"
#import "StoreLayer.h"

@implementation MenuLayer

-(id)init {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCMenuItemFont *upgrade = [CCMenuItemFont itemWithString:@"Upgrade" block:^(id sender) {
           [self addChild:[[UpgradeLayer alloc] init]];
        }];
        upgrade.anchorPoint = ccp(0, 0);
        upgrade.position = ccp(winSize.width/2, 50);
        
        CCMenuItemFont *shop = [CCMenuItemFont itemWithString:@"Store" block:^(id sender) {
            [self addChild:[[StoreLayer alloc] init]];
        }];
        shop.anchorPoint = ccp(0, 0);
        shop.position = ccp(upgrade.position.x + upgrade.boundingBox.size.width+10, upgrade.position.y);
        
        CCMenuItemFont *fight = [CCMenuItemFont itemWithString:@"Fight" block:^(id sender) {
            [self addChild:[[FightStageLayer alloc] init]];
        }];
        fight.anchorPoint = ccp(0, 0);
        fight.position = ccp(shop.position.x + shop.boundingBox.size.width+10, shop.position.y);
        
        NSMutableArray *items = [NSMutableArray arrayWithObjects:upgrade, shop, fight, nil];
        
        CCMenu *menu = [[CCMenu alloc] initWithArray:items];
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}

@end
