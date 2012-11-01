//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "Character.h"
@implementation MapLayer

-(void) addCharacter:(Character*)character {    
    // Need to be done at map
    if(character.player == 1) {
        character.position = ccp(arc4random() % 200 + 21, arc4random() % 280 + 21);
    } else {
        character.position = ccp(arc4random() % 200 + 21 + 240, arc4random() % 280 + 21);
    }
    
    [self addChild:character.sprite];
}

-(void)removeCharacter:(Character *)character {
    
}

@end
