//
//  InformationComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/24.
//
//

#import "InformationComponent.h"

@implementation InformationComponent

-(id)initWithInformation:(NSDictionary *)info {
    if (self = [super init]) {
        _information = info;
    }
    return self;
}

@end
