//
//  ThreeLineMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "ThreeLineMapLayer.h"
#import "RenderComponent.h"
#import "TeamComponent.h"
#import "CharacterComponent.h"
#import "SelectableComponent.h"

@interface ThreeLineMapLayer() {
    int userLine;
}
@property (nonatomic) CCLayer *statusLayer;

@end

@implementation ThreeLineMapLayer

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
        userLine = 0;
    }
    return self;
}

-(void)setMap:(NSString *)name {
    CCParallaxNode *node = [CCParallaxNode node];
    
    CCSprite *temp = [CCSprite spriteWithFile:@"ice.png"];
    int width = temp.contentSize.width;
    int height = temp.contentSize.height;
    
    int repeat = 3;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"ice.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp((width-1)*i, 0)];
    }
    
    [self addChild:node];
    self.contentSize = CGSizeMake(width*repeat, height);
}

-(void)addEntity:(Entity *)entity {
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    
    if (team.team == 1) {
        [self addEntity:entity line:userLine];
    } else {
        [self addEntity:entity line:arc4random_uniform(kMapPathMaxLine)];
    }
}

-(void)addEntity:(Entity *)entity line:(int)line {
    if (!self.statusLayer) {
        [self createStatusLayer];
    }
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
        } else {
            position = ccp(self.boundaryX - kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        }
    }
    [self addEntity:entity toPosition:position];
}

-(BOOL)canExecuteMagicInThisArea:(CGPoint)position {
    int boundaryTop = kMapPathFloor + kMapPathHeight * kMapPathMaxLine;
    int boundaryBottom = kMapPathFloor;
    int boundaryLeft = 0;
    int boundaryRight = self.boundaryX;
    
    if (position.x > boundaryLeft && position.x < boundaryRight && position.y > boundaryBottom && position.y < boundaryTop) {
        return YES;
    }
    
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [super ccTouchMoved:touch withEvent:event];
    
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    int line = (location.y - kMapPathFloor)/kMapPathHeight;
    
    if (line >= kMapPathMaxLine) {
        line = kMapPathMaxLine - 1;
    } else if (line < 0) {
        line = 0;
    }
    CCSprite *preLineArrow = (CCSprite *)[self.statusLayer getChildByTag:userLine];
    [preLineArrow setOpacity:128];
    
    userLine = line;
    
    CCSprite *lineArrow = (CCSprite *)[self.statusLayer getChildByTag:userLine];
    [lineArrow setOpacity:255];
}

-(void)createStatusLayer {
    
    _statusLayer = [[CCLayer alloc] init];
    
    for(int i = 0; i < kMapPathMaxLine; i++) {
        CCSprite *lineArrow = [CCSprite spriteWithFile:@"black_arrow.png"];
        lineArrow.position = ccp(lineArrow.boundingBox.size.width/2, kMapPathFloor + i*kMapPathHeight + kMapPathHeight/2);
        [lineArrow setOpacity:128];
        [_statusLayer addChild:lineArrow z:INT16_MAX tag:i];
    }
    
    CCSprite *currentLineArrow = (CCSprite *)[self.statusLayer getChildByTag:userLine];
    [currentLineArrow setOpacity:255];
    
    [self.parent addChild:_statusLayer z:INT16_MAX tag:90124];
}

@end
