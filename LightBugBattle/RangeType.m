//
//  AttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeType.h"
#import "BattleSprite.h"

@implementation RangeType
@synthesize battleSprite,attackRange,rangeSprite;


-(id)initWithSprite:(BattleSprite*) sprite
{
    if( (self=[super init]) ) {
        rangeHeight=100;
        rangeWidth=100;
        battleSprite=sprite;
        [self setParameter];
        [self showPoints];
        
    }
    
    return self;
}

-(void) setRotation:(float) offX:(float) offY
{
    float angleRadians = atanf((float)offY / (float)offX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle =-1* angleDegrees;
    if (offX<0) {
        cocosAngle +=180;
    }
    rangeSprite.rotation = cocosAngle;
}

-(void)setParameter {
    [self doesNotRecognizeSelector:_cmd];
}

-(void)showPoints {
    
    CGContextRef context = NULL;
    CGColorSpaceRef imageColorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate( NULL, rangeWidth, rangeHeight, 8, rangeWidth * 4, imageColorSpace, kCGImageAlphaPremultipliedLast );
    CGContextSetRGBFillColor( context, 1.0, 0.8, 0.8, 0.4 );
    
    
    
    CGContextAddPath(context, attackRange);
    
    CGContextFillPath(context);
    
    // Get CGImageRef
    CGImageRef imgRef = CGBitmapContextCreateImage( context );
    rangeSprite = [CCSprite spriteWithCGImage:imgRef key:nil];

    rangeSprite.position=ccp(battleSprite.texture.contentSize.width/2,battleSprite.texture.contentSize.height/2);
    rangeSprite.zOrder=-1;
    rangeSprite.visible=NO;
    [battleSprite addChild:rangeSprite];
}

-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies
{
    NSMutableArray *effectTargets=   [[NSMutableArray alloc] init];
    for(int i = 0; i<[enemies count];i++)
    {
        BattleSprite *bs = ((BattleSprite*)[enemies objectAtIndex:i]);
    
        ///determine if this attack can effect self
        if(effectSelfOrNot == effectExceptSelf){
        if(bs==battleSprite)
            continue;
        }
        
        
        
        ///determine if can effect ally
        switch (effectSides) {
            case effectSideAlly:
                if(bs.player!=battleSprite.player)
                    continue;
                break; 
            case effectSideEnemy:
                if(bs.player==battleSprite.player)
                    continue;
                break;
            case effectSideBoth:
                break;
            default:
                break;
        }
        
        
        NSMutableArray *points=bs.pointArray;
        for (int j=0; j<[points count]; j++) {
            CGPoint loc=[[points objectAtIndex:j] CGPointValue];
            // switch coordinate systems
            loc=[bs convertToWorldSpace:loc];
            loc=[rangeSprite convertToNodeSpace:loc];
            if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
                [effectTargets addObject:bs];
                CCLOG(@"Player %d is under attack", bs.player);
                break;
            }
        }
    
        
    }
    return effectTargets;
}
CGContextRef CreateARGBBitmapContext(CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = size.width;
    size_t pixelsHigh = size.height;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
    
}

- (void) dealloc
{
    CGPathRelease(attackRange);
	[super dealloc];
}

@end