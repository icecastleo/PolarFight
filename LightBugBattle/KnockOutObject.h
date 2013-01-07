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

@interface KnockOutObject : NSObject {

}

@property (weak, readonly) Character* character;
@property (readonly) CGPoint velocity;
@property (readwrite) int count;

+(id)objectWithCharacter:(Character *)aCharacter velocity:(CGPoint)aVelocity;

@end
