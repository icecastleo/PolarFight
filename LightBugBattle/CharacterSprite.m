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

-(id)initWithCharacter:(Character *)aCharacter {
    if ([aCharacter.name isEqualToString:@"Swordsman"]) {
        
        // Load the texture atlas sprite frames; this also loads the Texture with the same name
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"vald_sword.plist"];
        
        if ((self = [super initWithSpriteFrameName:@"walking e0000.bmp"])) {
            character = aCharacter;
            
            upAction = [self animationWithName:@"n"];
            downAction = [self animationWithName:@"s"];
            rightAction = [self animationWithName:@"e"];
            leftAction = [self animationWithName:@"w"];
        }
        return self;
    }
    
    // FIXME: replace player with direction.
    if(self = [super initWithFile:
               [NSString stringWithFormat:@"%@_%@2.gif",aCharacter.picFilename, aCharacter.player == 1 ? @"rt" : @"fr"]])
    {
        character = aCharacter;
        [self setAnimationWithName:character.picFilename];
    }
    return self;
}


-(void)addBloodSprite {
    bloodSprite = [CCSprite spriteWithFile:
                   [NSString stringWithFormat:@"blood_%@.png",character.player == 1 ? @"green" : @"red"]];
    bloodSprite.position = ccp([self boundingBox].size.width / 2, -[bloodSprite boundingBox].size.height - 2);
    
    [self updateBloodSprite];
    [self addChild:bloodSprite];
    
    CCSprite *bloodFrame = [CCSprite spriteWithFile:@"blood_frame.png"];
    bloodFrame.position = bloodSprite.position;
    [self addChild:bloodFrame];
}

-(void)removeBloodSprite {
    [bloodSprite removeFromParentAndCleanup:YES];
    bloodSprite = nil;
}

-(CCAction *)animationWithName:(NSString*)name {
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    // Load the animation frames
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < 8; i++)
    {
        NSString* file = [NSString stringWithFormat:@"walking %@000%d.bmp",name, i];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    // Create an animation object from all the sprite animation frames
    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    
    // Run the animation by using the CCAnimate action
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    
    return repeat;
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
    
    NSAssert(hp != nil, @"Why you need a blood sprite on a character without hp?");
    
    bloodSprite.scaleX = (float) hp.currentValue / hp.value;
//    bloodSprite.scaleX = (float)character.currentHp/ character.maxHp;
    bloodSprite.position = ccp([self boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
}

@end
