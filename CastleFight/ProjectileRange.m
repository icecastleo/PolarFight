//
//  ProjectileRange.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileRange.h"

@implementation ProjectileRange

-(void)setSpecialParameter:(NSMutableDictionary *)dict {
    _isPiercing = [[dict objectForKey:kRangeKeyIsPiercing] boolValue];
    
    effectRange = [dict objectForKey:kRangeKeyEffectRange];
    
    if (effectRange != nil) {
        [self.rangeSprite addChild:effectRange.rangeSprite];
        effectRange.rangeSprite.position = ccp(self.rangeSprite.boundingBox.size.width/2, 0);
        effectRange.rangeSprite.visible = NO;
    }
}

-(void)setOwner:(Entity *)owner {
    [super setOwner:owner];
    
    if (effectRange) {
        effectRange.owner = owner;
    }
}

-(NSArray *)getEffectEntities {
    NSArray *entities = [super getEffectEntities];
    
    if (entities.count == 0) {
        return entities;
    }
    
    if (effectRange) {
        entities = [effectRange getEffectEntities];
    }
    
    if(!_isPiercing) {
        return entities;
    } else {
        if (piercingEntities == nil) {
            piercingEntities = [[NSMutableDictionary alloc] init];
        }
        
        NSMutableArray *ret = [[NSMutableArray alloc] init];

        for (Entity *entity in entities) {
            if (![piercingEntities objectForKey:entity.eidNumber]) {
                [piercingEntities setObject:entity forKey:entity.eidNumber];
                [ret addObject:entity];
            }
        }
        return ret;
    }
}

-(CGPoint)effectPosition {
    if (effectRange) {
        CGPoint position = effectRange.rangeSprite.position;
        return [effectRange.rangeSprite.parent convertToWorldSpace:position];
    } else {
        return [super effectPosition];
    }
}

@end
