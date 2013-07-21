//
//  CircleAttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeCircle.h"
#import "RenderComponent.h"
#import "Box2D.h"

//NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@80,kRangeKeyRadius,@80,kRangeKeyDistance,@1,kRangeKeyTargetLimit,nil];

@interface RangeCircle() {
    int radius;
}

@end

@implementation RangeCircle

-(id)initWithParameters:(NSMutableDictionary *)dict {
    if (self = [super initWithParameters:dict]) {
        NSNumber *r = [dict valueForKey:kRangeKeyRadius];
        
        NSAssert(r, @"You must indicate how far you want!");
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        
        radius = [r intValue];
    }
    return self;
}

-(b2Body *)createBody {
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    
    b2Body *spriteBody = physicsSystem.world->CreateBody(&spriteBodyDef);
    
    b2CircleShape spriteShape;
    spriteShape.m_radius = radius/PTM_RATIO;
   
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.isSensor = true;
    spriteShapeDef.filter.groupIndex = kPhisicsFixtureGroupRange;
    
    spriteBody->CreateFixture(&spriteShapeDef);
    
    return spriteBody;
}

@end
