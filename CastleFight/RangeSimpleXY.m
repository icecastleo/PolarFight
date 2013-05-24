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
@implementation RangeSimpleXY

-(void)setSpecialParameter:(NSMutableDictionary*) dict {
    
    int radius;
    NSNumber *r = [dict valueForKey:kRangeKeyRadius];
    
    if(r != nil) {
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        radius = [r intValue];
    } else {
        radius = 50;
    }
    
    radius *= kScale;
    width = radius*2;
    height = radius*2;
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, width/2, height/2);
    CGPathAddArc(attackRange, NULL, width/2, height/2, radius, 90/(-2), 90/2, NO);
    CGPathCloseSubpath(attackRange);
    
    yInterval=[NSArray arrayWithObjects:@0,@200,@400, nil];
    
}
-(NSArray *)getEffectEntities {
    NSAssert([super owner], @"You must set an entity as range owner!");
    
    NSMutableArray *rawEntities = [[NSMutableArray alloc] init];
    
    for(Entity* entity in [[super owner] getAllEntitiesPosessingComponentOfClass:[CollisionComponent class]]) {
        if ([self containEntity:entity]) {
            [rawEntities addObject:entity];
        }
    }
    
    NSArray *entities = [self sortEntities:rawEntities];
    
    for (int i = 0; i < entities.count; i++) {
        Entity *entity = entities[i];
        DefenderComponent *defender = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
        CCLOG(@"%d: %d", i, defender.hp.currentValue);
    }
    
    if (targetLimit > 0 && entities.count > targetLimit) {
        NSRange range = NSMakeRange(0, targetLimit);
        return [entities subarrayWithRange:range];
    } else {
        return entities;
    }
}

-(BOOL)containEntity:(Entity *)entity {
    
    if (![super checkSide:entity]) {
        return NO;
    }
    
    if ([super checkFilter:entity]) {
        return NO;
    }
    
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    RenderComponent *selfRenderCom = (RenderComponent *)[self.owner getComponentOfClass:[RenderComponent class]];
    DirectionComponent *selfDirectionCom = (DirectionComponent *)[self.owner getComponentOfClass:[DirectionComponent class]];
    
    CGPoint c0= selfDirectionCom.velocity;
    
    int direction = c0.x>0?1:-1;
    
    CGPoint  c1=selfRenderCom.position;
    CGPoint c2 =renderCom.position;
    if (![self checkInterval:c1.y another:c2.y]) {
        return NO;
    }
    
    
    if((c2.x-c1.x)*direction<width/2)
    {
        return YES;
    }else{
    
        return NO;
    }
   
}

-(BOOL) checkInterval:(int) a another:(int) b
{
    int region = 0;
    for (; region<yInterval.count; region++) {
        if([[yInterval objectAtIndex:region] intValue]>a)
            break;
            
    }
    
    for (int i =0; i<=region; i++) {
        if([[yInterval objectAtIndex:region] intValue]>b)
        {
            if(i==region)
                return YES;
        }
    }
    return NO;

}



@end
