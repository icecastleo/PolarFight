#import "cocos2d.h"

@interface ColoredSquareSprite : CCNodeRGBA <CCBlendProtocol> {
	CGSize		size_;
	
	CGPoint		*squareVertices_;
	
	ccBlendFunc	blendFunc_;
}

@property (nonatomic,readwrite) CGSize size;

/** BlendFunction. Conforms to CCBlendProtocol protocol */
@property (nonatomic,readwrite) ccBlendFunc blendFunc;

/** creates a Square with color and size */
+ (id) squareWithColor: (ccColor4B)color size:(CGSize)sz;

/** initializes a Circle with color and radius */
- (id) initWithColor:(ccColor4B)color size:(CGSize)sz;

- (BOOL) containsPoint:(CGPoint)point;

@end
