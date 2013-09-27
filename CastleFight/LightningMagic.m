//
//  Lightning.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/1.
//
//

#import "LightningMagic.h"
#import "ProjectileEvent.h"
#import "ProjectileComponent.h"
#import "AttackerComponent.h"
#import "AccumulateAttribute.h"
#import "AttackEvent.h"

@implementation LightningMagic

-(id)initWithMagicInformation:(NSDictionary *)magicInfo {
    if (self = [super init]) {
        self.magicInformation = magicInfo;
        NSDictionary *images = [self.magicInformation objectForKey:@"images"];
        CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
        
        int width = sprite.boundingBox.size.height/2;
        int height = sprite.boundingBox.size.width/10;
        self.rangeSize = CGSizeMake(width, height);
    }
    return self;
}

-(void)active {
    if (!self.entityFactory.mapLayer || !self.magicInformation) {
        return;
    }
    
    NSArray *path = [self.magicInformation objectForKey:@"path"];
    NSValue *endValue = [path lastObject];
    CGPoint endPosition = endValue.CGPointValue;
    NSDictionary *images = [self.magicInformation objectForKey:@"images"];
    
    ProjectileEvent *event = [[ProjectileEvent alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:[images objectForKey:@"projectileImage"]];
    event.sprite = sprite;
    event.spriteDirection = kSpriteDirectionDown;
    
    event.type = kProjectileTypeInstant;
    
    event.startPosition = ccp(endPosition.x, endPosition.y+sprite.boundingBox.size.height/2);
    
    int distance = self.rangeSize.width - self.rangeSize.height/2;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:self.rangeSize.width],kRangeKeyWidth,[NSNumber numberWithInt:self.rangeSize.height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,[NSNumber numberWithInt:distance],kRangeKeyDistance,nil];
    event.range = [Range rangeWithParameters:dictionary];
    
    AttackerComponent *attack = [[AttackerComponent alloc] initWithAttackAttribute:
                                 [self.magicInformation objectForKey:@"damage"]];
    
    void(^block)(NSArray *entities, CGPoint position) = ^(NSArray *entities, CGPoint position) {
        for (Entity *entity in entities) {
            AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
            event.position = position;
            AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
            [attack.attackEventQueue addObject:event];
        }
    };
    event.block = block;
    
    CCSequence *pulseSequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.5f], nil];
    event.finishAction = pulseSequence;
    
    ProjectileComponent *projectile = (ProjectileComponent *)[self.owner getComponentOfName:[ProjectileComponent name]];
    [projectile.projectileEvents addObject:event];
}

@end
