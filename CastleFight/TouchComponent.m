//
//  TouchComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "TouchComponent.h"
#import "RenderComponent.h"

@implementation TouchComponent

+(NSString *)name {
    static NSString *name = @"TouchComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _touchable = YES;
        
        _canSelect = [[dic objectForKey:@"canSelect"] boolValue];
        _touchSprite = [CCSprite spriteWithFile:[dic objectForKey:@"touchedImage"]];
        _dragImage1 = [dic objectForKey:@"dragImage1"];
        _dragImage2 = [dic objectForKey:@"dragImage2"];
    }
    return self;
}

@end
