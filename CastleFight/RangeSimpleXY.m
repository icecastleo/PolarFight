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
    
    yInterval=[NSArray arrayWithObjects:@50,@130,@210,@300, nil];
    
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
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    int direction = selfDirectionCom.direction == kDirectionLeft ? -1 : 1;
    
    CGPoint c1 = selfRenderCom.position;
    CGPoint c2 = renderCom.position;
    
    if(character){
        if (![self checkInterval:c1.y another:c2.y]) {
            return NO;
        }
    }
//    int attackRange = (width/2+renderCom.sprite.boundingBox.size.width/2);
    int attackDistance = width/2;
    if((c2.x-c1.x)*direction <= attackDistance &&(c2.x-c1.x)*direction>=0) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)checkInterval:(int)a another:(int)b
{
    int aLine = 0;
    
    for ( ;aLine < yInterval.count; aLine++) {
        if([[yInterval objectAtIndex:aLine] intValue] > a) {
            break;
        }
    }
    aLine--;
    for (int i = 0; i <= aLine+1; i++) {
        if([[yInterval objectAtIndex:i] intValue] > b) {
            if(i == aLine+1)
                return YES;
            else
                return NO;
        }
    }
    return NO;
}



@end
