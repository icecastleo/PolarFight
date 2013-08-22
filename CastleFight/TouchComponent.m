//
//  TouchComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "TouchComponent.h"
#import "RenderComponent.h"

@interface TouchComponent() {
    CCSprite *selectedSprite;
}
@end

@implementation TouchComponent

+(NSString *)name {
    static NSString *name = @"TouchComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _touchable = YES;
        
        _canSelect = [[dic objectForKey:@"canSelect"] boolValue];
        selectedSprite = [CCSprite spriteWithFile:[dic objectForKey:@"selectedImage"]];
//        _hasDragLine = [[dic objectForKey:@"hasDragLine"] boolValue];
        _dragImage1 = [dic objectForKey:@"dragImage1"];
        _dragImage2 = [dic objectForKey:@"dragImage2"];
    }
    return self;
}

//-(void)receiveEvent:(EntityEvent)type Message:(id)message {
//    if (type == kEntityEventDead) {
//
//        [self unSelected];
//    } else if (type == kEventSelectable) {
//        _canSelect = [message boolValue];
//    }
//}

//-(void)select {
//    if (selected)
//        return;
//    
//    selected = YES;
//    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
//    
//    selectedSprite.position = ccp(render.node.boundingBox.size.width/2,render.node.boundingBox.size.height/2);
//    [render.node addChild:selectedSprite z:-1 tag:kSelectedImageTag];
//    
//}
//
//-(void)unSelected {
//    if (!selected)
//        return;
//
//    selected = NO;
//    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
//    [render.node removeChildByTag:kSelectedImageTag cleanup:YES];
//}

@end
