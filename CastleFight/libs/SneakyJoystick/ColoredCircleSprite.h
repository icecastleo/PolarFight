#import "cocos2d.h"

@interface ColoredCircleSprite : CCNodeRGBA <CCBlendProtocol> {
	float		radius_;
	
	NSUInteger numberOfSegments;
    CGPoint *circleVertices_;
	
	ccBlendFunc	blendFunc_;
}

@property (nonatomic,readwrite) float radius;

/** BlendFunction. Conforms to CCBlendProtocol protocol */
@property (nonatomic,readwrite) ccBlendFunc blendFunc;

/** creates a Circle with color and radius */
+ (id) circleWithColor: (ccColor4B)color radius:(GLfloat)r;

/** initializes a Circle with color and radius */
- (id) initWithColor:(ccColor4B)color radius:(GLfloat)r;

- (BOOL) containsPoint:(CGPoint)point;

@end
