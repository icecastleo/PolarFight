//
//  MagicComponent.m
//  CastleFight
//
//  Created by  DAN on 13/6/25.
//
//

#import "MagicComponent.h"
#import "testMagic.h"

@implementation MagicComponent

-(id)init {
    if (self = [super init]) {
        _magicQueue = [[NSMutableArray alloc] init];
        _magics = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    for (testMagic *magic in _magics.allValues) {
        magic.owner = entity;
    }
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventSendMagicEvent) {
        if([message isKindOfClass:[NSDictionary class]]) {
            NSString *magicKey = [message objectForKey:@"name"];
            testMagic *testM = [self.magics objectForKey:magicKey];
            [testM setInformation:message];
            [self.magicQueue addObject:testM];
        }
    }
}

@end
