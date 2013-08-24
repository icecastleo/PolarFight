//
//  MagicSystem.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "MagicSystem.h"
#import "MapLayer.h"
#import "Magic.h"
#import "MagicComponent.h"
#import "CostComponent.h"
#import "PlayerComponent.h"
#import "TouchComponent.h"
#import "SummonComponent.h"

@implementation MagicSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        NSAssert(entityFactory.mapLayer, @"This system need a map layer!");
    }
    return self;
}

-(void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfName:[MagicComponent name]];
    
    for (Entity *entity in entities) {
        MagicComponent *magicCom = (MagicComponent *)[entity getComponentOfName:[MagicComponent name]];
        TouchComponent *selectableCom = (TouchComponent *)[entity getComponentOfName:[TouchComponent name]];
        CostComponent *costCom = (CostComponent *)[entity getComponentOfName:[CostComponent name]];
        
        PlayerComponent *resourceCom = (PlayerComponent *)[magicCom.spellCaster getComponentOfName:[PlayerComponent name]];
        
        magicCom.currentCooldown -= delta;
        
        BOOL isCostSufficient = [costCom isCostSufficientWithFood:resourceCom.food Mana:resourceCom.mana];
        
        if (isCostSufficient) {
            [entity sendEvent:kEventCancelMask Message:nil];
            
            if (magicCom.currentCooldown <= 0) {
                selectableCom.touchable = YES;
            } else {
                selectableCom.touchable = NO;
            }
        } else {
            [entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:0]];
            selectableCom.touchable = NO;
        }
        
        if (magicCom.canActive && magicCom.currentCooldown <= 0 && isCostSufficient) {
            NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys:magicCom.path,@"path", magicCom.damage,@"damage", magicCom.images,@"images", nil];
            
            Magic* magic = [[NSClassFromString(magicCom.name) alloc] initWithMagicInformation:magicInfo];
            
            SummonComponent *summonCom = (SummonComponent *)[magicCom.entity getComponentOfName:[SummonComponent name]];
            if(summonCom) {
               magic.owner = magicCom.entity;
            } else {
               magic.owner = magicCom.spellCaster; 
            }
            
            magic.entityFactory = self.entityFactory;
            [magic active];
            
            [magicCom didExecute];
            
            magicCom.currentCooldown = magicCom.cooldown;
            resourceCom.food -= costCom.food;
            resourceCom.mana -= costCom.mana;
            
            [entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:magicCom.cooldown]];
        }
    }
}

@end
