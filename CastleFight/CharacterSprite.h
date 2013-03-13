//
//  CharacterSprite.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Attribute.h"
#import "BloodSprite.h"

@class Character;
@interface CharacterSprite : CCSprite {
    __weak Character *character;
    
    BloodSprite *bloodSprite;
    __weak BloodSprite *outerBloodSprite;
    
    CCAction *upAction;
    CCAction *downAction;
    CCAction *rightAction;
    CCAction *leftAction;
    
    CCAction *upAttackAction;
    CCAction *downAttackAction;
    CCAction *rightAttackAction;
    CCAction *leftAttackAction;
}

-(id)initWithCharacter:(Character *)aCharacter;

-(void)addBloodSprite;
-(void)addOuterBloodSprite:(BloodSprite *)sprite;
-(void)removeBloodSprite;
-(void)updateBloodSprite;

-(void)runWalkAnimate;
-(void)runAttackAnimate;
-(void)runDamageAnimate;
-(void)runDeadAnimate;

-(void)runAnimationForName:(NSString *)animationName;

@end
