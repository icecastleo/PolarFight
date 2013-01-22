//
//  AttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Range.h"
#import "Character.h"
#import "BattleController.h"

@implementation Range
@synthesize character,rangeSprite;

static float scale;

+(void)initialize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    } else {
        scale = 1.0;
    }
}

+(id)rangeWithParameters:(NSMutableDictionary*)dict {
    NSString* rangeName = [dict objectForKey:@"rangeType"];
    
    NSAssert(rangeName != nil, @"You must define rangeType for a range");
    
    Range *range=  [NSClassFromString(rangeName) alloc];
    [range setParameter:dict];
    
    return range;
}

-(void)setDirection:(CGPoint)velocity {
    float angleRadians = atan2f(velocity.y, velocity.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    
    rangeSprite.rotation = cocosAngle;
}

-(void)setParameter:(NSMutableDictionary *)dict {    
    _sides = [dict objectForKey:@"rangeSides"];
    
    NSAssert(_sides != nil, @"You must define rangeSides for a range");
    
    _filters = [dict objectForKey:@"rangeFilters"];
    
    character = [dict objectForKey:@"rangeCharacter"];
    
    NSAssert(character != nil, @"You must define rangeCharacter for a range");
    
    NSString *file = [dict objectForKey:@"rangeSpriteFile"];
    
    if (file == nil) {
        NSAssert(![[dict objectForKey:@"rangeType"]isEqualToString:kRangeTypeSprite], @"You must define rangeSpriteFile for a range of kRangeTypeSprite");
        [self setSpecialParameter:dict];
        [self setRangeSprite];
    } else {
        // TODO: Maybe each range can set its special parameter based on the sprite.
        rangeSprite = [CCSprite spriteWithFile:file];
        [self setSpecialParameter:dict];
    }

    rangeSprite.zOrder = -1;
    rangeSprite.visible = NO;
    
    effectRange = [dict objectForKey:@"rangeEffectRange"];
    
    if (effectRange != nil) {
        [rangeSprite addChild:effectRange.rangeSprite];
        effectRange.rangeSprite.position = ccp(rangeSprite.boundingBox.size.width, rangeSprite.boundingBox.size.height / 2);
        effectRange.rangeSprite.visible = YES;
    }
}

-(void)setSpecialParameter:(NSMutableDictionary *)dict {
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
}

-(void)setRangeSprite {
    
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( NULL, rangeWidth, rangeHeight, 8, rangeWidth * 4, imageColorSpace, kCGImageAlphaPremultipliedLast );
    CGContextSetRGBFillColor( context, 1.0, 0.8, 0.8, 0.8 );
    
    CGContextAddPath(context, attackRange);
    CGContextFillPath(context);
    
    // Get CGImageRef
    CGImageRef imgRef = CGBitmapContextCreateImage(context);

    rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];    
}

-(NSArray *)getEffectTargets {
    
    NSMutableSet *effectTargets = [NSMutableSet set];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if ([self containTarget:temp]) {
            if (effectRange == nil) {
                [effectTargets addObject:temp];
            } else {
                return [effectRange getEffectTargets];
            }
        }
    }
    return [effectTargets allObjects];
}

-(BOOL)containTarget:(Character *)target {
    
    if (![self checkSide:target]) {
        return NO;
    }
    
    if ([self checkFilter:target]) {
        return NO;
    }
    
    if (attackRange == nil) {
        // Parent's scale must be 1, or it will fail !!
        CGPoint point = [rangeSprite.parent convertToWorldSpace:rangeSprite.boundingBox.origin];
        point = [target.sprite.parent convertToNodeSpace:point];

        CGRect temp = CGRectMake(point.x, point.y, rangeSprite.boundingBox.size.width, rangeSprite.boundingBox.size.height);
        
        if (CGRectIntersectsRect(temp, target.boundingBox)) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSMutableArray *points = target.pointArray;
    
    for (int j = 0; j < [points count]; j++) {
        CGPoint loc = [[points objectAtIndex:j] CGPointValue];
        // Switch coordinate systems

        loc = [target.sprite convertToWorldSpace:loc];
        loc = [rangeSprite convertToNodeSpace:loc];
        CGPoint p = loc;
        loc.x = (loc.x - rangeSprite.boundingBox.size.width/2)* scale  + rangeWidth/2;
        loc.y = (loc.y  - rangeSprite.boundingBox.size.height/2)* scale  + rangeHeight/2;
        
//        CCLOG(@"%f,%f",loc.x,loc.y);
        
        p = [rangeSprite convertToWorldSpace:p];
        p = [rangeSprite.parent.parent convertToNodeSpace:p];
        
        CCLOG(@"%f,%f",p.x,p.y);
        
        if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
//            CCLOG(@"Player %d's %@ is under the range", temp.player, temp.name);
            CCSprite *test = [CCSprite spriteWithFile:@"Red_point.png"];
            test.position = p;
            [rangeSprite.parent.parent addChild:test];
            return YES;
        } else {
            CCSprite *test = [CCSprite spriteWithFile:@"Arrow.png"];
            test.position = p;
            [rangeSprite.parent.parent addChild:test];
        }
    }
    return NO;
}

-(BOOL)checkSide:(Character *)temp {
    if ([_sides containsObject:kRangeSideAlly]) {
        if (temp.player == character.player) {
            return YES;
        }
    }
    
    if ([_sides containsObject:kRangeSideEnemy]) {
        if (temp.player != character.player) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkFilter:(Character *)temp {
    if (_filters == nil) {
        return NO;
    }
    
    if ([_filters containsObject:kRangeFilterSelf]) {
        if (temp == character) {
            return YES;
        }
    }
    return NO;
}

-(void)dealloc {
    [rangeSprite removeFromParentAndCleanup:YES];
//    CGPathRelease(attackRange);
}

@end
