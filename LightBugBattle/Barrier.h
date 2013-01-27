//
//  Barrier.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

// TODO : Refactroing class & character to MapObject or ?
@interface Barrier : CCSprite {
    
}

-(id)initWithFile:(NSString *)file radius:(float)radius;

@property (readonly) float collisionRadius;
@property (readonly) CGPoint collisionPosition;

@end
