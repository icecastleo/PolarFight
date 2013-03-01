//
//  CCMoveCharacterByLength.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
@interface CCMoveCharacterByLength : CCActionInterval {
    Character *character;
    float length;
    
    ccTime elapse;
}

+(id) actionWithDuration:(ccTime)t character:(Character *)aCharacter length:(float)aLength;
-(id) initWithDuration:(ccTime)t character:(Character *)aCharacter length:(float)aLength;

@end
