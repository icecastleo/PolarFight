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
 
-(void)setOwner:(Entity *)owner {
    RenderComponent *render = (RenderComponent *)[owner getComponentOfName:[RenderComponent name]];
    int width = render.sprite.boundingBox.size.width*10;
    int height = render.sprite.boundingBox.size.height*5;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    range = [Range rangeWithParameters:dictionary];
    
    [super setOwner:owner];
    
    self.cooldown = 2;
}

-(void)activeEffect {
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfName:[ProjectileComponent name]];
    RenderComponent *render = (RenderComponent *)[self.owner getComponentOfName:[RenderComponent name]];
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
    
    Entity *target = [[range getEffectEntities] lastObject];
    RenderComponent *targetRender = (RenderComponent *)[target getComponentOfName:[RenderComponent name]];
    
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
    
    int width = sprite.boundingBox.size.width;
    int height = sprite.boundingBox.size.height;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    event.range = [Range rangeWithParameters:dictionary];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
            [attack.attackEventQueue addObject:event];
        }
    };
    event.block = block;
    
    [projectile.projectileEvents addObject:event];
}

@end
