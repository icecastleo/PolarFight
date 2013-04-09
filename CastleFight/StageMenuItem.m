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

-(id)initWithStagePrefix:(int)aPrefix suffix:(int)aSuffix unlocked:(BOOL)unlocked stars:(int)stars {
    if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_up.png",aPrefix]]
                            selectedSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_stage_%02d_down.png",aPrefix]]
                                                                disabledSprite:nil target:self selector:@selector(click:)]) {
        prefix = aPrefix;
        suffix = aSuffix;
        
        CCNode *label;
        
        if (unlocked) {
            label = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d - %d", prefix, suffix] fntFile:@"font/jungle_24_o.fnt"];
        } else {
            label = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
            self.isEnabled = NO;
        }
        
        label.scale = 0.7;
        label.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2 - 6);
        [self addChild:label];
        
        switch (stars) {
            case 1: {
                CCSprite *newStar1 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                newStar1.position = ccp(label.position.x,15);
                [self addChild:newStar1];
                break;
            }
            case 2: {
                CCSprite *newStar1 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                CCSprite *newStar2 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                newStar1.position = ccp(label.position.x-newStar1.boundingBox.size.width/2,15);
                newStar2.position = ccp(label.position.x+newStar1.boundingBox.size.width/2,15);
                [self addChild:newStar1];
                [self addChild:newStar2];
                break;
            }
            case 3: {
                CCSprite *newStar1 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                CCSprite *newStar2 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                CCSprite *newStar3 = [[CCSprite alloc] initWithFile:@"bg/ingame/star_small.png"];
                
                newStar1.position = ccp(label.position.x-newStar1.boundingBox.size.width,20);
                newStar2.position = ccp(label.position.x,15);
                newStar3.position = ccp(label.position.x+newStar1.boundingBox.size.width,20);
                [self addChild:newStar1];
                [self addChild:newStar2];
                [self addChild:newStar3];
                break;
            }
            default:
//                CCLOG(@"stars:%d",stars);
                break;
        }
    }
    return self;
}
                
-(void)click:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[[BattleController alloc] initWithPrefix:prefix suffix:suffix]];
}

@end
