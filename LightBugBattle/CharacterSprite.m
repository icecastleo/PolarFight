//
//  CharacterSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


#import "CharacterSprite.h"
#import "Character.h"

@interface CharacterSprite() {
    float bloodScaleMultiplier;
}
@end

@implementation CharacterSprite

-(id)initWithCharacter:(Character *)aCharacter {
    if ([aCharacter.name isEqualToString:@"Swordsman"]) {
        
        // Load the texture atlas sprite frames; this also loads the Texture with the same name
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"vald_sword.plist"];
        
        if ((self = [super initWithSpriteFrameName:@"walking s0000.bmp"])) {
            character = aCharacter;
            
            upAction = [CCRepeatForever actionWithAction:[self createAnimateWithName:@"walking n" frameNumber:8]];
            downAction = [CCRepeatForever actionWithAction:[self createAnimateWithName:@"walking s" frameNumber:8]];
            rightAction = [CCRepeatForever actionWithAction:[self createAnimateWithName:@"walking e" frameNumber:8]];
            leftAction = [CCRepeatForever actionWithAction:[self createAnimateWithName:@"walking w" frameNumber:8]];
            
            upAttackAction = [CCSequence actions:[self createAnimateWithName:@"looking n" frameNumber:12],[CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)], nil];
            downAttackAction = [CCSequence actions:[self createAnimateWithName:@"looking s" frameNumber:12],[CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)], nil];
            rightAttackAction = [CCSequence actions:[self createAnimateWithName:@"looking e" frameNumber:12],[CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)], nil];
            leftAttackAction = [CCSequence actions:[self createAnimateWithName:@"looking w" frameNumber:12],[CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)], nil];
        }
        return self;
    }
    
    // FIXME: replace player with direction.
    if(self = [super initWithFile:
               [NSString stringWithFormat:@"%@_%@2.gif",aCharacter.picFilename, aCharacter.player == 1 ? @"fr" : @"fr"]])
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

    bloodScaleMultiplier = self.boundingBox.size.width / bloodSprite.boundingBox.size.width;
    
    [self updateBloodSprite];
    [self addChild:bloodSprite];
    
    CCSprite *bloodFrame = [CCSprite spriteWithFile:@"blood_frame.png"];
    bloodFrame.position = bloodSprite.position;
    bloodFrame.scaleX = bloodScaleMultiplier;
    [self addChild:bloodFrame];
}

-(void)removeBloodSprite {
    [bloodSprite removeFromParentAndCleanup:YES];
    bloodSprite = nil;
}

-(CCAnimate *)createAnimateWithName:(NSString*)name frameNumber:(int)anInteger{
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    // Load the animation frames
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < anInteger; i++)
    {
        NSString* file = [NSString stringWithFormat:@"%@%04d.bmp",name, i];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    // Create an animation object from all the sprite animation frames
    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    animation.restoreOriginalFrame = YES;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    
    return animate;
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
    [self stopAllActions];
    
    CharacterDirection direction = character.characterDirection;
    
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

-(void)runAttackAnimate {
    [self stopAllActions];
    
    CharacterDirection direction = character.characterDirection;
    
    if(direction == kCharacterDirectionUp) {
        // TODO: Just delete me when there are attack animation.
        if (upAttackAction == nil) {
            [self runAction:[CCSpawn actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:upAttackAction];
    } else if (direction == kCharacterDirectionDown) {
        // TODO: Just delete me when there are attack animation.
        if (downAttackAction == nil) {
            [self runAction:[CCSpawn actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:downAttackAction];
    } else if (direction == kCharacterDirectionLeft) {
        // TODO: Just delete me when there are attack animation.
        if (leftAttackAction == nil) {
            [self runAction:[CCSpawn actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:leftAttackAction];
    } else if (direction == kCharacterDirectionRight) {
        // TODO: Just delete me when there are attack animation.
        if (rightAttackAction == nil) {
            [self runAction:[CCSpawn actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:rightAttackAction];
    }
}

-(void)runDeadAnimate {
    [self stopAllActions];
    
//    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
//    emitter.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
//    emitter.positionType = kCCPositionTypeRelative;
//    emitter.autoRemoveOnFinish = YES;
//    [self addChild:emitter];

    [self runAction:[CCSequence actions:
                     [CCFadeOut actionWithDuration:1.0f],
                     [CCCallFunc actionWithTarget:self selector:@selector(deadAnimateCallback)]
                     ,nil]];
}

-(void)releaseCharacterRetain {
    upAttackAction = nil;
    downAttackAction = nil;
    leftAttackAction = nil;
    rightAttackAction = nil;
}

-(void)deadAnimateCallback {
    // TODO : Comment out after test.
    [self releaseCharacterRetain];
//    [self removeFromParentAndCleanup:YES];
}

-(void)updateBloodSprite {
    Attribute *hp = [character getAttribute:kCharacterAttributeHp];
    
    NSAssert(hp != nil, @"Why you need a blood sprite on a character without hp?");
    
    float scale = (float) hp.currentValue / hp.value;
    
    bloodSprite.scaleX = scale * bloodScaleMultiplier;
    bloodSprite.position = ccp(self.boundingBox.size.width / 2 * scale, bloodSprite.position.y);
}

@end
