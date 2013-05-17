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

@implementation Range

@dynamic effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary*)dict {
    NSString* rangeName = [dict objectForKey:kRangeKeyType];
    
    NSAssert(rangeName != nil, @"You must define rangeType for a range");
    
    return [[NSClassFromString(rangeName) alloc] initWithParameters:dict];
}

-(id)initWithParameters:(NSMutableDictionary*)dict {
    if (self = [super init]) {
        [self setParameter:dict];
    }
    return self;
}

-(void)setDirection:(CGPoint)velocity {
    float angleRadians = atan2f(velocity.y, velocity.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    
    _rangeSprite.rotation = cocosAngle;
}

-(void)setParameter:(NSMutableDictionary *)dict {    
    _sides = [dict objectForKey:kRangeKeySide];
    
    NSAssert(_sides != nil, @"You must define rangeSides for a range");
    
    _filters = [dict objectForKey:kRangeKeyFilter];
    
    NSString *file = [dict objectForKey:kRangeKeySpriteFile];
    
    if (file == nil) {
        NSAssert(![[dict objectForKey:kRangeKeyType] isEqualToString:kRangeTypeSprite], @"You must define spriteFile for a range of kRangeTypeSprite");
        [self setSpecialParameter:dict];
        [self setRangeSprite];
    } else {
        // TODO: Maybe each range can set its special parameter based on the sprite.
        _rangeSprite = [CCSprite spriteWithFile:file];
        [self setSpecialParameter:dict];
    }
    
    NSNumber *limit = [dict objectForKey:kRangeKeyTargetLimit];

    if(limit != nil) {
        targetLimit = [limit intValue];
    }

    // TODO: Move to delay skill
    effectRange = [dict objectForKey:kRangeKeyEffectRange];
    
    if (effectRange != nil) {
        [_rangeSprite addChild:effectRange.rangeSprite];
        effectRange.rangeSprite.position = ccp(_rangeSprite.boundingBox.size.width / 2, 0);
        effectRange.rangeSprite.visible = NO;
    }    
}

-(void)setSpecialParameter:(NSMutableDictionary *)dict {
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
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

-(void)setOwner:(Entity *)owner {
    if (_rangeSprite) {
        NSAssert(_rangeSprite.parent == nil, @"Do you set the owner twice?");
        
        RenderComponent *renderCom = (RenderComponent *)[owner getComponentOfClass:[RenderComponent class]];
        
        NSAssert(renderCom, @"You can't set an eitity without RenderComponent as owner!");
        NSAssert([owner getComponentOfClass:[DirectionComponent class]], @"You can't set an eitity without DirectionComponent as owner!");
        
        _rangeSprite.zOrder = -1;
        _rangeSprite.visible = NO;
        _rangeSprite.position = ccp(renderCom.sprite.boundingBox.size.width/2, renderCom.sprite.boundingBox.size.height/2);
        [renderCom.sprite addChild:_rangeSprite];
    }
    
    _owner = owner;
}

-(NSArray *)getEffectEntities {
    NSAssert(_owner, @"You must set an entity as range owner!");
    
    // FIXME: Do this by direction system?
    DirectionComponent *directionCom = (DirectionComponent *)[_owner getComponentOfClass:[DirectionComponent class]];
    [self setDirection:directionCom.velocity];
    
    NSMutableSet *entitySet = [NSMutableSet set];
    
    for(Entity* entity in [_owner getAllEntitiesPosessingComponentOfClass:[CollisionComponent class]])
    {
        if ([self containEntity:entity]) {
            if (effectRange == nil) {
                [entitySet addObject:entity];
            } else {
                return [effectRange getEffectEntities];
            }
        }
    }
    
    if (targetLimit > 0 && entitySet.count > targetLimit) {
        NSArray *entities = [entitySet allObjects];
        
        // Compare distance between effect position
        NSSortDescriptor *distanceSort = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^NSComparisonResult(Entity *obj1, Entity *obj2) {
            RenderComponent *ownerRenderCom = (RenderComponent *)[_owner getComponentOfClass:[RenderComponent class]];
            RenderComponent *obj1RenderCom = (RenderComponent *)[obj1 getComponentOfClass:[RenderComponent class]];
            RenderComponent *obj2RenderCom = (RenderComponent *)[obj2 getComponentOfClass:[RenderComponent class]];
            
            float distance1 = ccpDistance(ownerRenderCom.sprite.position, obj1RenderCom.sprite.position);
            float distance2 = ccpDistance(ownerRenderCom.sprite.position, obj2RenderCom.sprite.position);
            
            if (distance1 < distance2) {
                return NSOrderedAscending;
            } else if (distance1 > distance2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        
//        // Compare hp
//        NSSortDescriptor *hpSort = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^NSComparisonResult(Entity *obj1, Entity *obj2) {
//            int hp1 = [obj1 getAttribute:kCharacterAttributeHp].currentValue;
//            int hp2 = [obj1 getAttribute:kCharacterAttributeHp].currentValue;
//            
//            if (hp1 < hp2) {
//                return NSOrderedAscending;
//            } else if (hp1 > hp2) {
//                return NSOrderedDescending;
//            } else {
//                return NSOrderedSame;
//            }
//        }];
//        
//        NSArray *sorts = [NSArray arrayWithObjects:distanceSort, hpSort, nil];
        
        NSArray *sorts = [NSArray arrayWithObjects:distanceSort, nil];
        [entities sortedArrayUsingDescriptors:sorts];
        
        NSRange range = NSMakeRange(0, targetLimit);
        
        return [entities subarrayWithRange:range];
    } else {
        return [entitySet allObjects];
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
    
    if ([_sides containsObject:kRangeSideAlly]) {
        if (entityTeam.team == ownerTeam.team) {
            return YES;
        }
    }
    
    if ([_sides containsObject:kRangeSideEnemy]) {
        if (entityTeam.team != ownerTeam.team) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkFilter:(Entity *)entity {
    if (_filters == nil) {
        return NO;
    }
    
    if ([_filters containsObject:kRangeFilterSelf]) {
        if (entity.eid == _owner.eid) {
            return YES;
        }
    }
    return NO;
}

-(CGPoint)effectPosition {
    if (effectRange == nil) {
        CGPoint position = _rangeSprite.position;
        return [_rangeSprite.parent convertToWorldSpace:position];
    } else {
        CGPoint position = effectRange.rangeSprite.position;
        return [effectRange.rangeSprite.parent convertToWorldSpace:position];
    }
}

-(void)dealloc {
    [_rangeSprite removeFromParentAndCleanup:YES];
//    CGPathRelease(attackRange);
}

@end
