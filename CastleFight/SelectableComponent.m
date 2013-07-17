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
@property (nonatomic) BOOL selected;
@property (nonatomic) CCSprite *selectedSprite;
@end

@implementation SelectableComponent

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _selectedSprite = [CCSprite spriteWithFile:[dic objectForKey:@"selectedImage"]];
        _canSelect = YES;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead){
        [self unSelected];
    }
}

-(void)select {
    if (self.selected) {
        [self unSelected];
    }
    self.selected = YES;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    
    self.selectedSprite.position = ccp(render.node.boundingBox.size.width/2,render.node.boundingBox.size.height/2);
    [render.node addChild:self.selectedSprite z:-1 tag:kSelectedImageTag];
    
}

-(void)unSelected {
    self.selected = NO;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    [render.node removeChildByTag:kSelectedImageTag cleanup:YES];
}

@end
