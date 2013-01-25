//
//  Barrier.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#define ROUND_SHAPE 1
#define SQUARE_SHAPE 2

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Barrier : CCSprite {
    int shapeType;
}

@property (readwrite, assign) float radius;
@property (readwrite, assign) CGPoint center;;
-(void) setShapeRoundRadius:(float)r center:(CGPoint)point;

@end
