//
//  MagicComponent.m
//  CastleFight
//
//  Created by  DAN on 13/7/2.
//
//

#import "MagicComponent.h"

@interface MagicComponent()
@property (nonatomic) BOOL isCDOver;
@property (nonatomic) BOOL isCostSufficient;

@end

@implementation MagicComponent

-(id)initWithDamageAttribute:(Attribute *)damage andMagicName:(NSString*)name andNeedImages:(NSDictionary *)images {
    if (self = [super init]) {
        _damage = damage;
        _name = name;
        _images = images;
    }
    return self;
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventTypeLevelChanged) {
        [_damage updateValueWithLevel:[message intValue]];
    } 
}

-(void)activeByEntity:(Entity *)entity andPath:(NSArray *)path {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:path,@"path", self.name,@"name", self,@"MagicComponent",nil];
    [entity sendEvent:kEventSendMagicEvent Message:dic];
    
    [self.entity sendEvent:kEventUseMask Message:@1];
    
}

@end
