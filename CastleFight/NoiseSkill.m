//
//  NoiseSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "NoiseSkill.h"
#import "AttackEvent.h"
#import "ProjectileComponent.h"
#import "ProjectileEvent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "AttackerComponent.h"

@implementation NoiseSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@5,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 2;
    }
    return self;
}


-(void)activeEffect {
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    RenderComponent *render = (RenderComponent *)[self.owner getComponentOfClass:[RenderComponent class]];
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,@"arrow.png",kRangeKeySpriteFile,@1,kRangeKeyTargetLimit,nil];
    
    ProjectileRange *projectileRange = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    Entity *target = [[range getEffectEntities] lastObject];
    
    RenderComponent *targetRender = (RenderComponent *)[target getComponentOfClass:[RenderComponent class]];
    
    CGPoint startPosition = [render.sprite.parent convertToWorldSpace:render.sprite.position];
    CGPoint endPosition = [targetRender.sprite.parent convertToWorldSpace:targetRender.sprite.position];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:projectileRange type:kProjectileTypeParabola startWorldPosition:startPosition endWorldPosition:endPosition time:0.75 block:^(NSArray *entities, CGPoint position) {
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
