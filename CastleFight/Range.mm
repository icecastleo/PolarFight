//
//  AttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Range.h"
#import "Entity.h"
#import "TeamComponent.h"
#import "RenderComponent.h"
#import "CollisionComponent.h"
#import "DirectionComponent.h"
#import "DefenderComponent.h"
#import "Box2D.h"
#import "PhysicsNode.h"
#import "PhysicsComponent.h"

@implementation Range

@dynamic effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary*)dict {
    NSString* className = [dict objectForKey:kRangeKeyType];
    
    // FIXME: Projectile range
    if ([className isEqualToString:kRangeTypeProjectile]) {
        return nil;
    }
    
    NSAssert(className != nil, @"You must define rangeType for a range");
    return [[NSClassFromString(className) alloc] initWithParameters:dict];
}

-(id)initWithParameters:(NSMutableDictionary*)dict {
    if (self = [super init]) {
        sides = [dict objectForKey:kRangeKeySide];
        
        NSAssert(sides != nil, @"You must define rangeSides for a range");
        
        filters = [dict objectForKey:kRangeKeyFilter];
        targetLimit = [[dict objectForKey:kRangeKeyTargetLimit] intValue];
        
        NSNumber *d = [dict valueForKey:kRangeKeyDistance];
        
        if(d != nil) {
            NSAssert([d intValue] > 0, @"You can not set a distance value below 0!!");
            distance = [d intValue];
        }

        NSString *file = [dict objectForKey:kRangeKeySpriteFile];
        
        if (file) {
            // TODO: Maybe each range can set its special parameter based on the sprite.
//            _rangeSprite = [CCSprite spriteWithFile:file];
//            [self setSpecialParameter:dict];
        } else {
            NSAssert(![[dict objectForKey:kRangeKeyType] isEqualToString:kRangeTypeProjectile], @"You must define a spriteFile for a ProjectileRange!");
//            [self setSpecialParameter:dict];
//            [self setRangeSprite];
        }
    }
    return self;
}

-(b2Body *)createBody {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(void)setOwner:(Entity *)entity {
    _owner = entity;
    
    PhysicsComponent *physics = (PhysicsComponent *)[entity getComponentOfClass:[PhysicsComponent class]];
    // Entity will not have a physcis component in scene like menu!
//    NSAssert(physics, @"Range can only be apply on entity who has physics component!");
    
    if (physics) {
        physicsSystem = physics.system;
        
        body = [self createBody];
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        float cocosRadians = CC_DEGREES_TO_RADIANS(physics.direction.spriteDirection);
        
        if (distance != 0) {
            physicsNode.position = ccpMult(ccpForAngle(cocosRadians), distance);
        }
        
        [physics.root addChild:physicsNode];
    }
}

//-(void)setRangeSprite {
//    
//    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL, width*CC_CONTENT_SCALE_FACTOR(), height*CC_CONTENT_SCALE_FACTOR(), 8, width*CC_CONTENT_SCALE_FACTOR()*4, imageColorSpace, kCGImageAlphaPremultipliedLast);
//    CGContextSetRGBFillColor(context, 1.0, 0.8, 0.8, 0.8);
//    CGContextScaleCTM(context, CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR());
//    CGContextAddPath(context, attackRange);
//    
//    CGContextFillPath(context);
//    
//    // Get CGImageRef
//    CGImageRef imgRef = CGBitmapContextCreateImage(context);
//
//    _rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];
//}

//-(void)setDirection:(CGPoint)velocity {
//    float angleRadians = atan2f(velocity.y, velocity.x);
//    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
//    float cocosDegrees = 270 - angleDegrees;
//    
//    _rangeSprite.rotation = cocosDegrees;
//}

-(NSArray *)getEffectEntities {
    NSAssert(self.owner, @"You must set an entity as range owner!");
    
    NSMutableArray *rawEntities = [[NSMutableArray alloc] init];
    
    for(Entity* entity in [physicsSystem getCollisionEntitiesWithBody:body]) {
        if ([self containEntity:entity]) {
            [rawEntities addObject:entity];
        }
    }
    
    NSMutableArray *detectedEntities = [NSMutableArray array];
    for (int i = 0; i < rawEntities.count; i++) {
        Entity *entity = rawEntities[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsDetectedForbidden"];
        [entity sendEvent:kEventIsDetectedForbidden Message:dic];
        NSNumber *result = [dic objectForKey:@"kEventIsDetectedForbidden"];
        if (!result.boolValue || [sides containsObject:kRangeSideAlly]) {
            [detectedEntities addObject:entity];
        }
    }
    
    NSArray *entities = [self sortEntities:detectedEntities];
    
    if (targetLimit > 0 && entities.count > targetLimit) {
        NSRange range = NSMakeRange(0, targetLimit);
        return [entities subarrayWithRange:range];
    } else {
        return entities;
    }
}

-(BOOL)containEntity:(Entity *)entity {
    
    if (![self checkSide:entity]) {
        return NO;
    }
    
    if ([self checkFilter:entity]) {
        return NO;
    }
    
    return YES;
}

-(BOOL)checkSide:(Entity *)entity {
    TeamComponent *entityTeam = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    TeamComponent *ownerTeam = (TeamComponent *)[_owner getComponentOfClass:[TeamComponent class]];
    
    if ([sides containsObject:kRangeSideAlly]) {
        if (entityTeam.team == ownerTeam.team) {
            return YES;
        }
    }
    
    if ([sides containsObject:kRangeSideEnemy]) {
        if (entityTeam.team != ownerTeam.team) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkFilter:(Entity *)entity {
    if (filters == nil) {
        return NO;
    }
    
    if ([filters containsObject:kRangeFilterSelf]) {
        if (entity.eid == _owner.eid) {
            return YES;
        }
    }
    return NO;
}

-(NSArray *)sortEntities:(NSArray *)entities {
//    // Compare distance between effect position
//    NSSortDescriptor *distanceSort = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^NSComparisonResult(Entity *obj1, Entity *obj2) {
//        RenderComponent *ownerRenderCom = (RenderComponent *)[_owner getComponentOfClass:[RenderComponent class]];
//        RenderComponent *obj1RenderCom = (RenderComponent *)[obj1 getComponentOfClass:[RenderComponent class]];
//        RenderComponent *obj2RenderCom = (RenderComponent *)[obj2 getComponentOfClass:[RenderComponent class]];
//        
//        float distance1 = ccpDistance(ownerRenderCom.position, obj1RenderCom.position);
//        float distance2 = ccpDistance(ownerRenderCom.position, obj2RenderCom.position);
//        
//        if (distance1 < distance2) {
//            return NSOrderedAscending;
//        } else if (distance1 > distance2) {
//            return NSOrderedDescending;
//        } else {
//            return NSOrderedSame;
//        }
//    }];
    
    // Compare hp
    NSSortDescriptor *hpSort = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^NSComparisonResult(Entity *obj1, Entity *obj2) {
        DefenderComponent *defender1 = (DefenderComponent *)[obj1 getComponentOfClass:[DefenderComponent class]];
        DefenderComponent *defender2 = (DefenderComponent *)[obj2 getComponentOfClass:[DefenderComponent class]];
        
        if (defender1 && defender2) {
            if (defender1.hp.currentValue < defender2.hp.currentValue) {
                return NSOrderedAscending;
            } else if (defender1.hp.currentValue > defender2.hp.currentValue) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        } else if (!defender1 && defender2) {
            return NSOrderedAscending;
        } else if (defender1 && !defender2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSArray *sorts = [NSArray arrayWithObjects:hpSort, nil];
    return [entities sortedArrayUsingDescriptors:sorts];
}

-(CGPoint)effectPosition {
    return ccp(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
}

@end
