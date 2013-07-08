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
@implementation ThreeLineMapLayer
int repeat = kMapPathMaxLine;
int ActiveLine = 0;
-(void)setMap:(NSString *)name {
    
    CCParallaxNode *node = [CCParallaxNode node];
    
    
    CCSprite *preloadMap = [CCSprite spriteWithFile:@"ice.png"];
    int width = preloadMap.boundingBox.size.width;
    int height = preloadMap.boundingBox.size.height;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"ice.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp((width-1)*i, 0)];
    }
    
    [self addChild:node];
    self.contentSize = CGSizeMake(width*repeat, height);
    
    [self initLineSelect];
}

-(void)addEntity:(Entity *)entity {
    int line = arc4random_uniform(kMapPathMaxLine);
    [self addEntity:entity line:line];
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



-(void) summonEntity:(Entity *)entity
{
    int line = ActiveLine;//arc4random_uniform(3);
    [self addEntity:entity line:line];
    
    //TO DO: Need Something to examine if need select line
    SelectableComponent *team = (SelectableComponent *)[entity getComponentOfClass:[SelectableComponent class]];
    
    if(!team)
        [self showLineSelect];
}

-(void) showLineSelect{
    lineSelectMenu.visible=YES;
    lineSelectMenu.enabled=YES;
}

CCMenu *lineSelectMenu;
-(void) initLineSelect
{
    lineSelectMenu =[CCMenu menuWithItems: nil];
    for(int i =0;i<repeat;i++){
        
        
        CCMenuItem *testMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"rightarrow.png"] selectedSprite:[CCSprite spriteWithFile:@"rightarrow.png"] block:^(id sender) {
//            lineSelectMenu.visible=NO;
//            lineSelectMenu.enabled=NO;
            ActiveLine=i;
        }];
        
        
        testMenuItem.position = ccp(50, kMapPathFloor + i*kMapPathHeight+50);
        [lineSelectMenu addChild:testMenuItem];
        
    }
    //[self addChild:lineSelectMenu];
    lineSelectMenu.position=CGPointZero;
//    lineSelectMenu.visible=NO;
//    lineSelectMenu.enabled=NO;
    lineSelectMenu.zOrder=10000;
}

-(void) setParent:(CCNode *)parent{

    [super setParent:parent];
    [parent addChild:lineSelectMenu];
}

@end
