//
//  CharacterSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


#import "CharacterSprite.h"
#import "Character.h"

@implementation CharacterSprite

-(id)initWithCharacter:(Character *)cha {
    // FIXME: replace player with direction.
    if(self = [super initWithFile:
               [NSString stringWithFormat:@"%@_%@2.gif",cha.picFilename, cha.player == 1 ? @"rt" : @"lf"]])
    {
        character = cha;
        [self setAnimationWithName:character.picFilename];
    }
    return self;
}


-(void)addBloodSprite {
    bloodSprite = [CCSprite spriteWithFile:@"blood.png"];
    bloodSprite.position = ccp([self boundingBox].size.width / 2, -[bloodSprite boundingBox].size.height - 2);
    [self updateBloodSprite];
    [self addChild:bloodSprite];
}

-(void)removeBloodSprite {
    [bloodSprite removeFromParentAndCleanup:YES];
    bloodSprite = nil;
}

-(void)setAnimationWithName:(NSString*)name {
    
    CCAnimation *animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_bk1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_bk2.gif",name]];
    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.3;
    
    upAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:animation]];
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr2.gif",name]];
    
    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.3;
    
    downAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:animation]];
    
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_lf1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_lf2.gif",name]];
    
    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.3;
    
    leftAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:animation]];    
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_rt1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_rt2.gif",name]];
    
    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.3;
    
    rightAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:animation]];}

-(void)runDirectionAnimate {
    CharacterDirection direction = character.direction;
    
    [self stopAllActions];
    
    if(direction == kCharacterDirectionUp) {
        [self runAction:upAction];
    } else if (direction == kCharacterDirectionDown) {
        [self runAction:downAction];
    } else if (direction == kCharacterDirectionLeft) {
        [self runAction:leftAction];
    } else if (direction == kCharacterDirectionRight) {
        [self runAction:rightAction];
    }
}

-(void)updateBloodSprite {
    Attribute *hp = [character getAttribute:kCharacterAttributeHp];
    hp.delegate = self;
    NSAssert(hp != nil, @"Why you need a blood sprite on a character without hp?");
    
    bloodSprite.scaleX = (float) hp.currentValue / hp.value;
//    bloodSprite.scaleX = (float)character.currentHp/ character.maxHp;
    bloodSprite.position = ccp([self boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
}

-(void)bloodHint:(int)value IsCreased:(BOOL)increased {
    CCNode<CCLabelProtocol>* hpLbBM;
    
    NSString *valueString = [[NSString alloc] initWithFormat:@"%d", value];
    hpLbBM = [CCLabelBMFont labelWithString:valueString fntFile:@"TestFont.fnt"];
    
    hpLbBM.position =  ccp([self boundingBox].size.width / 2, [self boundingBox].size.height);
    hpLbBM.anchorPoint = CGPointMake(0.5, 1);
    [self addChild:hpLbBM z:1];
    
}

@end
