//
//  UnitMenuItem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/14.
//
//

#import "UnitMenuItem.h"
#import "BattleController.h"
#import "SimpleAudioEngine.h"
#import "FileManager.h"
#import "SummonComponent.h"

@implementation UnitMenuItem

-(id)initWithSummonComponent:(SummonComponent *)summon {
    if (summon == nil || summon.data.level == 0) {
        if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_char_lock.png"]
                                selectedSprite:nil disabledSprite:nil target:nil selector:nil]) {
            
        }
        return self;
    }
    
    if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_char_%02d.png",[summon.data.cid intValue]]]
                            selectedSprite:nil disabledSprite:nil block:^(id sender) {
                                summon.summon = YES;
                            }]) {
        
        CCLabelBMFont *costLabel = [[CCLabelBMFont alloc] initWithString:[[NSNumber numberWithInt:summon.cost] stringValue] fntFile:@"font/cooper_20_o.fnt"];
        costLabel.anchorPoint = ccp(0.5, 0);
        costLabel.scale = 0.5;
        costLabel.position = ccp(self.boundingBox.size.width / 2, 0);
        costLabel.color = ccGOLD;
        [self addChild:costLabel];
        
        CCLabelBMFont *levelLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"Lv.%d",summon.data.level] fntFile:@"font/cooper_20_o.fnt"];
        levelLabel.anchorPoint = ccp(0.5, 1);
        levelLabel.scale = 0.5;
        levelLabel.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height);
        [self addChild:levelLabel];
        
        _mask = [CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"];
        _mask.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
        _mask.visible = YES;
        [self addChild:_mask];
        
        _timer = [[CCProgressTimer alloc] initWithSprite:[CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"]];
        _timer.type = kCCProgressTimerTypeRadial;
        _timer.reverseDirection = YES;
        _timer.percentage = 0;
        _timer.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
        [self addChild:_timer];
                                
        self.isEnabled = NO;
    }
    return self;
}

@end
