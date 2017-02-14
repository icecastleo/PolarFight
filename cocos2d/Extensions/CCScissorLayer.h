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

enum {
	//* priority used by the menu for the event handler
	kCCScissorLayerTouchPriority = kCCMenuHandlerPriority-10,
};

-(id)initWithRect:(CGRect)aRect;

@property BOOL verticalScissor;
@property BOOL horizontalScissor;

@end
