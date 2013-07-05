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
#import "SelectableComponent.h"

@implementation MagicSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory mapLayer:(MapLayer *)map {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        _map = map;
    }
    return self;
}

-(void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[MagicComponent class]];
    
    for (Entity *entity in entities) {
        MagicComponent *magicCom = (MagicComponent *)[entity getComponentOfClass:[MagicComponent class]];
        SelectableComponent *selectableCom = (SelectableComponent *)[entity getComponentOfClass:[SelectableComponent class]];
        CostComponent *costCom = (CostComponent *)[entity getComponentOfClass:[CostComponent class]];
        
        PlayerComponent *resourceCom = (PlayerComponent *)[magicCom.spellCaster getComponentOfClass:[PlayerComponent class]];
        
        magicCom.currentCooldown -= delta;
        
        //FIXME: fix mana resource
        BOOL isCostSufficient = [costCom isCostSufficientWithFood:resourceCom.food Mana:0];
        
        if (isCostSufficient) {
            [entity sendEvent:kEventCancelMask Message:nil];
            
            if (magicCom.currentCooldown <=0) {
                selectableCom.canSelect = YES;
            }else {
                selectableCom.canSelect = NO;
            }
        }else {
            [entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:0]];
            selectableCom.canSelect = NO;
        }
        
        if (magicCom.canActive && magicCom.currentCooldown <=0 && isCostSufficient) {
            Magic* magic = [[NSClassFromString(magicCom.name) alloc] init];
            NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys:magicCom.path,@"path", magicCom.damage,@"damage",magicCom.images,@"images",nil];
            
            magic.owner = magicCom.spellCaster;
            [magic setMagicInformation:magicInfo];
            magic.map = self.map;
            [magic active];
            
            [magicCom didExecute];
            
            magicCom.currentCooldown = magicCom.cooldown;
            resourceCom.food -= costCom.food;
//            resourceCom.mana -= costCom.mana;
            
            [entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:magicCom.cooldown]];
        }
    }
}

@end