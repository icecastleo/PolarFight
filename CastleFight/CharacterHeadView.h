//
//  CharacterHeadView.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/17.
//
//

#import "cocos2d.h"

@class Character;

@interface CharacterHeadView : CCSprite

@property (nonatomic,readonly) Character *character;
-(id)initWithCharacter:(Character *)character;

@end
