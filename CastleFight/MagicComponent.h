//
//  MagicComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "Component.h"

@interface MagicComponent : Component

@property (readonly) NSMutableDictionary *magics;
@property (nonatomic) NSMutableArray *magicQueue;

@end
