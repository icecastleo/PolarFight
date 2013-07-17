//
//  ParalysisComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/24.
//
//

#import "ParalysisComponent.h"

@implementation ParalysisComponent

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEventIsMoveForbidden){
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsMoveForbidden"];
    } else if (type == kEventIsActiveSkillForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsActiveSkillForbidden"];
    }
}

@end
