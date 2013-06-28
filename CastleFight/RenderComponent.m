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
        _node = [CCNode node];
        _sprite = sprite;
        
        // We only use y offset
        offset = ccp(0, _sprite.offsetPosition.y);
        shadowOffset = ccp(0, -_sprite.boundingBox.size.height/2 + _sprite.boundingBox.size.height/kShadowHeightDivisor/4);
        
        [_node addChild:sprite];
        
        if (kShadowVisible) {
            [self addShadow];
        }
    }
    return self;
}

-(void)addShadow {
    CGRect sRect = CGRectMake(0, 0, (int)(_sprite.boundingBox.size.width/kShadowWidthDivisor * CC_CONTENT_SCALE_FACTOR()), (int)(_sprite.boundingBox.size.height/kShadowHeightDivisor * CC_CONTENT_SCALE_FACTOR()));
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = (sRect.size.width * bitsPerComponent * bytesPerPixel + 7)/8;
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, sRect.size.width, sRect.size.height, bitsPerComponent, bytesPerRow, imageColorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetRGBFillColor(context, 0.35, 0.35, 0.35, 1);
    
    CGContextFillEllipseInRect(context, sRect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CCSprite *shadow = [CCSprite spriteWithCGImage:imgRef key:nil];
    shadow.position = ccpAdd(offset, shadowOffset);
    [_node addChild:shadow z:-1];
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        
        if (kShadowPosition) {
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
    label.position =  ccp(0, _sprite.boundingBox.size.height/2);
    label.anchorPoint = CGPointMake(0.5, 0);
    [_node addChild:label];
    
    [label runAction:
     [CCSequence actions:
      [CCScaleTo actionWithDuration:0.1f scale:1.3f],
      [CCSpawn actions:
       [CCScaleTo actionWithDuration:0.3f scale:0.1f],
       [CCFadeOut actionWithDuration:0.3f],nil],
      [CCCallBlock actionWithBlock:^{
         [label removeFromParentAndCleanup:YES];
     }], nil]];
}

@end
