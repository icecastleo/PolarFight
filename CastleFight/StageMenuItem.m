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

-(id)initWithStagePrefix:(int)aPrefix suffix:(int)aSuffix unLocked:(BOOL)status stars:(int)stars {
    if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_up.png",aPrefix]]
                            selectedSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_down.png",aPrefix]]
                                                                disabledSprite:nil target:self selector:@selector(click:)]) {
        prefix = aPrefix;
        suffix = aSuffix;
        unLocked = status;
        
        CCNode *label;
        if (unLocked) {
            label = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d - %d", prefix, suffix] fntFile:@"font/jungle_24_o.fnt"];
        }else {
            label= [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        }
        label.scale = 0.7;
        label.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2 - 10);
        
        //FIXME: change to star images
        CCLabelBMFont *starLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d", stars] fntFile:@"font/jungle_24_o.fnt"];
        starLabel.scale = 0.4;
        starLabel.position = ccp(label.position.x,15);
        starLabel.color = ccRED;
        
        [self addChild:label];
//        [self addChild:starLabel];
    }
    return self;
}
                
-(void)click:(id)sender {
    if (unLocked) {
        [[CCDirector sharedDirector] replaceScene:[[BattleController alloc] initWithPrefix:prefix suffix:suffix]];
    }
}

@end
