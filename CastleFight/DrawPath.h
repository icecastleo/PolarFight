//
//  DrawMyTouch.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DrawPath : CCNode {
    CGPoint start;
    CGPoint end;
}

@property NSMutableArray *path;

@end
