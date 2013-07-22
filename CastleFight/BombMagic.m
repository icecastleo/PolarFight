//
//  BombMagic.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "BombMagic.h"
#import "ProjectileEvent.h"
#import "ProjectileRange.h"
#import "ProjectileComponent.h"
#import "AttackerComponent.h"
#import "AccumulateAttribute.h"
#import "AttackEvent.h"

@implementation BombMagic

-(void)active {
    if (!self.map || !self.magicInformation) {
        NSLog(@"return");
        return;
    }
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *startValue = [path objectAtIndex:0];
    CGPoint startPoint = startValue.CGPointValue;    
    NSDictionary *images = [self.magicInformation objectForKey:@"images"];

    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithSpriteFile:[images objectForKey:@"projectileImage"] direction:kSpriteDirectionDown];
    event.type = kProjectileTypeInstant;
    event.startPosition = startPoint;
    
    CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:sprite.boundingBox.size.width*2],kRangeKeyWidth,[NSNumber numberWithInt:sprite.boundingBox.size.height*2],kRangeKeyHeight,nil];
    event.range = [Range rangeWithParameters:dictionary];
    
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 [self.magicInformation objectForKey:@"damage"]];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
    };
    event.block = block;
    
    CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.0f scaleX:2.0f scaleY:2.0f];
    CCSequence *pulseSequence = [CCSequence actions:bigger,[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    [projectile.projectileEvents addObject:event];
}

@end
