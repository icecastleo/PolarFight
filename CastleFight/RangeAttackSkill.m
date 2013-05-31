//
//  TestSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/14.
//
//

#import "RangeAttackSkill.h"
#import "AttackEvent.h"
#import "ProjectileComponent.h"
#import "ProjectileEvent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "AttackerComponent.h"

@implementation RangeAttackSkill
 
-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,@1,kRangeKeyTargetLimit,nil];
        
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeProjectile,kRangeKeyType,@"arrow.png",kRangeKeySpriteFile,nil];

    ProjectileRange *arrow = (ProjectileRange *)[Range rangeWithParameters:dictionary];
    
    CGPoint endPosition = ccp(FLT_MIN, FLT_MIN);
    
    NSArray *entities = [range getEffectEntities];
    
    for (Entity *entity in entities) {
        RenderComponent *enemyRender = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
        
        // Aim enemy & prevent to hit back
        if (direction.direction == kDirectionLeft && enemyRender.sprite.position.x < render.sprite.position.x) {
            endPosition = enemyRender.sprite.position;
            break;
        } else if (direction.direction == kDirectionRight && enemyRender.sprite.position.x > render.sprite.position.x) {
            endPosition = enemyRender.sprite.position;
            break;
        }
    }
    
//    CGPoint endPosition = ccpAdd(render.sprite.position, direction.direction == kDirectionLeft ? ccp(-150, 0) : ccp(150, 0));
    
    if (endPosition.x == FLT_MIN && endPosition.y == FLT_MIN) {
        return;
    }

    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:arrow type:kProjectileTypeParabola startPosition:render.sprite.position endPosition:endPosition time:0.75 block:^(NSArray *entities, CGPoint position) {
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
