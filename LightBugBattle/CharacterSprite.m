//
//  CharacterSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Character.h"
#import "CharacterSprite.h"

@implementation CharacterSprite

-(id)initWithCharacter:(Character *)cha {
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

-(void) setAnimationWithName:(NSString*) name {
    
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

-(void) runDirectionAnimate {
    SpriteDirections direction = character.direction;
    
    [self stopAllActions];
    
    if(direction == directionUp) {
        [self runAction:upAction];
    } else if (direction == directionDown) {
        [self runAction:downAction];
    } else if (direction == directionLeft) {
        [self runAction:leftAction];
    } else if (direction == directionRight) {
        [self runAction:rightAction];
    }
}

-(void) updateBloodSprite {
    bloodSprite.scaleX = (float)character.hp/ character.maxHp;
    bloodSprite.position = ccp([self boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
}

@end
