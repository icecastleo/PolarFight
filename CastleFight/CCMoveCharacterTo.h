//
//  CCMapMoveTo.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/31.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
@interface CCMoveCharacterTo : CCActionInterval <NSCopying> {
    Character *character;
	CGPoint endPosition_;
	CGPoint delta_;
    
    ccTime elapse;
}

+(id) actionWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p;
-(id) initWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p;

@end
