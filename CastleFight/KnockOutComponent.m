//
//  KnockOutComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/28.
//
//

#import "KnockOutComponent.h"

@implementation KnockOutComponent

+(NSString *)name {
    static NSString *name = @"KnockOutComponent";
    return name;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEventIsMoveForbidden){
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsMoveForbidden"];
    } else if (type == kEventIsActiveSkillForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsActiveSkillForbidden"];
    }
}

@end
