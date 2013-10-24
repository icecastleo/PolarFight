//
//  SharedFrameSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/15.
//
//

#import "SharedFrameSprite.h"

@implementation SharedFrameSprite

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super init]) {
        
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"etc.pvr.ccz"];
        [self addChild:batchNode];

        CCSprite *lb = [CCSprite spriteWithSpriteFrameName:@"shop_cell_lb.png"];
        lb.anchorPoint = ccp(0, 0);
        lb.position = ccp(-1, -1);
        [batchNode addChild:lb];
        
        CCSprite *lt = [CCSprite spriteWithSpriteFrameName:@"shop_cell_lt.png"];
        lt.anchorPoint = ccp(0, 1);
        lt.position = ccp(-1, size.height+1);
        [batchNode addChild:lt];
        
        CCSprite *rb = [CCSprite spriteWithSpriteFrameName:@"shop_cell_rb.png"];
        rb.anchorPoint = ccp(1, 0);
        rb.position = ccp(size.width+1, -1);
        [batchNode addChild:rb];
        
        CCSprite *rt = [CCSprite spriteWithSpriteFrameName:@"shop_cell_rt.png"];
        rt.anchorPoint = ccp(1, 1);
        rt.position = ccp(size.width+1, size.height+1);
        [batchNode addChild:rt];
        
        int width = lb.boundingBox.size.width;
        int height = lb.boundingBox.size.height;
        
        int maxWidth = size.width - rt.boundingBox.size.width+2;
        int maxHeight = size.height - rt.boundingBox.size.height+2;
        
        while (width < maxWidth) {
            CCSprite *t = [CCSprite spriteWithSpriteFrameName:@"shop_cell_t.png"];
            
            width += t.boundingBox.size.width;
            width = MIN(width, maxWidth);
            
            t.anchorPoint = ccp(1, 1);
            t.position = ccp(width, lt.position.y);
            [batchNode addChild:t];
            
            CCSprite *b = [CCSprite spriteWithSpriteFrameName:@"shop_cell_b.png"];
            b.anchorPoint = ccp(1, 0);
            b.position = ccp(width, lb.position.y);
            [batchNode addChild:b];
        }
        
        while (height < maxHeight) {
            CCSprite *l = [CCSprite spriteWithSpriteFrameName:@"shop_cell_l.png"];
            
            height += l.boundingBox.size.height;
            height = MIN(height, maxHeight);
            
            l.anchorPoint = ccp(0, 1);
            l.position = ccp(lb.position.x, height);
            [batchNode addChild:l];
            
            CCSprite *r = [CCSprite spriteWithSpriteFrameName:@"shop_cell_r.png"];
            r.anchorPoint = ccp(1, 1);
            r.position = ccp(rb.position.x, height);
            [batchNode addChild:r];
        }
        
        self.contentSize = size;
        
        CCSprite *background = [self backgroundWithSize:CGSizeMake(self.contentSize.width - 10, self.contentSize.height - 10) color:ccc4FFromccc3B(ccLIGHTSALMON)];
        background.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
        [self addChild:background z:-1];
    }
    return self;
}

-(CCSprite *)backgroundWithSize:(CGSize)size color:(ccColor4F)color {
    
    // Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
    
    // Call CCRenderTexture:begin
    [rt beginWithClear:color.r g:color.g b:color.b a:color.a];
    
    // 3: Draw into the texture
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
    
    CC_NODE_DRAW_SETUP();
    
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    
    // Gradient
    float gradientAlpha = 0.7;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
    vertices[nVertices] = CGPointMake(size.width, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, size.height);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(size.width, size.height);
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position  | kCCVertexAttribFlag_Color);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);
    ccGLBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    CCSprite *noise = [CCSprite spriteWithFile:@"noise.png" rect:CGRectMake(0, 0, size.width, size.height)];
    
    // Repeat texture
    //    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    //    [noise.texture setTexParameters:&params];
    
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(size.width/2, size.height/2);
    [noise visit];
    
    //    // Top highlight
    //    float borderHeight = size.height;
    //    float borderAlpha = 0.3f;
    //    nVertices = 0;
    //
    //    vertices[nVertices] = CGPointMake(0, 0);
    //    colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
    //    vertices[nVertices] = CGPointMake(size.width, 0);
    //    colors[nVertices++] = (ccColor4F){1, 1, 1, borderAlpha};
    //    vertices[nVertices] = CGPointMake(0, borderHeight);
    //    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    //    vertices[nVertices] = CGPointMake(size.width, borderHeight);
    //    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    //
    //    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    //	  glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);
    //    ccGLBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
    //    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    CC_INCREMENT_GL_DRAWS(1);
    
    // Call CCRenderTexture:end
    [rt end];
    
    // Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
}


-(void)setOpacity:(GLubyte)opacity {
    [super setOpacity:opacity];
    
    [self setOpacity:(GLubyte)opacity toNodeChildren:self];
}

-(void)setOpacity:(GLubyte)opacity toNodeChildren:(CCNode *)node {
    for (CCNode *child in node.children) {
        if ([child conformsToProtocol:@protocol(CCRGBAProtocol)]) {
            CCNode<CCRGBAProtocol> *rgbaChild = (CCNode<CCRGBAProtocol> *)child;
            rgbaChild.opacity = opacity;
        }
        
        if (child.children.count > 0) {
            [self setOpacity:opacity toNodeChildren:child];
        }
    }
}

@end
