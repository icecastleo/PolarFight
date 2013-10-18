//
//  RangeCleanseMagic.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/17.
//
//

#import "RangeCleanseMagic.h"
#import "ProjectileEvent.h"
#import "ProjectileComponent.h"
#import "ParalysisComponent.h"
#import "PoisonComponent.h"

@implementation RangeCleanseMagic

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
        NSDictionary *images = [self.magicInformation objectForKey:@"images"];
        CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
        self.rangeSize = CGSizeMake(sprite.boundingBox.size.width*2, sprite.boundingBox.size.width*2);
    }
    return self;
}

-(void)active {
    if (!self.entityFactory.mapLayer || !self.magicInformation) {
        return;
    }
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *endValue = [path lastObject];
    CGPoint endPosition = endValue.CGPointValue;
    NSDictionary *images = [self.magicInformation objectForKey:@"images"];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
    event.sprite = sprite;
    event.spriteDirection = kSpriteDirectionDown;
    
    event.type = kProjectileTypeInstant;
    event.startPosition = endPosition;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:self.rangeSize.width],kRangeKeyWidth,[NSNumber numberWithInt:self.rangeSize.height],kRangeKeyHeight,nil];
    event.range = [Range rangeWithParameters:dictionary];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            NSArray *stateArray = [NSArray arrayWithObjects:[ParalysisComponent name],[PoisonComponent name], nil];
            for (NSString *componentName in stateArray) {
                StateComponent *stateComponent = (StateComponent *)[entity getComponentOfName:componentName];
                if (stateComponent) {
                    CCLOG(@"entity:%d remove:%@",entity.eid,[[stateComponent class] name]);
                    [entity removeComponent:[[stateComponent class] name]];
                }
            }
        }
    };
    event.block = block;
    
    CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.0f scaleX:2.0f scaleY:2.0f];
    CCSequence *pulseSequence = [CCSequence actions:bigger,[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfName:[ProjectileComponent name]];
    [projectile.projectileEvents addObject:event];
}

@end
