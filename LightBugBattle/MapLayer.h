//
//  MapLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
@interface MapLayer : CCLayer {
//    NSMutableArray *characters;
}

-(void) addCharacter:(Character*)character;
-(void) removeCharacter:(Character*)character;

@end
