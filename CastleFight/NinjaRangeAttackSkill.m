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
#import "SquareRange.h"

@implementation NinjaRangeAttackSkill

const static int kRadius = 80;

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,[NSNumber numberWithInt:kRadius],kRangeKeyRadius,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 2;
    }
    return self;
}

-(void)activeEffect {
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    RenderComponent *render = (RenderComponent *)[self.owner getComponentOfClass:[RenderComponent class]];
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    Entity *target = [[range getEffectEntities] lastObject];
    RenderComponent *targetRender = (RenderComponent *)[target getComponentOfClass:[RenderComponent class]];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:@"weapon.png"];
    event.sprite = sprite;
    event.spriteDirection = kSpriteDirectionDown;
    
    event.type = kProjectileTypeLine;
    
    CGPoint startPosition = [render.sprite.parent convertToWorldSpace:render.sprite.position];
    startPosition = [render.node.parent convertToNodeSpace:startPosition];
    event.startPosition = startPosition;
    
    CGPoint finishPosition = [targetRender.sprite.parent convertToWorldSpace:targetRender.sprite.position];
    finishPosition = [targetRender.node.parent convertToNodeSpace:finishPosition];
    event.finishPosition = ccp(finishPosition.x, startPosition.y);
    
    event.duration = 0.25;
    
    int width = sprite.boundingBox.size.width;
    int height = sprite.boundingBox.size.height;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    event.range = [Range rangeWithParameters:dictionary];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
    };
    event.block = block;
    
    [projectile.projectileEvents addObject:event];
    
//    ProjectileRange *projectileRange = (ProjectileRange *)[Range rangeWithParameters:dictionary];
//    
//    Entity *target = [[range getEffectEntities] lastObject];
//    RenderComponent *targetRender = (RenderComponent *)[target getComponentOfClass:[RenderComponent class]];
//    
//    CGPoint startPosition = [render.sprite.parent convertToWorldSpace:render.sprite.position];
//    CGPoint endPosition = ccp([targetRender.sprite.parent convertToWorldSpace:targetRender.sprite.position].x, startPosition.y);
//    
//    ProjectileEvent *event = [[ProjectileEvent alloc] initWithProjectileRange:projectileRange type:kProjectileTypeLine startWorldPosition:startPosition endWorldPosition:endPosition time:0.25 block:^(NSArray *entities, CGPoint position) {
//        for (Entity *entity in entities) {
//            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
//            event.position = position;
//            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
//            [attack.attackEventQueue addObject:event];
//        }
//    }];
//    
//    [projectile.projectileEventQueue addObject:event];
}


@end
