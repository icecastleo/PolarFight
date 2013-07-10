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
    
    NSDictionary *images = [self.magicInformation objectForKey:@"images"];
    
    //FIXME: image's anchor
    UIImage *image = [UIImage imageNamed:[images objectForKey:@"projectileImage"]];
    CGPoint startPoint = ccp(startValue.CGPointValue.x,startValue.CGPointValue.y+image.size.width/5);
    
    //FIXME: effectRange doesn't have a correct owner.
    NSMutableDictionary *effectRangeDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@10,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
    Range *effectRange = [Range rangeWithParameters:effectRangeDictionary];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,[images objectForKey:@"projectileImage"],kRangeKeySpriteFile,effectRange,kRangeKeyEffectRange,nil];
    
    ProjectileRange *projectileRange = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
//    effectRange.owner = projectileRange.owner;
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 [self.magicInformation objectForKey:@"damage"]];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:projectileRange type:kProjectileTypeLine startWorldPosition:startPoint endWorldPosition:ccp(startPoint.x, startPoint.y-0.1f) time:0.0f block:^(NSArray *entities, CGPoint position) {
        
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
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    [projectile.projectileEventQueue addObject:event];
}

@end
