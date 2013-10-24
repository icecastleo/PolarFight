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
#import "DirectionComponent.h"
#import "DefenderComponent.h"
#import "Box2D.h"
#import "PhysicsNode.h"
#import "PhysicsComponent.h"

@implementation Range

@synthesize width;
@dynamic effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary*)dict {
    NSString *className = [dict objectForKey:kRangeKeyType];
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
    }
    return self;
}

-(void)setOwner:(Entity *)entity {
    _owner = entity;
    
    PhysicsComponent *physics = (PhysicsComponent *)[entity getComponentOfName:[PhysicsComponent name]];
    // Entity will not have a physcis component in scene like menu!
//    NSAssert(physics, @"Range can only be apply on entity who has physics component!");
    
    if (physics) {
        physicsSystem = physics.system;
        
        body = [self createBody];
        
        // Set filter for fixture
        TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    
        for (b2Fixture *f = body->GetFixtureList(); f; f = f->GetNext()) {
            b2Filter filter = b2Filter();
            filter.groupIndex = kPhisicsFixtureGroupRange;
            filter.maskBits = INT16_MIN;
            
            if ([sides containsObject:kRangeSideEnemy]) {
                filter.maskBits += INT16_MAX - pow(2, team.team);
            }
            
            if ([sides containsObject:kRangeSideAlly]) {
                filter.maskBits += pow(2, team.team);
            }
            
            f->SetFilterData(filter);
        }
        
        PhysicsNode *physicsNode = [[PhysicsNode alloc] init];
        physicsNode.b2Body = body;
        
        float cocosRadians = CC_DEGREES_TO_RADIANS(physics.direction.spriteDirection);
        
        if (distance != 0) {
            physicsNode.position = ccpMult(ccpForAngle(cocosRadians), distance);
        }
        
        [physics.root addChild:physicsNode];
    }
}

-(b2Body *)createBody {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
    return nil;
}

-(NSArray *)getEffectEntities {
    NSAssert(physicsSystem, @"You must set an entity as range owner, and it should have a physics component!");
    
    NSMutableArray *rawEntities = [[NSMutableArray alloc] init];
    
    for(Entity* entity in [physicsSystem getCollisionEntitiesWithBody:body]) {
        // Check for valid effect entities!
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

    if ([self checkFilter:entity]) {
        return NO;
    }
    
    return YES;
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
//        RenderComponent *ownerRenderCom = (RenderComponent *)[_owner getComponentOfName:[RenderComponent name]];
//        RenderComponent *obj1RenderCom = (RenderComponent *)[obj1 getComponentOfName:[RenderComponent name]];
//        RenderComponent *obj2RenderCom = (RenderComponent *)[obj2 getComponentOfName:[RenderComponent name]];
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
        DefenderComponent *defender1 = (DefenderComponent *)[obj1 getComponentOfName:[DefenderComponent name]];
        DefenderComponent *defender2 = (DefenderComponent *)[obj2 getComponentOfName:[DefenderComponent name]];
        
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
