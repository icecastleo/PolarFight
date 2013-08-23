//
//  OrbComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"
#import "TouchComponent.h"

@interface OrbComponent : Component <TouchComponentDelegate>

@property (nonatomic) OrbType type;

@property (nonatomic,readonly) NSDictionary *matchInfo;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)executeMatch:(int)number;

@end
