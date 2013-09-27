//
//  CharacterComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "CharacterComponent.h"
#import "PlayerComponent.h"
#import "TeamComponent.h"

@implementation CharacterComponent

+(NSString *)name {
    static NSString *name = @"CharacterComponent";
    return name;
}

-(id)initWithCid:(NSString *)cid type:(CharacterType)type name:(NSString *)name {
    if (self = [super init]) {
        _cid = cid;
        _type = type;
        _name = name;
    }
    return self;
}

-(void)setPlayer:(PlayerComponent *)player {
    if (_player) {
        player.armiesCount--;
    }
    
    _player = player;
    _player.armiesCount++;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead) {
        _player.armiesCount--;
    } else if (type == kEntityEventRevive) {
        _player.armiesCount++;
    }
}

@end
