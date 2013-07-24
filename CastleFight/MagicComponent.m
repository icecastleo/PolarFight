//
//  MagicComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/2.
//
//

#import "MagicComponent.h"
#import "Attribute.h"
#import "Magic.h"

@implementation MagicComponent

-(id)initWithDamageAttribute:(Attribute *)damage andMagicName:(NSString*)name andNeedImages:(NSDictionary *)images {
    if (self = [super init]) {
        _damage = damage;
        _name = name;
        _images = images;
        
        NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys: damage,@"damage",images,@"images",nil];
        Magic* magic = [[NSClassFromString(name) alloc] initWithMagicInformation:magicInfo];
        _rangeSize = magic.rangeSize;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventLevelChanged) {
        [_damage updateValueWithLevel:[message intValue]];
    } 
}

-(void)activeWithPath:(NSArray *)path {
    _canActive = YES;
    _path = path;
}

-(void)didExecute {
    _canActive = NO;
    _path = nil;
}

@end
