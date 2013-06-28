//
//  testMagic.m
//  CastleFight
//
//  Created by  DAN on 13/6/25.
//
//

#import "testMagic.h"
#import "ProjectileEvent.h"
#import "ProjectileRange.h"
#import "ProjectileComponent.h"
#import "AttackerComponent.h"
#import "AccumulateAttribute.h"

@implementation testMagic

-(void)active {
    if (!self.map || !self.information) {
        NSLog(@"return");
        return;
    }
    
    NSLog(@"magic active");
    
    NSArray *path = [self.information objectForKey:@"path"];
    NSValue *startValue = [path objectAtIndex:0];
    CGPoint startPoint = startValue.CGPointValue;
    
    CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.0f scaleX:2.0f scaleY:2.0f];
    CCSequence *pulseSequence = [CCSequence actions:bigger,[CCFadeOut actionWithDuration:0.5f], nil];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,@"nicefire.png",kRangeKeySpriteFile,[NSNumber numberWithBool:YES],kRangeKeyIsPiercing,nil];
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    
    ProjectileRange *arrow = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"100" forKey:@"c"];

    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                          [[AccumulateAttribute alloc] initWithDictionary:dic]];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:arrow type:kProjectileTypeLine startPosition:startPoint endPosition:ccp(startPoint.x+0.1f,startPoint.y+0.1f) time:0.0f block:^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            NSLog(@"magic attack");
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = startPoint;
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
    }];
    event.finishAction = pulseSequence;
    [projectile.projectileEventQueue addObject:event];
}

@end
