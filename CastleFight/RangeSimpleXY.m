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
    
    // FIXME: key name
    
    int radius;
    NSNumber *r = [dict valueForKey:kRangeKeyRadius];
    
    if(r != nil) {
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        radius = [r intValue];
    } else {
        radius = 50;
    }
    
    width = kMapPathHeight;
    height = radius*2;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, 0, 0);
    CGPathAddLineToPoint(attackRange, NULL, 0, radius);
    CGPathAddLineToPoint(attackRange, NULL, width, radius);
    CGPathAddLineToPoint(attackRange, NULL, width, 0);
    CGPathAddLineToPoint(attackRange, NULL, 0, 0);
    CGPathCloseSubpath(attackRange);
    
    yInterval = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 3; i++) {
        [yInterval addObject:[NSNumber numberWithInt:kMapPathFloor + kMapPathHeight * i]];
    }
}

-(NSArray *)getEffectEntities {
    NSAssert([super owner], @"You must set an entity as range owner!");
    
    NSMutableArray *rawEntities = [[NSMutableArray alloc] init];
    
    for(Entity* entity in [[super owner] getAllEntitiesPosessingComponentOfClass:[CollisionComponent class]]) {
        if ([self containEntity:entity]) {
            [rawEntities addObject:entity];
        }
    }
    
    NSMutableArray *detectedEntities = [NSMutableArray array];
    for (int i = 0; i < rawEntities.count; i++) {
        Entity *entity = rawEntities[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsDetectedForbidden"];
        [entity sendEvent:kEventIsDetectedForbidden Message:dic];
        NSNumber *result = [dic objectForKey:@"kEventIsDetectedForbidden"];
        if (!result.boolValue || [sides containsObject:kRangeSideAlly]) {
            [detectedEntities addObject:entity];
        }
    }
    
    NSArray *entities = [self sortEntities:detectedEntities];
    
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
    DirectionComponent *directionCom = (DirectionComponent *)[self.owner getComponentOfClass:[DirectionComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint c1 = selfRenderCom.position;
    CGPoint c2 = renderCom.position;
    
    if(character){
        if (![self checkInterval:c1.y another:c2.y]) {
            return NO;
        }
    }
    int attackDistance = width + renderCom.sprite.boundingBox.size.width/2 + selfRenderCom.sprite.boundingBox.size.width/2;
//    int attackDistance = width;
    
    if (directionCom.direction == kDirectionLeft) {
        if (c2.x <= c1.x && (c1.x-c2.x) <= attackDistance) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (c2.x >= c1.x && (c2.x-c1.x) <= attackDistance) {
            return YES;
        } else {
            return NO;
        }
    }
}

-(BOOL)checkInterval:(int)a another:(int)b {
    int region = 0;
    
    for ( ;region < yInterval.count; region++) {
        if([[yInterval objectAtIndex:region] intValue] > a) {
            break;
        }
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
