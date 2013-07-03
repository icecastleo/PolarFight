//
//  SummonComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/16.
//
//

#import "Component.h"
#import "CharacterInitData.h"
#import "UnitMenuItem.h"

@class PlayerComponent;

@interface SummonComponent : Component {
    
}

@property (weak) PlayerComponent *player;

@property (readonly) CharacterInitData *data;
@property (readonly) int cost;
@property (readonly) float cooldown;

@property (weak) UnitMenuItem *menuItem;

@property float currentCooldown;
@property (readonly) BOOL isCostSufficient;
@property (readonly) BOOL canSummon;

@property (nonatomic) BOOL summon;
@property (nonatomic) BOOL readyToLine;
-(id)initWithCharacterInitData:(CharacterInitData *)initData;

@end
