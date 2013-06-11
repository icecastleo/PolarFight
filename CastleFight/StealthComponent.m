//
//  StealthComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/11.
//
//

#import "StealthComponent.h"

@implementation StealthComponent

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventIsDetectedForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsDetectedForbidden"];
    }
}

@end
