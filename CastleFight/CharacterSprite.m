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
#import "FileManager.h"
#import "CharacterBloodSprite.h"

@interface CharacterSprite() {
    AKHelperObject *akHelper;
}
@end

#define kAttackAnimation @"Attack"
#define kWalkingAnimation @"Walking"

@implementation CharacterSprite

static const NSArray *directionStrings;

+(void)initialize {
    directionStrings = @[@"Up",@"Down",@"Left",@"Right"];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"user.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hero.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"building.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"combat.plist"];
}

-(id)initWithCharacter:(Character *)aCharacter {
    akHelper = [[AKHelperObject alloc] init];
    akHelper.objectDelegate = self;
    
//    if ([aCharacter.name isEqualToString:@"Swordsman"]) {
//        // Load the texture atlas sprite frames; this also loads the Texture with the same name
//        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [frameCache addSpriteFramesWithFile:@"Minotaur.plist"];
//        
//        if ((self = [super initWithSpriteFrameName:@"minotaur_walking_s001.png"])) {
//            character = aCharacter;
//            [self setAnimationWithName:character.name];
//            [self addShadow];
//        }
//        return self;
//    }
    
    if ([aCharacter.name isEqualToString:@"Tower"]) {

        if ((self = [super initWithSpriteFrameName:@"building_user_home_01.png"])) {
            character = aCharacter;
            [self addShadow];
        }

        return self;
    }
    //test
    if ([aCharacter.name isEqualToString:@"Tower2"]) {
        
        if ((self = [super initWithSpriteFrameName:@"building_enemy_home.png"])) {
            character = aCharacter;
            [self addShadow];
        }
        
        return self;
    }
    
    // TODO: Seperate user, enemy, hero
    if (self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"user_%02d_move_01.png", [aCharacter.characterId intValue]]]) {
        character = aCharacter;
        actions = [[NSMutableDictionary alloc] init];
        
        if (character.player == 2) {
            self.flipX = YES;
        }
        
        [self addShadow];
        [self setAnimation];
    }
    return self;
}

-(void)addShadow {
    CGRect sRect = CGRectMake(0, 0, self.boundingBox.size.width, self.boundingBox.size.height / kShadowHeightDivisor);
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, sRect.size.width, sRect.size.height, 8, sRect.size.width * 4, imageColorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 0.6);
    
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

-(void)setAnimation {
    
    CCAnimation *animation = [CCAnimation animation];
    
    for (int i = 1; i <= 4; i++) {
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"user_%02d_attack_%02d.png", [character.characterId intValue], i]]];
    }

    animation.restoreOriginalFrame = YES;
    animation.delayPerUnit = 0.1;
    
    [actions setObject:[CCAnimate actionWithAnimation:animation] forKey:@"attack"];
    
    animation = [CCAnimation animation];
    
    for (int i = 1; i <= 2; i++) {
        [animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"user_%02d_move_%02d.png", [character.characterId intValue], i]]];
    }
    
    animation.delayPerUnit = 0.2;
    
    [actions setObject:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] forKey:@"move"];
    
}

-(void)runWalkAnimate {
    [self stopAllActions];
    
    [self runAction:[actions objectForKey:@"move"]];
    
//    CharacterDirection direction = character.characterDirection;
//
//    // All character might use the applyAnimation method.
//    if ([character.name isEqualToString:@"Swordsman"]) {
//        
//        NSString *directionString = [directionStrings objectAtIndex:direction - 1];
//        NSString *animationKey = [NSString stringWithFormat:@"Animation_%@_Walking_%@.plist",character.name,directionString];
//        
//        NSDictionary *walkingClip = [FileManager getAnimationDictionaryByName:animationKey];
//        NSAssert(walkingClip != nil, @"walking animation should exist.");
//        
//        [akHelper applyAnimationClip:walkingClip toNode:self];
//        return;
//    }
//    
//    // after test, these things will be deleted
//    if(direction == kCharacterDirectionUp) {
//        [self runAction:upAction];
//    } else if (direction == kCharacterDirectionDown) {
//        [self runAction:downAction];
//    } else if (direction == kCharacterDirectionLeft) {
//        [self runAction:leftAction];
//    } else if (direction == kCharacterDirectionRight) {
//        [self runAction:rightAction];
//    }
}

-(void)runAttackAnimate {
    [self stopAllActions];

    [self runAction:[actions objectForKey:@"attack"]];
    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:1.0],
                     [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];

//    CharacterDirection direction = character.characterDirection;
//
//    if(direction == kCharacterDirectionUp) {
//        // TODO: Just delete me when there are attack animation.
//        if (upAttackAction == nil) {
//            [self runAction:[CCSequence actions:
//                             [CCDelayTime actionWithDuration:0.5],
//                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
//            return;
//        }
//        [self runAction:upAttackAction];
//    } else if (direction == kCharacterDirectionDown) {
//        // TODO: Just delete me when there are attack animation.
//        if (downAttackAction == nil) {
//            [self runAction:[CCSequence actions:
//                             [CCDelayTime actionWithDuration:0.5],
//                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
//            return;
//        }
//        [self runAction:downAttackAction];
//    } else if (direction == kCharacterDirectionLeft) {
//        // TODO: Just delete me when there are attack animation.
//        if (leftAttackAction == nil) {
//            [self runAction:[CCSequence actions:
//                             [CCDelayTime actionWithDuration:0.5],
//                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
//            return;
//        }
//        [self runAction:leftAttackAction];
//    } else if (direction == kCharacterDirectionRight) {
//        // TODO: Just delete me when there are attack animation.
//        if (rightAttackAction == nil) {
//            [self runAction:[CCSequence actions:
//                             [CCDelayTime actionWithDuration:0.5],
//                             [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
//            return;
//        }
//        [self runAction:rightAttackAction];
//    }
}

-(void)runDamageAnimate:(Damage *)damage {
    if (damage.value > 0) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"hit_01.png"];
        
        if (damage.source == kDamageSourceRanged) {
            sprite.position = [self convertToNodeSpace:[self.parent convertToWorldSpace:damage.position]];
        } else {
            sprite.position = ccp(self.boundingBox.size.width / 2, self.boundingBox.size.height / 2);
        }
        
        CCAction *action = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f],[CCCallFuncN actionWithTarget:self selector:@selector(removeSelf:)], nil];
        [sprite runAction:action];
        
        [self addChild:sprite];
    }
    
    if (bloodSprite != nil) {
        [bloodSprite stopAllActions];
        [bloodSprite runAction:[CCSequence actions:[CCShow action],
                                [CCDelayTime actionWithDuration:2.0f],
                                [CCHide action],
                                nil]];
    }
}

-(void)removeSelf:(id)sender {
    CCNode *node = (CCNode *)sender;
    [node removeFromParentAndCleanup:YES];
}
 
-(void)runAnimationForName:(NSString *)animationName {
    [self runAttackAnimate];
    
//    [self stopAllActions];
//    CharacterDirection direction = character.characterDirection;
//    
//    NSString *directionString = [directionStrings objectAtIndex:direction-1];
//    NSString *animationKey = [NSString stringWithFormat:@"Animation_%@_%@_%@.plist",character.name,animationName,directionString];
//    
//    NSDictionary *animationClip = [FileManager getAnimationDictionaryByName:animationKey];
//    
////    NSAssert(animationClip != nil, @"Animation plist should exist.");
//    
//    // FIXME: For test only.
//    if (animationClip == nil) {
//        [self runAction:[CCSequence actions:
//                         [CCDelayTime actionWithDuration:1.0],
//                         [CCCallFunc actionWithTarget:character selector:@selector(attackAnimateCallback)],nil]];
//        return;
//    }
//    
//    [akHelper applyAnimationClip:animationClip toNode:self];
}

-(void)runDeadAnimate {
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    
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
