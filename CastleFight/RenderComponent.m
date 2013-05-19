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
        _sprite = sprite;
        [self addShadow];
    }
    return self;
}

-(void)addShadow {
    CGRect sRect = CGRectMake(0, 0, (int)(_sprite.boundingBox.size.width / kShadowWidthDivisor * CC_CONTENT_SCALE_FACTOR()), (int)(_sprite.boundingBox.size.height/kShadowHeightDivisor * CC_CONTENT_SCALE_FACTOR()));
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel    = 4;
    size_t bytesPerRow      = (sRect.size.width * bitsPerComponent * bytesPerPixel + 7) / 8;
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, sRect.size.width, sRect.size.height, bitsPerComponent, bytesPerRow, imageColorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 0.6);
    
    CGContextFillEllipseInRect(context, sRect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CCSprite *shadow = [CCSprite spriteWithCGImage:imgRef key:nil];
    shadow.position = ccp(_sprite.boundingBox.size.width/2, sRect.size.height / 4);
    [_sprite addChild:shadow z:-1];
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        _sprite.position = ccp(position.x, position.y - _sprite.boundingBox.size.height/kShadowHeightDivisor/2 + _sprite.boundingBox.size.height/2);
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
    label.position =  ccp(self.sprite.boundingBox.size.width/2, self.sprite.boundingBox.size.height);
    label.anchorPoint = CGPointMake(0.5, 0);
    [self.sprite addChild:label];
    
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
