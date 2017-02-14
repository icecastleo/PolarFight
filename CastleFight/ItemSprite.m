//
//  ItemSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/24.
//
//

#import "ItemSprite.h"

@implementation ItemSprite

-(id)init {
    if (self = [super initWithSize:CGSizeMake(360, 80)]) {
        
        CCSprite *pic = [CCSprite spriteWithFile:@"Hp_button.png"];
        pic.anchorPoint = ccp(0, 0.5);
        pic.position = ccp(20, self.boundingBox.size.height/2);
        [self addChild:pic];
        
        CCSprite *frame = [CCSprite spriteWithFile:@"Icon_frame.png"];
        frame.position = ccp(pic.boundingBox.size.width/2, pic.boundingBox.size.height/2);
        frame.scale = (pic.boundingBox.size.width + 3) / frame.boundingBox.size.width;
        [pic addChild:frame];
        
        CCLabelTTF *count = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%2d",3] fontName:@"Baskerville" fontSize:12];
        count.position = ccp(pic.boundingBox.size.width - 2, pic.boundingBox.size.height - 2);
        count.anchorPoint = ccp(1, 1);
        [pic addChild:count];
        
        CCLabelTTF *name = [CCLabelTTF labelWithString:@"道具的名字" fontName:@"Baskerville-Bold" fontSize:12];
        name.anchorPoint = ccp(0, 0);
        name.position = ccp(60, self.boundingBox.size.height-20);
        [self addChild:name];
        
        CCLabelTTF *own = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%2d/99",3] fontName:@"Baskerville" fontSize:12];
        own.anchorPoint = ccp(0, 0);
        own.position = ccp(150, self.boundingBox.size.height-20);
        [self addChild:own];
        
        CCLabelTTF *description = [CCLabelTTF labelWithString:@"這個道具的功能，這一行應該會超過到下一行！\n斷行測試" fontName:@"Baskerville" fontSize:12 dimensions:CGSizeMake(240, self.boundingBox.size.height-25) hAlignment:kCCTextAlignmentLeft];
        description.anchorPoint = ccp(0, 1);
        description.position = ccp(60, self.boundingBox.size.height-25);
        [self addChild:description];
        
        CCMenuItemSprite *buy = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_down.png"] disabledSprite:nil target:self selector:@selector(buy)];
        buy.anchorPoint = ccp(0, 0.5);
        buy.scale = 0.7;
        buy.position = ccp(300, self.boundingBox.size.height/2);
        
        CCMenu *menu = [[CCMenu alloc] init];
        menu.position = ccp(0, 0);
        [menu addChild:buy];
        [menu setTouchPriority:kCCScissorLayerTouchPriority+1];
        [self addChild:menu];
    }
    return self;
}

-(void)buy {
    // TODO: Buy logic
}

@end
