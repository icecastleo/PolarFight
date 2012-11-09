//
//  TimeStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "Status.h"

@interface TimeStatus : Status {
    int time;
}

@property (readonly) int time;

-(id) initWithTime:(int) t;
-(void) addTime:(int) t;
-(void) minusTime:(int) t;

@end
