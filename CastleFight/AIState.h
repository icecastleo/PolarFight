//
//  AIState.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/7.
//
//

#import <Foundation/Foundation.h>

@class BaseAI;

@interface AIState : NSObject

- (void)enter:(BaseAI *)ai;
- (void)execute:(BaseAI *)ai;
- (void)exit:(BaseAI *)ai;
- (NSString *)name;

@end