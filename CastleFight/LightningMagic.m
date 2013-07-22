//
//  Lightning.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/1.
//
//

#import "LightningMagic.h"
#import "ProjectileEvent.h"
#import "ProjectileRange.h"
#import "ProjectileComponent.h"
#import "AttackerComponent.h"
#import "AccumulateAttribute.h"
#import "AttackEvent.h"

@implementation LightningMagic

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
    
    CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
    event.startPosition = ccp(startPoint.x,startPoint.y+sprite.boundingBox.size.height/2);
    
    int width = sprite.boundingBox.size.width/10;
    int height = sprite.boundingBox.size.height/2;
    int distance = sprite.boundingBox.size.height/2 - width;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,[NSNumber numberWithInt:distance],kRangeKeyDistance,nil];
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
    
    CCSequence *pulseSequence = [CCSequence actions:[CCFadeOut actionWithDuration:5.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    [projectile.projectileEvents addObject:event];
}

@end
