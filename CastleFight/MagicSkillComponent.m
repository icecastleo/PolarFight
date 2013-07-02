//
//  MagicComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "MagicSkillComponent.h"
#import "Magic.h"

@implementation MagicSkillComponent

-(id)init {
    if (self = [super init]) {
        _magicQueue = [[NSMutableArray alloc] init];
        _magics = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    for (Magic *magic in _magics.allValues) {
        magic.owner = entity;
    }
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventSendMagicEvent) {
        if([message isKindOfClass:[NSDictionary class]]) {
            NSString *magicKey = [message objectForKey:@"name"];
            Magic *magic = [self.magics objectForKey:magicKey];
            [magic setInformation:message];
            [self.magicQueue addObject:magic];
        }
    }
}

@end
