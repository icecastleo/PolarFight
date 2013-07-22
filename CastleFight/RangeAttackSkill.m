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
#import "AttackerComponent.h"

@implementation RangeAttackSkill
 
-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@80,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
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
    
    CGPoint startPosition = [render.sprite.parent convertToWorldSpace:render.sprite.position];
    startPosition = [render.node.parent convertToNodeSpace:startPosition];
    CGPoint finishPosition = [targetRender.sprite.parent convertToWorldSpace:targetRender.sprite.position];
    finishPosition = [targetRender.node.parent convertToNodeSpace:finishPosition];

    ProjectileEvent *event = [[ProjectileEvent alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:@"arrow.png"];
    event.sprite = sprite;
    event.spriteDirection = kSpriteDirectionDown;
    
    event.startPosition = startPosition;
    event.finishPosition = ccp(finishPosition.x, startPosition.y);
    event.type = kProjectileTypeParabola;
    event.duration = 1.5;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:event.sprite.boundingBox.size.height],kRangeKeyWidth,[NSNumber numberWithInt:event.sprite.boundingBox.size.width],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
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
}

@end
