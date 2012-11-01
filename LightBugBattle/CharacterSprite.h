//
//  CharacterSprite.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
@interface CharacterSprite : CCSprite {
    CCSprite *bloodSprite;
    
    CCAction *upAction;
    CCAction *downAction;
    CCAction *rightAction;
    CCAction *leftAction;
}

-(id) initWithCharacter:(Character *)character;

-(void) setDirectionAnimate:(SpriteDirections)direction;
-(void) setBloodSpriteWithCharacter:(Character*)character;

@end
