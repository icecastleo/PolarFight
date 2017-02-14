//
//  Helper.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper

// Accroding to http://www.3dkingdoms.com/weekly/weekly.php?a=2
+(CGPoint)reflection:(CGPoint)selfPoint vector:(CGPoint)vector target:(CGPoint)targetPoint
{
    // The Normal Vector of the plane the grenade has struck.
    CGPoint nVector = ccpNormalize(ccpSub(selfPoint, targetPoint));
    
    // The new vector after reflecting.
    CGPoint rVector = ccpAdd(ccpMult(nVector, -2 * ccpDot(vector, nVector)),vector);
    
    // For collision point, see http://gamedev.tutsplus.com/tutorials/implementation/when-worlds-collide-simulating-circle-circle-collisions/
    return rVector;
}
@end
