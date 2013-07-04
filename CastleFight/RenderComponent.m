//
//  RenderComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RenderComponent.h"

@implementation RenderComponent

@synthesize position = _position;

-(id)initWithSprite:(CCSprite *)sprite {
    if ((self = [super init])) {
        // node's position is the sprite center
        _node = [CCNode node];
        _sprite = sprite;
        
        // We only use y offset
        offset = ccp(0, _sprite.offsetPosition.y);
        shadowOffset = ccp(0, -_sprite.boundingBox.size.height/2 + _sprite.boundingBox.size.height * kShadowHeightScale / 4);
        
        [_node addChild:sprite];
    }
    return self;
}

-(void)setEnableShadowPosition:(BOOL)enableShadowPosition {
    _enableShadowPosition = enableShadowPosition;
    
    // Provide shadow for map layer to use!
    if (!_shadow) {
        [self addShadow];
        _shadow.visible = NO;
    }
}

-(void)addShadow {
    if (_shadow) {
        if (_shadow.visible == NO) {
            _shadow.visible = YES;
        }
        return;
    }
    
    CGRect sRect = CGRectMake(0, 0, (int)(_sprite.boundingBox.size.width * kShadowWidthScale * CC_CONTENT_SCALE_FACTOR()), (int)(_sprite.boundingBox.size.height *kShadowHeightScale * CC_CONTENT_SCALE_FACTOR()));
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = (sRect.size.width * bitsPerComponent * bytesPerPixel + 7)/8;
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, sRect.size.width, sRect.size.height, bitsPerComponent, bytesPerRow, imageColorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetRGBFillColor(context, 0.35, 0.35, 0.35, 1);
    
    CGContextFillEllipseInRect(context, sRect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    _shadow = [CCSprite spriteWithCGImage:imgRef key:nil];
    _shadow.position = ccpAdd(offset, shadowOffset);
    [_node addChild:_shadow z:-1];
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        
        if (self.enableShadowPosition) {
            _node.position = ccpSub(ccpSub(position, offset), shadowOffset);
        } else {
            _node.position = ccpSub(position, offset);
        }
    }
}

-(CGPoint)position {
    @synchronized(self) {
        return _position;
    }
}

-(void)addFlashString:(NSString *)string color:(ccColor3B)color {
    CCLabelTTF *label = [CCLabelBMFont labelWithString:string fntFile:@"WhiteFont.fnt"];
    label.color = color;
    label.position =  ccp(0, _sprite.boundingBox.size.height/2 + label.boundingBox.size.height/2);
    label.anchorPoint = CGPointMake(0.5, 0);
    [_node addChild:label];
        
    [label runAction:
     [CCSequence actions:
      [CCScaleTo actionWithDuration:0.0f scale:4.0f],
      [CCScaleTo actionWithDuration:0.4f scale:1.0f],
      [CCDelayTime actionWithDuration:0.15f],
      [CCSpawn actions:
       [CCMoveBy actionWithDuration:0.15f position:ccp(0, label.boundingBox.size.height * 3)],
//       [CCScaleTo actionWithDuration:0.2f scale:0.5f],
       [CCFadeOut actionWithDuration:0.15f],nil],
      [CCCallBlock actionWithBlock:^{
         [label removeFromParentAndCleanup:YES];
     }], nil]];
}

@end
