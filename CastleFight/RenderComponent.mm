//
//  RenderComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RenderComponent.h"
#import "CCSkeletonAnimation.h"


@implementation RenderComponent

@dynamic position;

+(NSString *)name {
    static NSString *name = @"RenderComponent";
    return name;
}

-(id)initWithSprite:(CCNode *)sprite {
    if ((self = [super init])) {
        // node's position is the sprite center
        
        // FIXME: Does node need to be a RGBANode? (For some entity event...)
        _node = [CCNode node];
        
        _sprite = sprite;
        [_node addChild:sprite];
        
        // Make sprite center to be the node's position
        if ([sprite isKindOfClass:[CCSkeletonAnimation class]]) {
            _isSpineNode = YES;
            _sprite.position = ccp(0, -sprite.boundingBox.size.height/2);
        } else if ([sprite isKindOfClass:[CCSprite class]]) {
            _sprite.position = ccpMult([(CCSprite *)sprite offsetPosition], -1);
        } else {
            NSAssert(NO, @"Did you use a CCNode?");
        }

        _spriteBoundingBox = _sprite.boundingBox;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventPrepare) {
        CCSprite *sprite = (CCSprite *)_sprite;
        sprite.opacity = 127;
    } else if (type == kEntityEventReady) {
        CCSprite *sprite = (CCSprite *)_sprite;
        sprite.opacity = 255;
    }
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

//-(void)receiveEvent:(EntityEvent)type Message:(id)message {
//    if (type == kEntityEventRemoveComponent) {
//        [_node removeFromParentAndCleanup:YES];
//    }
//
//    // TODO: Revive event
//}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        if (self.enableShadowPosition) {
            _node.position = ccpSub(position, shadowOffset);
        } else {
            _node.position = position;
        }
    }
}

-(CGPoint)position {
    @synchronized(self) {
        if (self.enableShadowPosition) {
            return ccpAdd(_node.position, shadowOffset);
        } else {
            return _node.position;
        }
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

-(void)stopAnimation {
    if (self.isSpineNode) {
        CCSkeletonAnimation* animationNode = (CCSkeletonAnimation* )self.sprite;
        [animationNode clearAnimation];
        [self.sprite stopActionByTag:kAnimationActionTag];
    } else {
        [self.sprite stopActionByTag:kAnimationActionTag];
    }
}

-(void)flip:(Direction)direction {
    if (self.isSpineNode) {
        switch (direction) {
            case kDirectionLeft: {
                CCSkeletonAnimation *animationNode = (CCSkeletonAnimation *)self.sprite;
                [animationNode setScaleX:-1];
                break;
            }
            case kDirectionRight: {
                CCSkeletonAnimation *animationNode = (CCSkeletonAnimation *)self.sprite;
                [animationNode setScaleX:1];
                break;
            }
            default:
                break;
        }
    }
}

@end
