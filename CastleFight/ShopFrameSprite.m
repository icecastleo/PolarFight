//
//  ShopItemSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/10.
//
//

#import "ShopFrameSprite.h"

@implementation ShopFrameSprite

-(id)init {
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
        
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"etc.pvr.ccz"];
        [self addChild:batchNode];
        
        CCSprite *lt = [CCSprite spriteWithSpriteFrameName:@"shop_cell_lt.png"];
        lt.anchorPoint = ccp(0, 1);
        lt.position = ccp(-1, 47);
        [batchNode addChild:lt];
        
        CCSprite *rt = [CCSprite spriteWithSpriteFrameName:@"shop_cell_rt.png"];
        rt.anchorPoint = ccp(1, 1);
        rt.position = ccp(403, 47);
        [batchNode addChild:rt];
        
        CCSprite *lb = [CCSprite spriteWithSpriteFrameName:@"shop_cell_lb.png"];
        lb.anchorPoint = ccp(0, 0);
        lb.position = ccp(-1, -1);
        [batchNode addChild:lb];
        
        CCSprite *rb = [CCSprite spriteWithSpriteFrameName:@"shop_cell_rb.png"];
        rb.anchorPoint = ccp(1, 0);
        rb.position = ccp(403, -1);
        [batchNode addChild:rb];

        for (int i = 0; i <= 70; i++) {
            CCSprite *t = [CCSprite spriteWithSpriteFrameName:@"shop_cell_t.png"];
            t.anchorPoint = ccp(0, 1);
            t.position = ccp(23 + i * 5, 47);
            [batchNode addChild:t];
            
            CCSprite *b = [CCSprite spriteWithSpriteFrameName:@"shop_cell_b.png"];
            b.anchorPoint = ccp(0, 0);
            b.position = ccp(23 + i * 5, -1);
            [batchNode addChild:b];
        }
        
        for (int i = 0; i <= 0; i++) {
            CCSprite *l = [CCSprite spriteWithSpriteFrameName:@"shop_cell_l.png"];
            l.anchorPoint = ccp(0, 0);
            l.position = ccp(-1, 19 + i * 7);
            [batchNode addChild:l];
            
            CCSprite *r = [CCSprite spriteWithSpriteFrameName:@"shop_cell_r.png"];
            r.anchorPoint = ccp(1, 0);
            r.position = ccp(403, 19 + i * 7);
            [batchNode addChild:r];
        }
        
        self.contentSize = CGSizeMake(402, 46);
        
        CCSprite *background = [self backgroundWithSize:CGSizeMake(self.contentSize.width - 10, self.contentSize.height) color:ccc4FFromccc3B(ccLIGHTSALMON)];
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
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    CC_INCREMENT_GL_DRAWS(1);
    
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
//	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);
//    glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
//    CC_INCREMENT_GL_DRAWS(1);
    
    CCSprite *noise = [CCSprite spriteWithFile:@"noise.png" rect:CGRectMake(0, 0, size.width, size.height)];
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [noise.texture setTexParameters:&params];
    noise.position = ccp(size.width/2, size.height/2);
    // Should be GL_NERO for the second parameter, but maybe some bug here.
//    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA}];
    [noise visit];

    
    // Call CCRenderTexture:end
    [rt end];
    
    // Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
}

@end
