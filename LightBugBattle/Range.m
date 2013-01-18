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

+(id)rangeWithParameters:(NSMutableDictionary*)dict onCharacter:(Character *)aCharacter {
    NSString* rangeName = [dict objectForKey:@"rangeType"];
    Range *range=  [NSClassFromString(rangeName) alloc];
    [range setParameter:dict];
    [range setSpecialParameter:dict];
    range.character = aCharacter;
    return range;
}

-(void)setCharacter:(Character *)aCharacter {
    character = aCharacter;
    [self setRangeSprite];
    [character.sprite addChild:rangeSprite];
}

-(void)setDirection:(CGPoint)velocity {
    float angleRadians = atan2f(velocity.y, velocity.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    
    rangeSprite.rotation = cocosAngle;
}

-(void)setParameter:(NSMutableDictionary *)dict {
    _sides = [dict valueForKey:@"rangeSides"];
    
    NSAssert(_sides != nil, @"You must define rangeSides for a range");
    
    _filters = [dict valueForKey:@"rangeFilters"];
}

-(void)setSpecialParameter:(NSMutableDictionary *)dict {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a Range subclass", NSStringFromSelector(_cmd)];
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
    
    rangeSprite.position = ccp(character.sprite.boundingBox.size.width/2,character.sprite.boundingBox.size.height/2);
    rangeSprite.zOrder = -1;
    rangeSprite.visible = NO;
    
    scaleRange = rangeSprite.contentSize.width/rangeWidth;
    
}

-(NSMutableArray *)getEffectTargets {
    [self setDirection:character.direction];
    
    NSMutableArray *effectTargets = [NSMutableArray array];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if ([self containTarget:temp]) {
            [effectTargets addObject:temp];
        }
    }
    return effectTargets;
}

-(BOOL)containTarget:(Character *)temp {
    
    if (![self checkSide:temp]) {
        return NO;
    }
    
    if ([self checkFilter:temp]) {
        return NO;
    }
    
    NSMutableArray *points = temp.pointArray;
    
    for (int j = 0; j < [points count]; j++) {
        CGPoint loc = [[points objectAtIndex:j] CGPointValue];
        // Switch coordinate systems
        loc = [temp.sprite convertToWorldSpace:loc];
        loc = [rangeSprite convertToNodeSpace:loc];
        loc.x=loc.x/scaleRange;
        loc.y=loc.y/scaleRange;
        
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
