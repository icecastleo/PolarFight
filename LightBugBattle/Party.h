//
//  Party.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/10.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface Party : NSObject

@property (nonatomic, retain) NSMutableArray *players;


- (Character *)characterFromName:(NSString *)name player:(int)pNumber;

- (NSArray *)characterFromPlayer:(int)pNumber;

@end
