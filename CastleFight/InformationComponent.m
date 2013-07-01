//
//  InformationComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/24.
//
//

#import "InformationComponent.h"

@interface InformationComponent()
@property (nonatomic,readonly) NSDictionary *information;
@end

@implementation InformationComponent

-(id)initWithInformation:(NSDictionary *)info {
    if (self = [super init]) {
        _information = info;
    }
    return self;
}

-(NSString *)informationForKey:(NSString *)key {
    return [self.information objectForKey:key];
}

@end
