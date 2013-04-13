//
//  CCScissorLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/3.
//
//

#import "cocos2d.h"

@interface CCScissorLayer : CCLayer {
    CGRect rect;
    CGRect pixelRect;
}

-(id)initWithRect:(CGRect)aRect;

@end
