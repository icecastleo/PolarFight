
#import "ColoredSquareSprite.h"

@interface ColoredSquareSprite (privateMethods)
- (void) updateContentSize;
- (void) updateColor;
@end


@implementation ColoredSquareSprite

@synthesize size=size_;
@synthesize blendFunc=blendFunc_;

+ (id) squareWithColor: (ccColor4B)color size:(CGSize)sz
{
	return [[self alloc] initWithColor:color size:sz];
}

- (id) initWithColor:(ccColor4B)color size:(CGSize)sz
{
	if( (self=[self init]) ) {
		self.size = sz;
		
		self.color = ccc3(color.r, color.g, color.b);
		self.opacity = color.a;
	}
	return self;
}

- (void) dealloc
{
	free(squareVertices_);
    [super dealloc];
}

- (id) init
{
	if((self = [super init])){
		size_				= CGSizeMake(10.0f, 10.0f);
		
			// default blend function
		blendFunc_ = (ccBlendFunc) { CC_BLEND_SRC, CC_BLEND_DST };
		
		self.color = ccc3(0U, 0U, 0U);
		self.opacity = 255U;
		
		squareVertices_ = (CGPoint*) malloc(sizeof(CGPoint)*(4));
		if(!squareVertices_){
			NSLog(@"Ack!! malloc in colored square failed");
			return nil;
		}
		memset(squareVertices_, 0, sizeof(CGPoint)*(4));
		
		self.size = size_;
	}
	return self;
}

- (void) setSize: (CGSize)sz
{
	size_ = sz;
	
    squareVertices_[0] = ccp(_position.x - size_.width,_position.y - size_.height);
    squareVertices_[1] = ccp(_position.x + size_.width,_position.y - size_.height);
    squareVertices_[2] = ccp(_position.x - size_.width,_position.y + size_.height);
    squareVertices_[3] = ccp(_position.x + size_.width,_position.y + size_.height);
	
	[self updateContentSize];
}

-(void) setContentSize: (CGSize)sz
{
	self.size = sz;
}

- (void) updateContentSize
{
	[super setContentSize:size_];
}

- (void)draw
{		
    ccDrawSolidPoly(squareVertices_, 4, ccc4f(self.color.r/255.0f, self.color.g/255.0f, self.color.b/255.0f, self.opacity/255.0f));
}

#pragma mark Touch

- (BOOL) containsPoint:(CGPoint)point
{
	return (CGRectContainsPoint([self boundingBox], point));
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %8@ | Tag = %i | Color = %02X%02X%02X%02X | Size = %f,%f>", [self class], self, _tag, self.color.r, self.color.g, self.color.b, self.opacity, size_.width, size_.height];
}

@end