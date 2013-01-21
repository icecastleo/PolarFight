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
//float scaleRange = if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
//                       && [[UIScreen mainScreen] scale] == 2.0;

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

//-(void)setCharacter:(Character *)aCharacter {
//  
//    character = aCharacter;
//    [self setRangeSprite:aCharacter.sprite];
//    [character.sprite addChild:rangeSprite];
//}
//
//-(void)setCarrier:(CCSprite *)sprite{
//    
//    carrierSprite = sprite;
//    [self setRangeSprite:sprite];
//    [sprite addChild:rangeSprite];
//}

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
    
    rangeSprite = [CCSprite spriteWithFile:@"Arrow.png"];
    
    rangeSprite.zOrder = -1;
    rangeSprite.visible = NO;
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

-(NSMutableArray *)getEffectTargets {
    
    NSMutableArray *effectTargets = [NSMutableArray array];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if ([self containTarget:temp]) {
            [effectTargets addObject:temp];
        }
    }
    return effectTargets;
}

-(BOOL)containTarget:(Character *)target {
    
    if (![self checkSide:target]) {
        return NO;
    }
    
    if ([self checkFilter:target]) {
        return NO;
    }
    
    if (attackRange == nil) {
//        CGRect rect = rangeSprite.boundingBox;
//        rect.origin = ccpAdd(rect.origin, rangeSprite.parent.position);
        if (CGRectIntersectsRect(rangeSprite.boundingBox, target.boundingBox)) {
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
        loc.x = loc.x / scale;
        loc.y = loc.y / scale;
        
        CCLOG(@"%f %f",loc.x,loc.y);
        
        if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
//            CCLOG(@"Player %d's %@ is under the range", temp.player, temp.name);
            return YES;
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


//-(void)dealloc {
//    CGPathRelease(attackRange);
//}

@end
