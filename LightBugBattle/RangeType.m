//
//  AttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeType.h"
#import "Character.h"

@implementation RangeType
@synthesize character,attackRange,rangeSprite;

+(id)initWithParameters:(NSMutableDictionary*) dict
{
    NSString* rangeName =[dict objectForKey:@"rangeName"];
    id range=  [NSClassFromString(rangeName) alloc];
    [range setParameter:dict];
    return range;
    
}

-(void) setCharacter:(Character *)acharacter
{
    character = acharacter;
}


-(void) setRotation:(float) offX:(float) offY
{
    float angleRadians = atanf((float)offY / (float)offX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1* angleDegrees;
    if (offX < 0) {
        cocosAngle += 180;
    }
    rangeSprite.rotation = cocosAngle;
}


-(void)setParameter:(NSMutableDictionary*) dict
{
    

    
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

}

-(void)showPoints {
    
    CGContextRef context = NULL;
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate( NULL, rangeWidth, rangeHeight, 8, rangeWidth * 4, imageColorSpace, kCGImageAlphaPremultipliedLast );
    CGContextSetRGBFillColor( context, 1.0, 0.8, 0.8, 0.8 );
    
    
    
    CGContextAddPath(context, attackRange);
    
    CGContextFillPath(context);
    
    // Get CGImageRef
    CGImageRef imgRef = CGBitmapContextCreateImage( context );
    rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];

    rangeSprite.position=ccp(character.sprite.texture.contentSize.width/2,character.sprite.texture.contentSize.height/2);
    rangeSprite.zOrder = -1;
    rangeSprite.visible = NO;
    [character.sprite addChild:rangeSprite];
}

-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies
{
    NSMutableArray *effectTargets=   [NSMutableArray array];
    for(int i = 0; i<[enemies count];i++)
    {
        Character *temp = (Character*)[enemies objectAtIndex:i];
    
        if ([self containTarget:temp]) {
            [effectTargets addObject:temp];
        }
    }
    return effectTargets;
}

-(BOOL)containTarget:(Character *)temp {
    
    ///determine if this attack can effect self
    if(effectSelfOrNot == effectExceptSelf){
        if(temp == character)
            return NO;
    }
    
    ///determine if can effect ally
    switch (effectSides) {
        case effectSideAlly:
            if(temp.player != character.player)
                return NO;
            break;
        case effectSideEnemy:
            if(temp.player == character.player)
                return NO;
            break;
        case effectSideBoth:
            break;
        default:
            break;
    }
    
    NSMutableArray *points = temp.pointArray;
    for (int j = 0; j < [points count]; j++) {
        CGPoint loc = [[points objectAtIndex:j] CGPointValue];
        // switch coordinate systems
        loc = [temp.sprite convertToWorldSpace:loc];
        loc = [rangeSprite convertToNodeSpace:loc];
        if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
//            [effectTargets addObject:temp];
            CCLOG(@"Player %d's %@ is under the range", temp.player, temp.name);
            return YES;
//            break;
        }
    }
    return NO;
}


- (void) dealloc
{
    CGPathRelease(attackRange);
}

@end
