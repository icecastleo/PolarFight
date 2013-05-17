//
//  BloodSprite.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/12.
//
//

#import "cocos2d.h"
#import "Entity.h"

@class DefenderComponent;

@interface BloodSprite : CCProgressTimer {
    DefenderComponent *defense;
}

-(id)initWithEntity:(Entity *)entity sprite:(CCSprite *)sprite;
-(void)update;

@end
