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

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
        NSDictionary *images = [self.magicInformation objectForKey:@"images"];
        CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
        self.rangeSize = CGSizeMake(sprite.boundingBox.size.width*2, sprite.boundingBox.size.width*2);
    }
    return self;
}

-(void)active {
    if (!self.entityFactory.mapLayer || !self.magicInformation) {
        return;
    }
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *startValue = [path objectAtIndex:0];
    CGPoint startPoint = startValue.CGPointValue;    
    NSDictionary *images = [self.magicInformation objectForKey:@"images"];

    ProjectileEvent *event = [[ProjectileEvent alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
    event.sprite = sprite;
    event.spriteDirection = kSpriteDirectionDown;
    
    event.type = kProjectileTypeInstant;
    event.startPosition = startPoint;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:self.rangeSize.width],kRangeKeyWidth,[NSNumber numberWithInt:self.rangeSize.height],kRangeKeyHeight,nil];
    event.range = [Range rangeWithParameters:dictionary];
    
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 [self.magicInformation objectForKey:@"damage"]];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
            [attack.attackEventQueue addObject:event];
        }
    };
    event.block = block;
    
    CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.0f scaleX:2.0f scaleY:2.0f];
    CCSequence *pulseSequence = [CCSequence actions:bigger,[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfClass:[ProjectileComponent class]];
    [projectile.projectileEvents addObject:event];
}

@end
