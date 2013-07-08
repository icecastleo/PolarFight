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
#import "PlayerComponent.h"
#import "TeamComponent.h"
#import "EntityFactory.h"
#import "Entity.h"
#import "PlayerSystem.h"

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
                                [self SummonExecute:summon];
                            }]) {
                                
                                CCLabelBMFont *costLabel = [[CCLabelBMFont alloc] initWithString:[[NSNumber numberWithInt:summon.cost] stringValue] fntFile:@"font/cooper_20_o.fnt"];
                                costLabel.anchorPoint = ccp(0.5, 0);
                                costLabel.scale = 0.5;
                                costLabel.position = ccp(self.boundingBox.size.width / 2, 0);
                                costLabel.color = ccGOLD;
                                //[self addChild:costLabel];
                                [self addChild:costLabel z:0 tag:1234];
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
                                [summon setWithMenuItem:self];
                            }
    return self;
}

-(void) updateLabelString:(NSString*)string{
    CCLabelBMFont* label= (CCLabelBMFont*)[self getChildByTag:1234];
    [label setString:string];
    
}

-(void) enableSummon{
    self.isEnabled = YES;
    self.mask.visible = NO;
}

-(void) disableSummon{
    self.isEnabled = NO;
    self.mask.visible = YES;
}

-(void) resetMask:(float)totalTime from:(float) from to:(float) to {
    [self.timer stopAllActions];
    [self.timer runAction:[CCProgressFromTo actionWithDuration:totalTime from:from to:to]];
    
}


-(void) SummonExecute:(SummonComponent*)summon
{
    summon.summon=YES;
}


@end
