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

@implementation Range

@dynamic effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary*)dict {
    NSString* className = [dict objectForKey:kRangeKeyType];
    
    NSAssert(className != nil, @"You must define rangeType for a range");
    return [[NSClassFromString(className) alloc] initWithParameters:dict];
}

-(id)initWithParameters:(NSMutableDictionary*)dict {
    if (self = [super init]) {
        sides = [dict objectForKey:kRangeKeySide];
        
        NSAssert(sides != nil, @"You must define rangeSides for a range");
        
        filters = [dict objectForKey:kRangeKeyFilter];
        targetLimit = [[dict objectForKey:kRangeKeyTargetLimit] intValue];
        
        NSString *file = [dict objectForKey:kRangeKeySpriteFile];
        
        if (file) {
            // TODO: Maybe each range can set its special parameter based on the sprite.
            _rangeSprite = [CCSprite spriteWithFile:file];
            [self setSpecialParameter:dict];
        } else {
            NSAssert(![[dict objectForKey:kRangeKeyType] isEqualToString:kRangeTypeProjectile], @"You must define a spriteFile for a ProjectileRange!");
            [self setSpecialParameter:dict];
            [self setRangeSprite];
        }
    }
    return self;
}

-(void)setSpecialParameter:(NSMutableDictionary *)dict {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
}

-(void)setRangeSprite {
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, imageColorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 1.0, 0.8, 0.8, 0.8);
    
    CGContextAddPath(context, attackRange);
    CGContextFillPath(context);
    
    // Get CGImageRef
    CGImageRef imgRef = CGBitmapContextCreateImage(context);

    _rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];
}

-(void)setDirection:(CGPoint)velocity {
    float angleRadians = atan2f(velocity.y, velocity.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    
    _rangeSprite.rotation = cocosAngle;
}

-(NSArray *)getEffectEntities {
    NSAssert(_owner, @"You must set an entity as range owner!");
    
    NSMutableArray *rawEntities = [[NSMutableArray alloc] init];
    
    for(Entity* entity in [_owner getAllEntitiesPosessingComponentOfClass:[CollisionComponent class]]) {
        if ([self containEntity:entity]) {
            [rawEntities addObject:entity];
        }
    }
    
    NSArray *entities = [self sortEntities:rawEntities];
    
    for (int i = 0; i < entities.count; i++) {
        Entity *entity = entities[i];
        DefenderComponent *defender = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
        CCLOG(@"%d: %d", i, defender.hp.currentValue);
    }
    
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
    
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    if (attackRange == nil) {
        NSAssert(_rangeSprite.parent == renderCom.sprite.parent, @"Sprites must have the same parent! Might happen when a character hold a sprite as it's attack range");
        
        if (CGRectIntersectsRect(_rangeSprite.boundingBox, renderCom.sprite.boundingBox)) {
            return YES;
        } else {
            return NO;
        }
    }
    
    CollisionComponent *collisionCom = (CollisionComponent *)[entity getComponentOfClass:[CollisionComponent class]];
    
    NSMutableArray *points = collisionCom.points;
    
    for (int j = 0; j < [points count]; j++) {
        CGPoint loc = [[points objectAtIndex:j] CGPointValue];
        // Switch coordinate systems
        loc = [renderCom.sprite convertToWorldSpace:loc];
        loc = [_rangeSprite convertToNodeSpace:loc];

        loc.x = (loc.x - _rangeSprite.boundingBox.size.width/2)* kScale + width/2;
        loc.y = (loc.y - _rangeSprite.boundingBox.size.height/2)* kScale + height/2;
        
//        CCLOG(@"%f,%f",loc.x,loc.y);
        
        if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
//            CCLOG(@"Player %d's %@ is under the range", temp.player, temp.name);
            return YES;
        } 
    }
    return NO;
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
//        float distance1 = ccpDistance(ownerRenderCom.sprite.position, obj1RenderCom.sprite.position);
//        float distance2 = ccpDistance(ownerRenderCom.sprite.position, obj2RenderCom.sprite.position);
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
    CGPoint position = _rangeSprite.position;
    return [_rangeSprite.parent convertToWorldSpace:position];
}

-(void)dealloc {
    [_rangeSprite removeFromParentAndCleanup:YES];
//    CGPathRelease(attackRange);
}

@end
