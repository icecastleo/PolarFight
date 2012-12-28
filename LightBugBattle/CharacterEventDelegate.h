//
//  CharacterEventHandler.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/11.
//
//

#import <Foundation/Foundation.h>
#import <AttackEvent.h>

@protocol CharacterEventDelegate <NSObject>

@optional

-(BOOL)characterShouldStartRound:(Character *)sender;
//-(void)characterWillStartRound:(Character *)sender;

-(BOOL)characterShouldMove:(Character *)sender;

-(BOOL)characterShouldAttack:(Character *)sender;
-(void)character:(Character *)sender willSendAttackEvent:(AttackEvent*)event;

-(void)character:(Character *)sender didReceiveDamageEvent:(DamageEvent*)event;
-(void)character:(Character *)sender didReceiveDamage:(Damage*)damage;

// Even if round start was skipped, round end phrase will run.
-(void)characterDidRoundEnd:(Character *)sender;

@end
