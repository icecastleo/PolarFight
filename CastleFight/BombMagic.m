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
    
    MagicComponent *magicCom = [self.magicInformation objectForKey:@"MagicComponent"];
    
    NSDictionary *images = magicCom.images;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,[images objectForKey:@"projectileImage"],kRangeKeySpriteFile,nil];
    
    ProjectileRange *projectileRange = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                          magicCom.damage];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:projectileRange type:kProjectileTypeLine startWorldPosition:startPoint endWorldPosition:ccp(startPoint.x+0.1f,startPoint.y+0.1f) time:0.0f block:^(NSArray *entities, CGPoint position) {
        
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attacker = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attacker.attackEventQueue addObject:event];
        }
        
    }];
    
    CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.0f scaleX:2.0f scaleY:2.0f];
    CCSequence *pulseSequence = [CCSequence actions:bigger,[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    [projectile.projectileEventQueue addObject:event];
}

@end
