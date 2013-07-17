//
//  RenderComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RenderComponent.h"
#import "Box2D.h"
#import "PhysicsNode.h"

@implementation RenderComponent

@synthesize position = _position;

-(id)initWithSprite:(CCSprite *)sprite {
    if ((self = [super init])) {
        // node's position is the sprite center
        _node = [CCNode node];
        
        _sprite = sprite;
        [_node addChild:sprite];
        
        _physicsRoot = [[PhysicsRoot alloc] init];
        [_node addChild:_physicsRoot];
        
        // Make sprite center to be the node's position
        _sprite.position = ccpMult(_sprite.offsetPosition, -1);
        _spriteBoundingBox = _sprite.boundingBox;
    }
    return self;
}

-(id)initWithSpineNode:(CCNode *)spineNode {
    if ((self = [super init])) {
        // node's position is the sprite center
        _node = spineNode;
        _isSpineNode = YES;
        
        // We only use y offset
        offset = ccp(0, _sprite.offsetPosition.y);
        shadowOffset = ccp(0, -_sprite.boundingBox.size.height/2 + _sprite.boundingBox.size.height * kShadowHeightScale / 4);
    }
    return self;
}

-(void)setEnableShadowPosition:(BOOL)enableShadowPosition {
    _enableShadowPosition = enableShadowPosition;
    _shadowSize = CGSizeMake((int)(_sprite.boundingBox.size.width * kShadowWidthScale), (int)(_sprite.boundingBox.size.height * kShadowHeightScale));
    shadowOffset = ccp(0, -_sprite.boundingBox.size.height/2 + _sprite.boundingBox.size.height * kShadowHeightScale / 4);
    
    #if kShadowVisible
    [self addShadow];
    #endif
}

-(void)addShadow {
    CGRect sRect = CGRectMake(0, 0, _shadowSize.width * CC_CONTENT_SCALE_FACTOR(), _shadowSize.height * CC_CONTENT_SCALE_FACTOR());
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = (sRect.size.width * bitsPerComponent * bytesPerPixel + 7)/8;
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, sRect.size.width, sRect.size.height, bitsPerComponent, bytesPerRow, imageColorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextSetRGBFillColor(context, 0.35, 0.35, 0.35, 1);
    
    CGContextFillEllipseInRect(context, sRect);
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CCSprite *shadow = [CCSprite spriteWithCGImage:imgRef key:nil];
    shadow.position = shadowOffset;
    [_node addChild:shadow z:-1];
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        
        if (self.enableShadowPosition) {
            _node.position = ccpSub(position, shadowOffset);
        } else {
            _node.position = position;
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
    label.position =  ccp(0, _sprite.contentSize.height/2 + label.contentSize.height/2);
    label.anchorPoint = CGPointMake(0.5, 0);
    [_node addChild:label];
        
    [label runAction:
     [CCSequence actions:
      [CCScaleTo actionWithDuration:0.0f scale:4.0f],
      [CCScaleTo actionWithDuration:0.4f scale:1.0f],
      [CCDelayTime actionWithDuration:0.15f],
      [CCSpawn actions:
       [CCMoveBy actionWithDuration:0.15f position:ccp(0, label.contentSize.height * 3)],
//       [CCScaleTo actionWithDuration:0.2f scale:0.5f],
       [CCFadeOut actionWithDuration:0.15f],nil],
      [CCCallBlock actionWithBlock:^{
         [label removeFromParentAndCleanup:YES];
     }], nil]];
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead) {
        for (PhysicsNode *node in _physicsRoot.children) {
            node.b2Body->GetWorld()->DestroyBody(node.b2Body);
            [node unscheduleUpdate];
        }
    }
}

@end
