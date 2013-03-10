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

@dynamic effectPosition;

static float scale;

+(void)initialize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    } else {
        scale = 1.0;
    }
}

+(id)rangeWithCharacter:(Character *)aCharacter parameters:(NSMutableDictionary*)dict {
    NSString* rangeName = [dict objectForKey:@"rangeType"];
    
    NSAssert(rangeName != nil, @"You must define rangeType for a range");
    
    return [[NSClassFromString(rangeName) alloc] initWithCharacter:aCharacter parameters:dict];
}

-(id)initWithCharacter:(Character *)aCharacter parameters:(NSMutableDictionary*)dict {
    if (self = [super init]) {
        _character = aCharacter;
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
    _sides = [dict objectForKey:@"rangeSides"];
    
    NSAssert(_sides != nil, @"You must define rangeSides for a range");
    
    _filters = [dict objectForKey:@"rangeFilters"];
    
    NSString *file = [dict objectForKey:@"rangeSpriteFile"];
    
    if (file == nil) {
        NSAssert(![[dict objectForKey:@"rangeType"]isEqualToString:kRangeTypeSprite], @"You must define rangeSpriteFile for a range of kRangeTypeSprite");
        [self setSpecialParameter:dict];
        [self setRangeSprite];
    } else {
        // TODO: Maybe each range can set its special parameter based on the sprite.
        _rangeSprite = [CCSprite spriteWithFile:file];
        [self setSpecialParameter:dict];
    }

    // TODO: Move to delay skill
    effectRange = [dict objectForKey:@"rangeEffectRange"];
    
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
    CGContextRef context = CGBitmapContextCreate(NULL, rangeWidth, rangeHeight, 8, rangeWidth * 4, imageColorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 1.0, 0.8, 0.8, 0.8);
    
    CGContextAddPath(context, attackRange);
    CGContextFillPath(context);
    
    // Get CGImageRef
    CGImageRef imgRef = CGBitmapContextCreateImage(context);

    _rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];
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

// Only used for RangeShooter for now
-(CGPoint)effectPosition {
    if (effectRange == nil) {
        CGPoint position = _rangeSprite.position;
        position = [_rangeSprite.parent convertToWorldSpace:position];
        return [_character.sprite.parent convertToNodeSpace:position];
    } else {
        CGPoint position = effectRange.rangeSprite.position;
        position = [effectRange.rangeSprite.parent convertToWorldSpace:position];
        return [_character.sprite.parent convertToNodeSpace:position];
    }
}

-(BOOL)containTarget:(Character *)target {
    
    if (![self checkSide:target]) {
        return NO;
    }
    
    if ([self checkFilter:target]) {
        return NO;
    }
    
    if (attackRange == nil) {
        NSAssert(_rangeSprite.parent == target.sprite.parent, @"Character can't hold a sprite as it's attack range");
        
        if (CGRectIntersectsRect(_rangeSprite.boundingBox, target.boundingBox)) {
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
        loc = [_rangeSprite convertToNodeSpace:loc];

        loc.x = (loc.x - _rangeSprite.boundingBox.size.width/2)* scale  + rangeWidth/2;
        loc.y = (loc.y  - _rangeSprite.boundingBox.size.height/2)* scale  + rangeHeight/2;
        
//        CCLOG(@"%f,%f",loc.x,loc.y);
        
        if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
//            CCLOG(@"Player %d's %@ is under the range", temp.player, temp.name);
            return YES;
        } 
    }
    return NO;
}

-(BOOL)checkSide:(Character *)temp {
    if ([_sides containsObject:kRangeSideAlly]) {
        if (temp.player == _character.player) {
            return YES;
        }
    }
    
    if ([_sides containsObject:kRangeSideEnemy]) {
        if (temp.player != _character.player) {
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
        if (temp == _character) {
            return YES;
        }
    }
    return NO;
}

-(void)dealloc {
    [_rangeSprite removeFromParentAndCleanup:YES];
//    CGPathRelease(attackRange);
}

@end
