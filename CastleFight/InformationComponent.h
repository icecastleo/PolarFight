//
//  InformationComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/24.
//
//

#import "Component.h"

@interface InformationComponent : Component

@property (nonatomic,readonly) NSDictionary *information;

-(id)initWithInformation:(NSDictionary *)info;

@end
