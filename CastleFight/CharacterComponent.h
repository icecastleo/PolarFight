//
//  CharacterComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"
#import "PlayerComponent.h"

typedef enum {
    kCharacterTypeGeneral,
    kCharacterTypeMinion,
} CharacterType;

@interface CharacterComponent : Component {
    
}

@property (readonly) NSString *cid;
@property (readonly) CharacterType type;
@property (readonly) NSString *name;

@property (nonatomic) PlayerComponent *player;

-(id)initWithCid:(NSString *)cid type:(CharacterType)type name:(NSString *)name;

@end
