//
//  AuraComponent.h
//  CastleFight
//
//  Created by  DAN on 13/6/7.
//
//

#import "StateComponent.h"

@interface AuraComponent : StateComponent
@property (nonatomic,readonly) NSMutableDictionary *auras;
@property (nonatomic) BOOL infinite;
@end
