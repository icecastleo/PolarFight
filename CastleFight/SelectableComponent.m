//
//  SelectableComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "SelectableComponent.h"
#import "RenderComponent.h"

#define kSelectedImageTag 99999

@interface SelectableComponent()
{
    BOOL selected;
    CCSprite *selectedSprite;
}
@end

@implementation SelectableComponent

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        selectedSprite = [CCSprite spriteWithFile:[dic objectForKey:@"selectedImage"]];
        _canSelect = YES;
        _hasDragLine = [[dic objectForKey:@"hasDragLine"] boolValue];
        _dragImage1 = [dic objectForKey:@"dragImage1"];
        _dragImage2 = [dic objectForKey:@"dragImage2"];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead){
        [self unSelected];
    }
}

-(void)select {
    if (selected)
        return;
    
    selected = YES;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    
    selectedSprite.position = ccp(render.node.boundingBox.size.width/2,render.node.boundingBox.size.height/2);
    [render.node addChild:selectedSprite z:-1 tag:kSelectedImageTag];
    
}

-(void)unSelected {
    if (!selected)
        return;

    selected = NO;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    [render.node removeChildByTag:kSelectedImageTag cleanup:YES];
}

@end
