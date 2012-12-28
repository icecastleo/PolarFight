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
@interface CharacterSprite : CCSprite <AttributeDelegate>{
    __weak Character *character;
    
    CCSprite *bloodSprite;
    
    CCAction *upAction;
    CCAction *downAction;
    CCAction *rightAction;
    CCAction *leftAction;
}

-(id) initWithCharacter:(Character *)character;

-(void) addBloodSprite;
-(void) removeBloodSprite;

-(void) runDirectionAnimate;
-(void) updateBloodSprite;

@end
