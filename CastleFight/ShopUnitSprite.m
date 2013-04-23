//
//  ShopUnitSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/11.
//
//

#import "ShopUnitSprite.h"
#import "Character.h"
#import "FileManager.h"

const static float hp_max = 2000.0;
const static float attack_max = 200.0;

@implementation ShopUnitSprite

@synthesize character;

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bt_char_%02d.png",[character.characterId intValue]]];
        sprite.anchorPoint = ccp(0, 0.5);
        sprite.position = ccp(18, self.boundingBox.size.height/2);
        [self addChild:sprite];
        
        CCSprite *pow = [CCSprite spriteWithSpriteFrameName:@"pow.png"];
        pow.anchorPoint = ccp(0, 0);
        pow.position = ccp(sprite.position.x + sprite.boundingBox.size.width + 2, 5);
        pow.scale = 0.5;
        [self addChild:pow];
        
        CCSprite *hp = [CCSprite spriteWithSpriteFrameName:@"hp.png"];
        hp.anchorPoint = ccp(0, 0);
        hp.position = ccp(pow.position.x, pow.position.y + pow.boundingBox.size.height + 3);
        hp.scale = 0.5;
        [self addChild:hp];
        
        lv = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"LV: %d/20",character.level] fntFile:@"font/jungle_24_o.fnt"];
        lv.anchorPoint = ccp(0, 0);
        lv.position = ccp(hp.position.x, hp.position.y + hp.boundingBox.size.height + 3);
        lv.scale = 0.5;
        [self addChild:lv];
        
        CCLabelTTF *name = [[CCLabelTTF alloc] initWithString:NSLocalizedString(@"TITLE", nil) fontName:@"Georgia-Bold"  fontSize:12];
        name.anchorPoint = ccp(0, 0);
        name.position = ccp(lv.position.x + lv.boundingBox.size.width + 5, lv.position.y);
        [self addChild:name];
        
        CCSprite *hp_bg = [CCSprite spriteWithSpriteFrameName:@"info_bar_bg.png"];
        hp_bg.anchorPoint = ccp(0, 0);
        hp_bg.position = ccp(85, hp.position.y);
        [self addChild:hp_bg];
        
        hp_bar = [CCSprite spriteWithSpriteFrameName:@"info_bar_hp.png"];
        hp_bar.anchorPoint = ccp(0, 0.5);
        hp_bar.position = ccp(1.5, hp.boundingBox.size.height/2);
        hp_bar.scaleX = [character getAttribute:kCharacterAttributeHp].value / hp_max;
        [hp_bg addChild:hp_bar];
        
        hp_font = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeHp].value] fntFile:@"font/cooper_20_o.fnt"];
        hp_font.anchorPoint = ccp(0, 0.5);
        hp_font.position = ccp(3, hp.boundingBox.size.height/2 + 3);
        hp_font.scale = 0.5;
        [hp_bg addChild:hp_font];
        
        CCSprite *pow_bg = [CCSprite spriteWithSpriteFrameName:@"info_bar_bg.png"];
        pow_bg.anchorPoint = ccp(0, 0);
        pow_bg.position = ccp(85, pow.position.y);
        [self addChild:pow_bg];
        
        pow_bar = [CCSprite spriteWithSpriteFrameName:@"info_bar_pow.png"];
        pow_bar.anchorPoint = ccp(0, 0.5);
        pow_bar.position = ccp(1.5, pow.boundingBox.size.height/2);
        pow_bar.scaleX = [character getAttribute:kCharacterAttributeAttack].value / attack_max;
        [pow_bg addChild:pow_bar];
        
        pow_font = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeAttack].value] fntFile:@"font/cooper_20_o.fnt"];
        pow_font.anchorPoint = ccp(0, 0.5);
        pow_font.position = ccp(3, pow.boundingBox.size.height/2 + 3);
        pow_font.scale = 0.5;
        [pow_bg addChild:pow_font];
        
        CCSprite *next = [CCSprite spriteWithSpriteFrameName:@"next_lv.png"];
        next.anchorPoint = ccp(0, 0.5);
        next.position = ccp(hp_bg.position.x + hp_bg.boundingBox.size.width + 3, (hp.position.y + pow.position.y + hp.boundingBox.size.height)/2);
        [self addChild:next];
        
        CCSprite *hp_next_bg = [CCSprite spriteWithSpriteFrameName:@"info_bar_bg.png"];
        hp_next_bg.anchorPoint = ccp(0, 0);
        hp_next_bg.position = ccp(next.position.x + next.boundingBox.size.width + 3, hp.position.y);
        [self addChild:hp_next_bg];
        
        hp_next_bar = [CCSprite spriteWithSpriteFrameName:@"info_bar_hp.png"];
        hp_next_bar.anchorPoint = ccp(0, 0.5);
        hp_next_bar.position = ccp(1.5, hp.boundingBox.size.height/2);
        hp_next_bar.scaleX = [[character getAttribute:kCharacterAttributeHp] valueWithLevel:character.level + 1] / hp_max;
        [hp_next_bg addChild:hp_next_bar];
        
        hp_next_font = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[[character getAttribute:kCharacterAttributeHp] valueWithLevel:character.level + 1]] fntFile:@"font/cooper_20_o.fnt"];
        hp_next_font.anchorPoint = ccp(0, 0.5);
        hp_next_font.position = ccp(3, hp.boundingBox.size.height/2 + 3);
        hp_next_font.scale = 0.5;
        [hp_next_bg addChild:hp_next_font];
        
        CCSprite *pow_next_bg = [CCSprite spriteWithSpriteFrameName:@"info_bar_bg.png"];
        pow_next_bg.anchorPoint = ccp(0, 0);
        pow_next_bg.position = ccp(hp_next_bg.position.x, pow.position.y);
        [self addChild:pow_next_bg];
        
        pow_next_bar = [CCSprite spriteWithSpriteFrameName:@"info_bar_pow.png"];
        pow_next_bar.anchorPoint = ccp(0, 0.5);
        pow_next_bar.position = ccp(1.5, pow.boundingBox.size.height/2);
        pow_next_bar.scaleX = [[character getAttribute:kCharacterAttributeAttack] valueWithLevel:character.level + 1] / attack_max;
        [pow_next_bg addChild:pow_next_bar];
        
        pow_next_font = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[[character getAttribute:kCharacterAttributeAttack] valueWithLevel:character.level + 1]] fntFile:@"font/cooper_20_o.fnt"];
        pow_next_font.anchorPoint = ccp(0, 0.5);
        pow_next_font.position = ccp(3, pow.boundingBox.size.height/2 + 3);
        pow_next_font.scale = 0.5;
        [pow_next_bg addChild:pow_next_font];
        
        upgrade = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_upgread_down.png"] disabledSprite:nil target:self selector:@selector(upgrade)];
        upgrade.anchorPoint = ccp(0, 0.5);
        upgrade.position = ccp(pow_next_bg.position.x + pow_next_bg.boundingBox.size.width + 25, next.position.y);
        upgrade.scaleX = 0.8;
        upgrade.scaleY = 0.6;
        
        menu = [[CCMenu alloc] init];
        menu.position = ccp(0, 0);
        [menu addChild:upgrade];
        [self addChild:menu];
        
        CCSprite *diamond = [CCSprite spriteWithSpriteFrameName:@"dia.png"];
        diamond.anchorPoint = ccp(0, 0);
        diamond.position = ccp(upgrade.position.x + upgrade.boundingBox.size.width/2 - diamond.boundingBox.size.width, upgrade.position.y + upgrade.boundingBox.size.height/2);
        diamond.scale = 0.75;
        [self addChild:diamond];
        
        diamond_font = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeUpdatePrice].value] fntFile:@"font/cooper_20_o.fnt"];
        diamond_font.anchorPoint = ccp(0, 0);
        diamond_font.position = ccp(diamond.position.x + diamond.boundingBox.size.width + 2, diamond.position.y);
        diamond_font.scale = 0.5;
        [self addChild:diamond_font];
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    // FIXME: We assume it is in a CCScissorLayer
    [menu setHandlerPriority:kCCMenuHandlerPriority+2];
}

-(void)upgrade {
    int upgradePrice = [character getAttribute:kCharacterAttributeUpdatePrice].value;
    
    if ([FileManager sharedFileManager].userMoney >= upgradePrice) {
        [FileManager sharedFileManager].userMoney -= upgradePrice;
        
        character.level += 1;
        [[FileManager sharedFileManager] updatePlayerCharacter:character];
        
        [self updateUnitSprite];
    }
}

-(void)updateUnitSprite {
    [lv setString:[NSString stringWithFormat:@"LV: %d/20",character.level]];
    
    hp_bar.scaleX = [character getAttribute:kCharacterAttributeHp].value / hp_max;
    [hp_font setString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeHp].value]];
    pow_bar.scaleX = [character getAttribute:kCharacterAttributeAttack].value / attack_max;
    [pow_font setString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeAttack].value]];
    
    hp_next_bar.scaleX = [[character getAttribute:kCharacterAttributeHp] valueWithLevel:character.level + 1] / hp_max;
    [hp_next_font setString:[NSString stringWithFormat:@"%d",[[character getAttribute:kCharacterAttributeHp] valueWithLevel:character.level + 1]]];
    pow_next_bar.scaleX = [[character getAttribute:kCharacterAttributeAttack] valueWithLevel:character.level + 1] / attack_max;
    [pow_next_font setString:[NSString stringWithFormat:@"%d",[[character getAttribute:kCharacterAttributeAttack] valueWithLevel:character.level + 1]]];
    
    // TODO: Set visible
//    upgrade;
    [diamond_font setString:[NSString stringWithFormat:@"%d",[character getAttribute:kCharacterAttributeUpdatePrice].value]];
}

@end