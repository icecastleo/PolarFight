//
//  EntityEventDelegate.h
//  CastleFight
//
//  Created by 朱 世光 on 13/6/20.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@protocol EntityEventDelegate <NSObject>

@optional
-(void)receiveEvent:(EntityEvent)type Message:(id)message;

@end
