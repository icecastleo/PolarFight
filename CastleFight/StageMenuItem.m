//
//  StageMenuItem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/30.
//
//

#import "StageMenuItem.h"
#import "BattleController.h"

@implementation StageMenuItem

-(id)initWithStagePrefix:(int)aPrefix suffix:(int)aSuffix {
    if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_up.png",aPrefix]]
                            selectedSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_down.png",aPrefix]]
                                                                disabledSprite:nil target:self selector:@selector(click:)]) {
        prefix = aPrefix;
        suffix = aSuffix;
        
        CCLabelBMFont *label = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d - %d", prefix, suffix] fntFile:@"font/jungle_24_o.fnt"];
        label.scale = 0.7;
        label.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2 - 10);
        [self addChild:label];
    }
    return self;
}
                
-(void)click:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[[BattleController alloc] initWithPrefix:prefix suffix:suffix]];
}

@end
