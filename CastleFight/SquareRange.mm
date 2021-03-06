//
//  SquareRange.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/20.
//
//

#import "SquareRange.h"
#import "Box2D.h"
#import "RenderComponent.h"

@interface SquareRange() {
    int height;
}
@end

@implementation SquareRange

-(id)initWithParameters:(NSMutableDictionary *)dict {
    if (self = [super initWithParameters:dict]) {
        NSNumber *w = [dict valueForKey:kRangeKeyWidth];
        NSNumber *h = [dict valueForKey:kRangeKeyHeight];
        
        NSAssert(w && h, @"You must indicate width & height!");
        NSAssert([w intValue] > 0 && [h intValue] > 0, @"You can't set a value below 0!!");

        width = [w intValue];
        height = [h intValue];
        
        distance = width/2;
    }
    return self;
}

-(b2Body *)createBody {
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    
    b2Body *spriteBody = physicsSystem.world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox((float)width/PTM_RATIO/2, (float)height/PTM_RATIO/2);
    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.isSensor = true;
    
    spriteBody->CreateFixture(&spriteShapeDef);
    
    return spriteBody;
}

@end
