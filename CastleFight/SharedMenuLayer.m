//
//  SharedMenuLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/17.
//
//

#import "SharedMenuLayer.h"
#import "SharedFrameSprite.h"

@interface SharedMenuLayer() {
    CGRect rect;
    int priority;
    
    BOOL isClosing;
}

@end

@implementation SharedMenuLayer

@synthesize frame;

-(id)initWithRect:(CGRect)aRect {
    return [self initWithRect:aRect maskPriotity:kTouchPriorityMask];
}

-(id)initWithRect:(CGRect)aRect maskPriotity:(int)aPriority {
    if (self = [super initWithColor:ccc4(50, 50, 50, 150)]) {
        rect = aRect;
        priority = aPriority;
        
        isClosing = NO;
        
        [self setTouchEnabled:YES];
        
        frame = [[SharedFrameSprite alloc] initWithSize:rect.size];
        frame.position = ccp(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);
        [self addChild:frame];
        
        CCMenuItemSprite *closeButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"close_button.png"] selectedSprite:nil block:^(id sender) {
            [self close];
        }];
        closeButton.position = ccp(frame.boundingBox.size.width - closeButton.boundingBox.size.width*0.75, frame.boundingBox.size.height - closeButton.boundingBox.size.height*0.75);
        
        CCMenu *closeMenu = [CCMenu menuWithItems:closeButton, nil];
        closeMenu.position = CGPointZero;
        [closeMenu setTouchPriority:priority];
        
        [frame addChild:closeMenu];
    }
    return self;
}


-(void)registerWithTouchDispatcher {
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:priority swallowsTouches:YES];
}

-(void)onEnter {
    frame.scale = 1.2;
    
    [frame runAction:[CCSpawn actions:
                      [CCFadeIn actionWithDuration:0.2],
                      [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:1.0] rate:1.50],
                      nil]];
    
    [super onEnter];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(rect, point) == NO) {
        [self close];
    }
}

-(void)close {
    if (isClosing) {
        return;
    }
    
    isClosing = YES;
    
    [frame runAction:[CCSequence actions:
                      [CCSpawn actions:
                       [CCFadeOut actionWithDuration:0.2],
                       [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:1.2] rate:1.50],
                       nil],
                      [CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }], nil]];
}

@end
