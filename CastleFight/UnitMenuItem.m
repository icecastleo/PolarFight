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

@implementation UnitMenuItem

-(id)initWithCharacter:(Character *)character {
    if (character == nil || character.level == 0) {
        if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_char_lock.png"]
                                selectedSprite:nil disabledSprite:nil target:nil selector:nil]) {
            
        }
        return self;
    }
    
    if (self = [super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_char_%02d.png",[character.characterId intValue]]]
                            selectedSprite:nil disabledSprite:nil target:self selector:@selector(click)]) {
        
        cId = character.characterId;
        level = character.level;
        cost = character.cost;
        [self setCooldown];
        
        CCLabelBMFont *costLabel = [[CCLabelBMFont alloc] initWithString:[[NSNumber numberWithInt:cost] stringValue] fntFile:@"font/cooper_20_o.fnt"];
        costLabel.anchorPoint = ccp(0.5, 0);
        costLabel.scale = 0.5;
        costLabel.position = ccp(self.boundingBox.size.width / 2, 0);
        costLabel.color = ccGOLD;
        [self addChild:costLabel];
        
        CCLabelBMFont *levelLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"Lv.%d",level] fntFile:@"font/cooper_20_o.fnt"];
        levelLabel.anchorPoint = ccp(0.5, 1);
        levelLabel.scale = 0.5;
        levelLabel.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height);
        [self addChild:levelLabel];
        
        mask = [CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"];
        mask.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
        mask.visible = NO;
        [self addChild:mask];
        
        timer = [[CCProgressTimer alloc] initWithSprite:[CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"]];
        timer.type = kCCProgressTimerTypeRadial;
        timer.reverseDirection = YES;
        timer.percentage = 0;
        timer.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
        [self addChild:timer];
        
        click = NO;
    }
    return self;
}

-(void)setCooldown {
    // Assume min cost of monster -> 15
    cooldown = 3.0 + (cost - 15) / 25.0 * 2;
}

-(void)click {
    click = YES;
    self.isEnabled = NO;
    mask.visible = YES;

    Character *temp = [[Character alloc] initWithId:cId andLevel:level];
    temp.player = 1;
    [[BattleController currentInstance] addCharacter:temp];
    
    [timer runAction:[CCSequence actions:[CCProgressFromTo actionWithDuration:cooldown from:100 to:0],
                      [CCCallFuncN actionWithTarget:self selector:@selector(clickCallback:)],
                      nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_unit_click.caf"];
}

-(void)clickCallback:(id)sender {
    click = NO;
}

-(void)updateFood:(int)food {
    if (click == NO) {
        if (food >= cost) {
            self.isEnabled = YES;
            mask.visible = NO;
        } else {
            self.isEnabled = NO;
            mask.visible = YES;
        }
    }
}

@end