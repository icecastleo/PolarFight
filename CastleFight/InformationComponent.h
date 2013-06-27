//
//  InformationComponent.h
//  CastleFight
//
//  Created by  DAN on 13/6/24.
//
//

#import "Component.h"

@interface InformationComponent : Component

-(id)initWithInformation:(NSDictionary *)info;

-(NSString *)informationForKey:(NSString *)key;

@end
