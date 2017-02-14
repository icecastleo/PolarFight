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
#import "TouchComponent.h"
#import "LineComponent.h"

@implementation ThreeLineMapLayer

-(void)setMap:(NSString *)name {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *map = [CCSprite spriteWithFile:@"christmas.png"];
    map.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:map z:-5];
    
    self.contentSize = winSize;
}

-(void)addEntity:(Entity *)entity {    
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
    
    if (character) {
        [self addEntity:entity line:arc4random_uniform(kMapPathMaxLine)];
    } else {
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        NSAssert(render, @"Need render component to add on map!");
        
        TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;

        // castle
        if (team.team == kPlayerTeam) {
            render.position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/2, winSize.height/2);
        } else {
            render.position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/2, winSize.height/2);
        }
        
        [self addChild:render.node];
    }
}

-(void)addEntity:(Entity *)entity line:(int)line {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    
    CGPoint position;
    
    if (team.team == kPlayerTeam) {
        position = ccp(kMapStartDistance, kMapPathFloor + arc4random_uniform(kMapPathRandomHeight));
//        [prepareEntities setObject:entity forKey:[NSNumber numberWithInt:selectLine]];
//        [entity sendEvent:kEntityEventPrepare Message:nil];
    } else {
        position = ccp(self.boundaryX - kMapStartDistance, kMapPathFloor + arc4random_uniform(kMapPathRandomHeight));
    }

    [self addEntity:entity toPosition:position];

    LineComponent *lineComponent = (LineComponent *)[entity getComponentOfName:[LineComponent name]];
    
    if (lineComponent) {
        lineComponent.line = line;
    }
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

-(BOOL)canSummonCharacterInThisArea:(CGPoint)position {
    int boundaryTop = kMapPathFloor + kMapPathHeight * kMapPathMaxLine;
    int boundaryBottom = kMapPathFloor;
    int boundaryLeft = kMapStartDistance/2;
    int boundaryRight = kMapStartDistance/2 + kMapStartDistance;
    
    if (position.x > boundaryLeft && position.x < boundaryRight && position.y > boundaryBottom && position.y < boundaryTop) {
        return YES;
    }
    
    return NO;
}

-(int)positionConvertToLine:(CGPoint)position {
    int line = (position.y - kMapPathFloor)/kMapPathHeight;
    
    if (line >= kMapPathMaxLine) {
        line = kMapPathMaxLine - 1;
    } else if (line < 0) {
        line = 0;
    }
    return line;
}

@end
