//
//  CCBattleMoveBy.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/31.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
@interface CCMoveCharacterBy : CCActionInterval {
    Character *character;
    CGPoint delta_;
    
    ccTime elapse;
}

+(id) actionWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p;
-(id) initWithDuration:(ccTime)t character:(Character *)aCharacter position:(CGPoint)p;

@end
