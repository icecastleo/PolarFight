//
//  SharedMenuLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/10/17.
//
//

#import "cocos2d.h"

@interface SharedMenuLayer : CCLayerColor

-(id)initWithRect:(CGRect)aRect;
-(id)initWithRect:(CGRect)aRect maskPriotity:(int)aPriority;

@property (readonly) CCSprite *frame;

@end
