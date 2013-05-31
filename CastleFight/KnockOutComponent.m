//
//  KnockOutComponent.m
//  CastleFight
//
//  Created by  DAN on 13/5/28.
//
//

#import "KnockOutComponent.h"

@implementation KnockOutComponent

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventIsMoveForbidden){
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsMoveForbidden"];
    } else if (type == kEventIsActiveSkillForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsActiveSkillForbidden"];
    }
}

@end
