//
//  TimeStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "Status.h"
@class Character;

@interface TimeStatus : Status {
    int time;
    Character* character;
}

@property (readonly) int time;


-(id) initWithType:(TimeStatusType)statusType withTime:(int)t toCharacter:(Character*)cha;

-(void) addEffect;
-(void) removeEffect;
-(void) update;

-(void) addTime:(int) t;
-(void) minusTime:(int) t;

@end
