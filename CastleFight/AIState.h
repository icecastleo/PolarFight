//
//  AIState.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/7.
//
//

#import <Foundation/Foundation.h>

@class Entity;

@interface AIState : NSObject

-(NSString *)name;

-(void)enter:(Entity *)entity;
-(void)exit:(Entity *)entity;
-(void)updateEntity:(Entity *)entity delta:(float)delta;

-(void)changeState:(AIState *)state forEntity:(Entity *)entity;

@end