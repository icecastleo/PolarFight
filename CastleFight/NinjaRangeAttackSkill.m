//
//  NinjaRangeAttackSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/6/24.
//
//

#import "NinjaRangeAttackSkill.h"
#import "ProjectileComponent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "AttackerComponent.h"
#import "ProjectileRange.h"
#import "ProjectileEvent.h"
#import "AttackEvent.h"

@implementation NinjaRangeAttackSkill

const static int kRadius = 80;

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,[NSNumber numberWithInt:kRadius],kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 2;
    }
    return self;
}

-(void)activeEffect {
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    RenderComponent *render = (RenderComponent *)[self.owner getComponentOfClass:[RenderComponent class]];
    DirectionComponent *direction = (DirectionComponent *)[self.owner getComponentOfClass:[DirectionComponent class]];
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,@"weapon.png",kRangeKeySpriteFile,nil];
    
    ProjectileRange *projectileRange = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    CGPoint endPosition = ccpAdd(render.sprite.position, direction.direction == kDirectionLeft ? ccp(-kRadius, 0) : ccp(kRadius, 0));
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:projectileRange type:kProjectileTypeLine startPosition:render.sprite.position endPosition:endPosition time:0.25 block:^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
    }];
    
    [projectile.projectileEventQueue addObject:event];
}


@end
