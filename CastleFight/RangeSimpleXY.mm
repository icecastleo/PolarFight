//
//  TestRange.m
//  CastleFight
//
//  Created by 陳 謙 on 13/5/23.
//
//

#import "RangeSimpleXY.h"
#import "CollisionComponent.h"
#import "DefenderComponent.h"
#import "RenderComponent.h"
#import "TeamComponent.h"
#import "DirectionComponent.h"
#import "CharacterComponent.h"
#import "Box2D.h"
#import "PhysicsNode.h"

@interface RangeSimpleXY() {
    int radius;
}

@end

@implementation RangeSimpleXY

static NSMutableArray *yInterval;

+(void)initialize {
    yInterval = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= kMapPathMaxLine; i++) {
        [yInterval addObject:[NSNumber numberWithInt:kMapPathFloor + kMapPathHeight * i]];
    }
}

-(id)initWithParameters:(NSMutableDictionary *)dict {
    if (self = [super initWithParameters:dict]) {
        // FIXME: key name
        NSNumber *r = [dict valueForKey:kRangeKeyRadius];
        
        NSAssert(r, @"You must indicate how far you want!");
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        
        radius = [r intValue];
    }
    return self;
}

-(void)setOwner:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    distance = (render.sprite.boundingBox.size.width/2 + radius)/2;
    
    [super setOwner:entity];
}

-(b2Body *)createBody {
    RenderComponent *render = (RenderComponent *)[self.owner getComponentOfName:[RenderComponent name]];
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    
    b2Body *spriteBody = physicsSystem.world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox((float)(radius + render.sprite.boundingBox.size.width/2)/PTM_RATIO/2, (float)kMapPathHeight/PTM_RATIO);
    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.isSensor = true;
    
    spriteBody->CreateFixture(&spriteShapeDef);
    
    return spriteBody;
}

-(BOOL)containEntity:(Entity *)entity {

    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    RenderComponent *ownerRender = (RenderComponent *)[self.owner getComponentOfName:[RenderComponent name]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
    
    CGPoint c1 = ownerRender.position;
    CGPoint c2 = render.position;
    
    if(character){
        if (![self checkInterval:c1.y another:c2.y]) {
            return NO;
        }
    }
    
    return [super containEntity:entity];
}

-(BOOL)checkInterval:(int)a another:(int)b {
    int region = 0;
    
    for ( ;region < yInterval.count; region++) {
        if([[yInterval objectAtIndex:region] intValue] > a) {
            break;
        }
    }
    
    // Hero may out of range!
    if (region == yInterval.count) {
        region--;
    }
    
    for (int i = 0; i <= region; i++) {
        if([[yInterval objectAtIndex:i] intValue] > b) {
            if(i == region) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    return NO;
}

@end
