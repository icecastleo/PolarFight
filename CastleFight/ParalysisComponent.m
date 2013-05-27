//
//  ParalysisComponent.m
//  CastleFight
//
//  Created by  DAN on 13/5/24.
//
//

#import "ParalysisComponent.h"

@implementation ParalysisComponent

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventIsMoveForbidden){
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsMoveForbidden"];
    } else if (type == kEventIsActiveSkillForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsActiveSkillForbidden"];
    }
}

@end
