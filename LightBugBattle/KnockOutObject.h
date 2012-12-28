//
//  KnockOutObject.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"

@interface KnockOutObject : CCNode {
    
}

@property (readwrite, assign) Character* character;
@property (readwrite, assign) CGPoint velocity;
@property (readwrite, assign) int decreaseCount;

-(void) setChar:(Character*) theCharacter vel:(CGPoint)theVelocity;

@end
