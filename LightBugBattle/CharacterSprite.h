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

@class Character;
@interface CharacterSprite : CCSprite {
    __weak Character *character;
    
    CCSprite *bloodSprite;
    
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
-(void)removeBloodSprite;
-(void)updateBloodSprite;

-(void)runDirectionAnimate;
-(void)runAttackAnimate;
-(void)runDeadAnimate;

@end
