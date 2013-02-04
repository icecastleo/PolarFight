//
//  CharacterSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


#import "CharacterSprite.h"
#import "Character.h"
#import "CCMoveCharacterByLength.h"
#import "AKHelperObject.h"
#import "SimpleAudioEngine.h"

@interface CharacterSprite() {
    float bloodScaleMultiplier;
    
    AKHelperObject *akHelper;
    
    NSDictionary *upDirectionClip;
    NSDictionary *downDirectionClip;
    NSDictionary *leftDirectionClip;
    NSDictionary *rightDirectionClip;
    
    NSDictionary *upAttackClip;
    NSDictionary *downAttackClip;
    NSDictionary *leftAttackClip;
    NSDictionary *rightAttackClip;
    
}
@end

@implementation CharacterSprite

-(id)initWithCharacter:(Character *)aCharacter {
    akHelper = [[AKHelperObject alloc] init];
    akHelper.objectDelegate = self;
    
    if ([aCharacter.name isEqualToString:@"Swordsman"]) {
        // Load the texture atlas sprite frames; this also loads the Texture with the same name
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"Minotaur.plist"];
        
        if ((self = [super initWithSpriteFrameName:@"minotaur_walking_s001.png"])) {
            character = aCharacter;
            [self setAnimationWithName:character.name];
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
    bloodSprite.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height + bloodSprite.boundingBox.size.height * 1.5);

    // blood sprite width -> character.radius * 2
    bloodScaleMultiplier = character.radius * 2 / bloodSprite.boundingBox.size.width;
    
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

-(void)updateBloodSprite {
    Attribute *hp = [character getAttribute:kCharacterAttributeHp];
    
    NSAssert(hp != nil, @"Why you need a blood sprite on a character without hp?");
    
    float scale = (float) hp.currentValue / hp.value;
    
    bloodSprite.scaleX = scale * bloodScaleMultiplier;
    bloodSprite.position = ccp(self.boundingBox.size.width / 2 - character.radius * (1 - scale), bloodSprite.position.y);
}

-(CCAnimate *)createAnimateWithName:(NSString*)name frameNumber:(int)anInteger {
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    // Load the animation frames
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 1; i <= anInteger; i++)
    {
        NSString* file = [NSString stringWithFormat:@"%@%03d.png",name, i];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    // Create an animation object from all the sprite animation frames
    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    animation.restoreOriginalFrame = YES;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    
    return animate;

//    
//    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//    
//    // Load the animation frames
//    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
//    
//    for (int i = 0; i < anInteger; i++)
//    {
//        NSString* file = [NSString stringWithFormat:@"%@%04d.bmp",name, i];
//        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
//        [frames addObject:frame];
//    }
//    // Create an animation object from all the sprite animation frames
//    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f];
//    animation.restoreOriginalFrame = YES;
//    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
//    
//    return animate;
}

-(void)setAnimationWithName:(NSString*)name {
    
    if ([name isEqualToString:@"Swordsman"]) {
        NSAssert(akHelper != nil, @"akHelper != nil");
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"swordsmanAttacking.wav"];
        upDirectionClip = [akHelper animationClipFromPlist:@"swordsman_Walking_Up_Animation.plist"];
        downDirectionClip = [akHelper animationClipFromPlist:@"swordsman_Walking_Down_Animation.plist"];
        leftDirectionClip = [akHelper animationClipFromPlist:@"swordsman_Walking_Left_Animation.plist"];
        rightDirectionClip = [akHelper animationClipFromPlist:@"swordsman_Walking_Right_Animation.plist"];
        upAttackClip = [akHelper animationClipFromPlist:@"swordsman_Attack_Up_Animation.plist"];
        downAttackClip = [akHelper animationClipFromPlist:@"swordsman_Attack_Down_Animation.plist"];
        leftAttackClip = [akHelper animationClipFromPlist:@"swordsman_Attack_Left_Animation.plist"];
        rightAttackClip = [akHelper animationClipFromPlist:@"swordsman_Attack_Right_Animation.plist"];
        return;
    }
    
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
    
    // All character might use the applyAnimation method.
    if ([character.name isEqualToString:@"Swordsman"]) {
        CharacterDirection direction = character.characterDirection;
        if(direction == kCharacterDirectionUp) {
            [akHelper applyAnimationClip:upDirectionClip toNode:self];
        } else if (direction == kCharacterDirectionDown) {
            [akHelper applyAnimationClip:downDirectionClip toNode:self];
        } else if (direction == kCharacterDirectionLeft) {
            [akHelper applyAnimationClip:leftDirectionClip toNode:self];
        } else if (direction == kCharacterDirectionRight) {
            [akHelper applyAnimationClip:rightDirectionClip toNode:self];
        }
        return;
    }
    
    // after test, these things will be deleted
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
        if ([character.name isEqualToString:@"Swordsman"]) {
            [akHelper applyAnimationClip:upAttackClip toNode:self];
            return;
        }
        // TODO: Just delete me when there are attack animation.
        if (upAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:upAttackAction];
    } else if (direction == kCharacterDirectionDown) {
        if ([character.name isEqualToString:@"Swordsman"]) {
            [akHelper applyAnimationClip:downAttackClip toNode:self];
            return;
        }
        // TODO: Just delete me when there are attack animation.
        if (downAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:downAttackAction];
    } else if (direction == kCharacterDirectionLeft) {
        if ([character.name isEqualToString:@"Swordsman"]) {
            [akHelper applyAnimationClip:leftAttackClip toNode:self];
            return;
        }
        // TODO: Just delete me when there are attack animation.
        if (leftAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:leftAttackAction];
    } else if (direction == kCharacterDirectionRight) {
        if ([character.name isEqualToString:@"Swordsman"]) {
            [akHelper applyAnimationClip:rightAttackClip toNode:self];
            return;
        }
        // TODO: Just delete me when there are attack animation.
        if (rightAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:rightAttackAction];
    }
}

-(void)runDeadAnimate {
    [self stopAllActions];
    
    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
    emitter.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
    emitter.positionType = kCCPositionTypeRelative;
    emitter.autoRemoveOnFinish = YES;
    [self addChild:emitter];

    [self runAction:[CCSequence actions:
                     [CCFadeOut actionWithDuration:1.0f],
                     [CCCallFunc actionWithTarget:self selector:@selector(deadAnimateCallback)]
                     ,nil]];
}

-(void)deadAnimateCallback {
    // TODO : Comment out after test.
    [self releaseCharacterRetain];
//    [self removeFromParentAndCleanup:YES];
}

-(void)releaseCharacterRetain {
    upAttackAction = nil;
    downAttackAction = nil;
    leftAttackAction = nil;
    rightAttackAction = nil;
}

#pragma mark AKHelper Tag Delegate Method
- (void)animationClipOnNode:(CCNode*)node reachedTagWithName:(NSString*)tagName
{
    if ([tagName isEqualToString:@"upAttackAction"]) {
        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"downAttackAction"]) {
        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"leftAttackAction"]) {
        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"rightAttackAction"]) {
        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"setIdle"]) {
        [character attackAnimateCallback];
    }
}

@end
