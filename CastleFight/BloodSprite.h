//
//  BloodSprite.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "cocos2d.h"

@class Character;
@interface BloodSprite : CCProgressTimer {
    __weak Character *character;
}

-(id)initWithCharacter:(Character *)aCharacter sprite:(CCSprite *)sprite;
-(void)update;

@end
