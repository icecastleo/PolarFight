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

-(id)initWithCharacter:(Character *)character {
    if(self = [super initWithFile:
               [NSString stringWithFormat:@"%@_%@2.gif",character.name, character.player == 1 ? @"rt" : @"lf"]])
    {
        bloodSprite = [CCSprite spriteWithFile:@"blood.png"];
        bloodSprite.position = ccp([self boundingBox].size.width / 2, -[bloodSprite boundingBox].size.height - 2);
        [self setBloodSpriteWithCharacter:character];
        [self addChild:bloodSprite];

        [self setAnimationWithName:character.name];
    }
    return self;
}

-(void)dealloc {
    [bloodSprite release];
    [upAction release];
    [downAction release];
    [leftAction release];
    [rightAction release];
    [super dealloc];
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

-(void)setDirectionAnimate:(SpriteDirections)direction {
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

-(void) setBloodSpriteWithCharacter:(Character*)character {
    bloodSprite.scaleX = (float)character.hp/ character.maxHp;
    bloodSprite.position = ccp([self boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
}

@end
