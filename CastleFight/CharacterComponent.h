//
//  CharacterComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"

typedef enum {
    kCharacterTypeUnique,
    kCharacterTypeNormal,
} CharacterType;

@interface CharacterComponent : Component {
    
}

@property (readonly) NSString *cid;
@property (readonly) CharacterType type;
@property (readonly) NSString *name;

-(id)initWithCid:(NSString *)cid type:(CharacterType)type name:(NSString *)name;

@end
