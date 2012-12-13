//
//  CharacterEventHandler.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/11.
//
//

#import <Foundation/Foundation.h>
#import <AttackEvent.h>

@protocol CharacterEventHandler <NSObject>

@optional
-(void)handleRoundStartEvent;
-(void)handleAttackEvent:(AttackEvent*)event;
-(void)handleDefenseEvent:(AttackEvent*)event;
-(void)handleRoundEndEvent;

@end
