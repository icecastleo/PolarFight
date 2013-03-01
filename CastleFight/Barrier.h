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
@interface Barrier : NSObject {
    
}
@property (readonly) CCSprite *sprite;

-(id)initWithFile:(NSString *)file radius:(float)radius;

@property (readonly) float radius;
@property CGPoint position;

@end
