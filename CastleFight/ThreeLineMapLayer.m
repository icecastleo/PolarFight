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
    CCMenu *lineSelectMenu;
    int userLine;
}

@end

@implementation ThreeLineMapLayer

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < kMapPathMaxLine; i++) {
            CCMenuItem *lineItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"rightarrow.png"] selectedSprite:[CCSprite spriteWithFile:@"rightarrow.png"] block:^(id sender) {
                userLine = i;
            }];
            
            lineItem.position = ccp(kMapStartDistance/2, kMapPathFloor + i*kMapPathHeight + kMapPathHeight/2);
            [menuItems addObject:lineItem];
        }

        lineSelectMenu = [[CCMenu alloc] initWithArray:menuItems];
        lineSelectMenu.position = ccp(0, 0);
        [self addChild:lineSelectMenu z:INT16_MAX];
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
    
    if (position.x > boundaryLeft && position.x < boundaryRight   && position.y > boundaryBottom && position.y < boundaryTop) {
        return YES;
    }
    
    return NO;
}

@end
