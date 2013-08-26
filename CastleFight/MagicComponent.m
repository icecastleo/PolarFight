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
#import "AccumulateAttribute.h"

@implementation MagicComponent

+(NSString *)name {
    static NSString *name = @"MagicComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        NSDictionary *damageAttribute = [dic objectForKey:@"damage"];
        
        _cooldown = [[dic objectForKey:@"cooldown"] floatValue];
        _damage = [[AccumulateAttribute alloc] initWithDictionary:damageAttribute];
        _name = [dic objectForKey:@"magicName"];
        _images = [dic objectForKey:@"magicImages"];
        
        NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys: _damage,@"damage",_images,@"images",nil];
        Magic* magic = [[NSClassFromString(_name) alloc] initWithMagicInformation:magicInfo];
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

-(void)handlePan:(TouchState)state path:(NSArray *)path {
    if (state == kTouchStateMove) {
        // TODO: Draw path
    } else if (state == kTouchStateEnd) {
        [self activeWithPath:path];
    }
}

@end
