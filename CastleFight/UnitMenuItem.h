//
//  UnitMenuItem.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/14.
//
//

#import "CCMenuItem.h"
#import "Character.h"

@interface UnitMenuItem : CCMenuItemImage {
    NSString *cId;
    int level;
    int cost;
    float cooldown;
    
    CCSprite *mask;
    CCProgressTimer *timer;
}

-(id)initWithCharacter:(Character *)character;
-(void)updateFood:(int)food;

@end
