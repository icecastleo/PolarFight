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

@implementation LightningMagic

-(void)active {
    if (!self.map || !self.information) {
        NSLog(@"return");
        return;
    }
    
    NSArray *path = [self.information objectForKey:@"path"];
    NSValue *startValue = [path objectAtIndex:0];
    
    //FIXME: image's anchor
    UIImage *image = [UIImage imageNamed:[self.information objectForKey:@"image"]];
    CGPoint startPoint = ccp(startValue.CGPointValue.x,startValue.CGPointValue.y+image.size.width/5);
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,[self.information objectForKey:@"image"],kRangeKeySpriteFile,nil];
    
    ProjectileRange *arrow = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    NSDictionary *damageDic = [self.information objectForKey:@"damage"];
    Attribute *damage = [[AccumulateAttribute alloc] initWithDictionary:damageDic];
    [damage updateValueWithLevel:[[self.information objectForKey:@"level"] intValue]];
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 damage];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:arrow type:kProjectileTypeLine startPosition:startPoint endPosition:ccp(startPoint.x, startPoint.y+0.1f) time:0.0f block:^(NSArray *entities, CGPoint position) {
        
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
        
    }];
    
    CCSequence *pulseSequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    [projectile.projectileEventQueue addObject:event];
}

@end
