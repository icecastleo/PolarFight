//
//  StroeUnitSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 2013/10/28.
//
//

#import "StoreUnitSprite.h"
#import "StoreUnitDetailSprite.h"

@implementation StoreUnitSprite

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SpriteSheets/penguin.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SpriteSheets/polar_bear.plist"];
}

-(id)init {
    if (self = [super initWithSize:CGSizeMake(360, 80)]) {
        
        CCSprite *pic = [CCSprite spriteWithSpriteFrameName:@"baby_penguin_0.png"];
        pic.anchorPoint = ccp(0, 0.5);
        pic.scale = 40 / MAX(pic.boundingBox.size.width, pic.boundingBox.size.height);
        pic.position = ccp(20, self.boundingBox.size.height/2);
        [self addChild:pic];
        
        CCLabelTTF *name = [CCLabelTTF labelWithString:@"角色的名字" fontName:@"Baskerville-Bold" fontSize:12];
        name.anchorPoint = ccp(0, 0);
        name.position = ccp(60, self.boundingBox.size.height-20);
        name.color = ccBLACK;
        [self addChild:name];
        
        CCLabelTTF *description = [CCLabelTTF labelWithString:@"這個角色的描述" fontName:@"Baskerville" fontSize:12 dimensions:CGSizeMake(240, self.boundingBox.size.height-25) hAlignment:kCCTextAlignmentLeft];
        description.anchorPoint = ccp(0, 1);
        description.position = ccp(60, self.boundingBox.size.height-25);
        [self addChild:description];
        
        CCMenuItemSprite *buy = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_down.png"] disabledSprite:nil target:self selector:@selector(buy)];
        buy.anchorPoint = ccp(0, 0.5);
        buy.scale = 0.7;
        buy.position = ccp(300, self.boundingBox.size.height/2);
        
        CCSprite *questionMark = [CCSprite spriteWithFile:@"question_mark.png"];
        questionMark.scale = 0.4;
        questionMark.anchorPoint = ccp(0, 1);
        questionMark.position = ccp(pic.position.x - questionMark.boundingBox.size.width/2, pic.position.y + pic.boundingBox.size.height/2 + questionMark.boundingBox.size.height/2);
        [self addChild:questionMark];
        
        NSArray *menus = [NSArray arrayWithObjects:buy, nil];
        
        CCMenu *menu = [[CCMenu alloc] initWithArray:menus];
        menu.position = ccp(0, 0);
        [menu setTouchPriority:kCCScissorLayerTouchPriority+1];
        [self addChild:menu];
        
        
        CCSprite *testSprite = [[CCSprite alloc] init];
        testSprite.contentSize = self.contentSize;
        
        CCMenuItemSprite *test = [[CCMenuItemSprite alloc] initWithNormalSprite:testSprite selectedSprite:nil disabledSprite:nil target:self selector:@selector(detail)];
        test.anchorPoint = ccp(0, 0);
        
        NSArray *testMenus = [NSArray arrayWithObjects:test, nil];
        
        CCMenu *testMenu = [[CCMenu alloc] initWithArray:testMenus];
        testMenu.position = ccp(0, 0);
        [testMenu setTouchPriority:kCCScissorLayerTouchPriority+2];
        [self addChild:testMenu];
    }
    
    return self;
}

-(void)buy {
    // TODO: Buy logic
}

-(void)detail {
    // TODO: Unit detail!
    [self.parent.parent.parent.parent addChild:[[StoreUnitDetailSprite alloc] init]];
}

@end
