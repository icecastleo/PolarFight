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
#import "PartyParser.h"
#import "CharacterBloodSprite.h"

@interface CharacterSprite() {
    float bloodScaleMultiplier;
    
    AKHelperObject *akHelper;
    
    NSArray *directionStrings;
    
}
@end


#define kAttackAnimation @"Attack"
#define kWalkingAnimation @"Walking"

@implementation CharacterSprite

-(id)initWithCharacter:(Character *)aCharacter {
    akHelper = [[AKHelperObject alloc] init];
    akHelper.objectDelegate = self;
    directionStrings = @[@"Up",@"Down",@"Left",@"Right"];
    
    if ([aCharacter.name isEqualToString:@"Swordsman"]) {
        // Load the texture atlas sprite frames; this also loads the Texture with the same name
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"Minotaur.plist"];
        
        if ((self = [super initWithSpriteFrameName:@"minotaur_walking_s001.png"])) {
            character = aCharacter;
            [self setAnimationWithName:character.name];
            [self addShadow];
        }
        return self;
    }
    
    if ([aCharacter.name isEqualToString:@"Tower"]) {

        if ((self = [super initWithSpriteFrameName:@"building_user_home_01.png"])) {
            character = aCharacter;
            [self addShadow];
        }

        return self;
    }
    
    // FIXME: replace player with direction.
    if(self = [super initWithFile:
               [NSString stringWithFormat:@"%@_%@2.gif",aCharacter.picFilename, aCharacter.player == 1 ? @"fr" : @"fr"]])
    {
        character = aCharacter;
        [self setAnimationWithName:character.picFilename];
        [self addShadow];
    }
    return self;
}

-(void)addShadow {
    CGRect sRect = CGRectMake(0, 0, self.boundingBox.size.width, self.boundingBox.size.height / kShadowHeightDivisor);
//    CGRect sRect = CGRectMake(0, 0, 360, 60);
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, sRect.size.width, sRect.size.height, 8, sRect.size.width * 4, imageColorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.6);
    
    CGContextFillEllipseInRect(context, sRect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CCSprite *shadow = [CCSprite spriteWithCGImage:imgRef key:nil];
    shadow.position = ccp(sRect.size.width / 2, sRect.size.height / 2);
    [self addChild:shadow z:-1];
}

-(void)addBloodSprite {
    bloodSprite = [[CharacterBloodSprite alloc] initWithCharacter:character];
}

-(void)addOuterBloodSprite:(BloodSprite *)sprite {
    outerBloodSprite = sprite;
}

-(void)removeBloodSprite {
    [bloodSprite removeFromParentAndCleanup:YES];
    bloodSprite = nil;
}

-(void)updateBloodSprite {
    [bloodSprite update];
    [outerBloodSprite update];
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
}

-(void)setAnimationWithName:(NSString*)name {
    
    if ([name isEqualToString:@"Swordsman"]) {
        NSAssert(akHelper != nil, @"akHelper should not be nil");
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
    
    rightAction = [[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:animation]];
}

-(void)runWalkAnimate {
    [self stopAllActions];
    
    CharacterDirection direction = character.characterDirection;
    
    // All character might use the applyAnimation method.
    if ([character.name isEqualToString:@"Swordsman"]) {
        
        NSString *directionString = [directionStrings objectAtIndex:direction - 1];
        NSString *animationKey = [NSString stringWithFormat:@"Animation_%@_Walking_%@.plist",character.name,directionString];
        
        NSDictionary *walkingClip = [PartyParser getAnimationDictionaryByName:animationKey];
        NSAssert(walkingClip != nil, @"walking animation should exist.");
        
        [akHelper applyAnimationClip:walkingClip toNode:self];
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
    bloodSprite.visible = NO;
    
    CharacterDirection direction = character.characterDirection;
    
    if(direction == kCharacterDirectionUp) {
        // TODO: Just delete me when there are attack animation.
        if (upAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:upAttackAction];
    } else if (direction == kCharacterDirectionDown) {
        // TODO: Just delete me when there are attack animation.
        if (downAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:downAttackAction];
    } else if (direction == kCharacterDirectionLeft) {
        // TODO: Just delete me when there are attack animation.
        if (leftAttackAction == nil) {
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:0.5],
                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
            return;
        }
        [self runAction:leftAttackAction];
    } else if (direction == kCharacterDirectionRight) {
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

-(void)runDamageAnimate {
    if (bloodSprite != nil) {
        [bloodSprite stopAllActions];
        [bloodSprite runAction:[CCSequence actions:[CCShow action],
                                [CCDelayTime actionWithDuration:2.0f],
                                [CCHide action],
                                nil]];
    }
}
 
-(void)runAnimationForName:(NSString *)animationName {
    [self stopAllActions];
    CharacterDirection direction = character.characterDirection;
    
    NSString *directionString = [directionStrings objectAtIndex:direction-1];
    NSString *animationKey = [NSString stringWithFormat:@"Animation_%@_%@_%@.plist",character.name,animationName,directionString];
    
    NSDictionary *animationClip = [PartyParser getAnimationDictionaryByName:animationKey];
    
//    NSAssert(animationClip != nil, @"Animation plist should exist.");
    
    // FIXME: For test only.
    if (animationClip == nil) {
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:1.0],
                         [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
        return;
    }
    
    [akHelper applyAnimationClip:animationClip toNode:self];
}

-(void)runDeadAnimate {
    [self stopAllActions];
    
    [bloodSprite removeFromParentAndCleanup:YES];
    
    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
    emitter.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
    emitter.positionType = kCCPositionTypeRelative;
    emitter.autoRemoveOnFinish = YES;
    [self addChild:emitter];

    [self runAction:[CCSequence actions:
                     [CCFadeOut actionWithDuration:1.0f],
                     [CCCallFunc actionWithTarget:character selector:@selector(deadAnimateCallback)],
                     nil]];
    
    [self releaseCharacterRetain];
}

-(void)releaseCharacterRetain {
    upAttackAction = nil;
    downAttackAction = nil;
    leftAttackAction = nil;
    rightAttackAction = nil;
    akHelper.objectDelegate = nil;
}

#pragma mark AKHelper Tag Delegate Method
- (void)animationClipOnNode:(CCNode*)node reachedTagWithName:(NSString*)tagName
{
    if ([tagName isEqualToString:@"upAttackAction"]) {
//        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"downAttackAction"]) {
//        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"leftAttackAction"]) {
//        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"rightAttackAction"]) {
//        [node runAction:[CCEaseOut actionWithAction:[CCMoveCharacterByLength actionWithDuration:0.4 character:character length:25] rate:2]];
    }else if ([tagName isEqualToString:@"upJumpAttackAction"]) {
        [self jumpAction];
    }else if ([tagName isEqualToString:@"downJumpAttackAction"]) {
        [self jumpAction];
    }else if ([tagName isEqualToString:@"leftJumpAttackAction"]) {
        [self jumpAction];
    }else if ([tagName isEqualToString:@"rightJumpAttackAction"]) {
        [self jumpAction];
    }else if ([tagName isEqualToString:@"setIdle"]) {
        [character attackAnimateCallback];
    }
}

-(void)jumpAction {
    CCJumpTo *jump1 = [CCJumpTo actionWithDuration:1 position:self.position height:self.boundingBox.size.height*.5 jumps:1];
    CCEaseIn *squeze1 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:1 scaleY:.8] rate:2];
    CCEaseOut *expand1 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:1 scaleY:1] rate:2];
    
    CCSequence *sequence = [CCSequence actions: jump1, squeze1, expand1, nil];
    
    [self runAction:sequence];
}

@end
