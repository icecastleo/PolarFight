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
    
    MagicComponent *magicCom = [self.magicInformation objectForKey:@"MagicComponent"];
    NSDictionary *images = magicCom.images;
    
    //FIXME: image's anchor
    UIImage *image = [UIImage imageNamed:[images objectForKey:@"projectileImage"]];
    CGPoint startPoint = ccp(startValue.CGPointValue.x,startValue.CGPointValue.y+image.size.width/5);
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,[images objectForKey:@"projectileImage"],kRangeKeySpriteFile,nil];
    
    ProjectileRange *arrow = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 magicCom.damage];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:arrow type:kProjectileTypeLine startWorldPosition:startPoint endWorldPosition:ccp(startPoint.x, startPoint.y-0.1f) time:0.0f block:^(NSArray *entities, CGPoint position) {
        NSLog(@"startPoint:%@, event.position:%@",NSStringFromCGPoint(startPoint),NSStringFromCGPoint(position));
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attacker = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attacker.attackEventQueue addObject:event];
            break;
        }
        
    }];
    
    CCSequence *pulseSequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    [projectile.projectileEventQueue addObject:event];
}

@end
