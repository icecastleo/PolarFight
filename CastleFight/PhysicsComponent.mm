//
//  PhysicsComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/19.
//
//

#import "PhysicsComponent.h"
#import "PhysicsNode.h"
#import "Box2D.h"
#import "RenderComponent.h"

@implementation PhysicsComponent

-(id)initWithPhysicsSystem:(PhysicsSystem *)system renderComponent:(RenderComponent *)render {
    if (self = [super init]) {
        _system = system;
        
        _root = [[PhysicsRoot alloc] init];
        [render.node addChild:_root];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead) {
        for (PhysicsNode *node in _root.children) {
            node.b2Body->SetActive(false);
        }
    } else if (type == kEntityEventRevive) {
        for (PhysicsNode *node in _root.children) {
            node.b2Body->SetActive(true);
        }
    } else if (type == kEntityEventRemoveComponent) {
        for (PhysicsNode *node in _root.children) {
            node.b2Body->GetWorld()->DestroyBody(node.b2Body);
        }
    } else if (type == kEntityEventPrepare) {
        for (PhysicsNode *node in _root.children) {
            node.b2Body->SetActive(false);
        }
    } else if (type == kEntityEventReady) {
        for (PhysicsNode *node in _root.children) {
            node.b2Body->SetActive(true);
        }
    }
}

@end
